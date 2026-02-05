/*
==================================================
Creating Gold Dimension gold.dim_user_table 
==================================================
*/
IF OBJECT_ID('gold.dim_user_table', 'V') IS NOT NULL
    DROP VIEW gold.dim_user_table;
GO

CREATE VIEW gold.dim_user_table AS 
SELECT
        staff_id,                         
        staff_name,              
        job_title,                                
        employee_status,        
        functional_manager,      
        mobile,                  
        country,                 
        department,             
        cost_center,                     
        email 
FROM Silver.user_table
GO

/*
=====================================================
Creating Gold Dimension gold.dim_assets_master_table 
=====================================================
*/

IF OBJECT_ID('gold.dim_assets_master_table', 'V') IS NOT NULL
    DROP VIEW gold.dim_assets_master_table;
GO

CREATE VIEW gold.dim_assets_master_table AS 
SELECT
        product_id,      
        product_name,    
        cost,                  
        manufacturing_date,     
        warranty_period_months,   
        end_of_life_date,        
        product_service_cost   
FROM Silver.assets_master_table
GO

/*
========================================================
Creating Gold Dimension gold.dim_asset_allocation_table 
========================================================
*/

IF OBJECT_ID('gold.dim_asset_allocation_table', 'V') IS NOT NULL
    DROP VIEW gold.dim_asset_allocation_table;
GO

CREATE VIEW gold.dim_asset_allocation_table AS 
SELECT
        product_id,                         
        staff_id,                           
        product_name,              
        serial_number,             
        req_id,                    
        issued_date,                         
        product_cost,                      
        cost_center 
FROM Silver.asset_allocation_table
GO

/*
=====================================================
Creating Gold Dimension gold.dim_store_assets_table 
=====================================================
*/

IF OBJECT_ID('gold.dim_store_assets_table', 'V') IS NOT NULL
    DROP VIEW gold.dim_store_assets_table;
GO

CREATE VIEW gold.dim_store_assets_table AS 
SELECT
        laptop_serial_number,   
        laptop_model,  
        status,
        end_of_life

FROM Silver.store_assets_table
GO

/*
==================================================
Creating Gold Dimension gold.fact_user_info_table
==================================================
*/

IF OBJECT_ID('gold.fact_user_info_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_user_info_table;
GO

CREATE VIEW gold.fact_user_info_table AS 
SELECT
        staff_id,                         
        staff_name,              
        job_title,                                
        employee_status,        
        functional_manager,      
        mobile,                  
        country,                 
        department,             
        cost_center,                     
        email 
FROM Silver.user_table
GO

/*
========================================================
Creating Gold Dimension gold.fact_user_asset_info_table 
========================================================
*/

IF OBJECT_ID('gold.fact_user_asset_info_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_user_asset_info_table;
GO

CREATE VIEW gold.fact_user_asset_info_table AS 

WITH user_asset_info AS 
    (
        SELECT 
            a.issued_date AS [date],
            a.product_id AS product_id,
            a.staff_id AS staff_id,
            NULL AS laptop_model,
            a.serial_number AS laptop_serial_number,
            LTRIM(RTRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(a.product_name, CHAR(160), ' '),
                    CHAR(9), ' '),
                CHAR(10), ' '),
            CHAR(13), ' ')
            )) AS accessories,
            a.req_id,
            'ALLOCATED' AS [status]
        FROM Silver.asset_allocation_table a

        UNION ALL

        SELECT 
            i.[date] AS [date],
            NULL  AS product_id,
            i.staff_id AS staff_id,
            NULL AS laptop_model,
            NULL AS laptop_serial_number,
            LTRIM(RTRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(i.accessories, CHAR(160), ' '),
                    CHAR(9), ' '),
                CHAR(10), ' '),
            CHAR(13), ' ')
            )) AS accessories,
            i.req_id,
            'ISSUED' AS [status]
        FROM Silver.issued_accessories_table i


        UNION ALL

        SELECT 
            b.[date] AS [date],
            NULL  AS product_id,
            b.staff_id AS staff_id,
            b.replaced_asset_model AS laptop_model,
            b.replaced_asset_serial_number AS laptop_serial_number,
            b.replaced_asset_model AS accessories,
            NULL AS req_id,
            'BREAKFIX' AS [status]
        FROM Silver.breakfix_table b

        UNION ALL

        SELECT 
            t.[date] AS [date],
            NULL  AS product_id,
            t.staff_id AS staff_id,
            NULL AS laptop_model,
            NULL AS laptop_serial_number,
            LTRIM(RTRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(t.accessories, CHAR(160), ' '),
                    CHAR(9), ' '),
                CHAR(10), ' '),
            CHAR(13), ' ')
            )) AS accessories,
            NULL AS req_id,
            'TEMPORARY' AS [status]
        FROM Silver.temporary_asset_table t

        UNION ALL

        SELECT 
            h.[date] AS [date],
            NULL AS product_id,
            h.staff_id AS staff_id,
            NULL AS laptop_model,
            NULL AS laptop_serial_number,
            LTRIM(RTRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(h.other_accessories, CHAR(160), ' '),
                    CHAR(9), ' '),
                CHAR(10), ' '),
            CHAR(13), ' ')
            )) AS accessories,
            NULL AS req_id,
            'EXIT/LEFT' AS [status]
        FROM Silver.handover_table h
    ),
    final_clean AS
    (
        SELECT *,
            ROW_NUMBER() OVER(PARTITION BY product_id,staff_id,staff_name,laptop_model,laptop_serial_number,accessories,req_id ORDER BY staff_id) AS rn
        FROM
            (       
                SELECT DISTINCT
                    CASE 
                        WHEN a.product_id IS NULL THEN am.product_id
                        ELSE a.product_id
                    END product_id,
                    a.staff_id,
                    u.staff_name,
                    CASE
                        WHEN a.laptop_model IS NULL AND a.laptop_serial_number IS NOT NULL THEN a.accessories
                        WHEN a.laptop_model IS NULL THEN 'Laptop not issued'
                        ELSE a.laptop_model
                    END laptop_model,
                    CASE
                        WHEN a.laptop_serial_number IS NULL THEN 'Laptop not issued'
                        ELSE a.laptop_serial_number
                    END AS laptop_serial_number,
                    LTRIM(RTRIM(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(a.accessories, CHAR(160), ' '),
                                CHAR(9), ' '),
                            CHAR(10), ' '),
                        CHAR(13), ' ')
                    )) AS accessories,
                    CASE 
                        WHEN a.req_id IS NULL THEN COALESCE(al.req_id,'Request not raised')
                        ELSE a.req_id
                    END AS req_id,
                    a.[status]
                FROM user_asset_info a
                LEFT JOIN Silver.user_table u  
                ON u.staff_id = a.staff_id
                LEFT JOIN Silver.assets_master_table am
                ON am.product_name = a.accessories
                LEFT JOIN Silver.asset_allocation_table al
                ON al.req_id = a.req_id
            ) T
    )            
    
    SELECT product_id,staff_id,staff_name,laptop_model,laptop_serial_number,accessories,req_id,[status] FROM final_clean WHERE rn = 1 ORDER BY staff_id;

GO

/*
=======================================================
Creating Gold Facts gold.fact_issued_accessories_table
=======================================================
*/

IF OBJECT_ID('gold.fact_issued_accessories_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_issued_accessories_table;
GO

CREATE VIEW gold.fact_issued_accessories_table AS 
SELECT
        date,          
        staff_id,      
        req_id,       
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(accessories, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS accessories
FROM Silver.issued_accessories_table
GO

/*
=======================================================
Creating Gold Facts gold.fact_breakfix_table
=======================================================
*/

IF OBJECT_ID('gold.fact_breakfix_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_breakfix_table;
GO

CREATE VIEW gold.fact_breakfix_table AS 
SELECT
        date,          
        staff_id,      
        reason,
        old_asset_model,
        old_asset_serial_number,
        replaced_asset_model,
        replaced_asset_serial_number,
        hostname,
        issue,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(remarks, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS remarks
FROM Silver.breakfix_table
GO

/*
=======================================================
Creating Gold Facts gold.fact_temporary_asset_table
=======================================================
*/

IF OBJECT_ID('gold.fact_temporary_asset_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_temporary_asset_table;
GO

CREATE VIEW gold.fact_temporary_asset_table AS 
SELECT
        date,          
        staff_id,      
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(accessories, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS accessories,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE([status], CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS [status]
FROM Silver.temporary_asset_table
GO

/*
=======================================================
Creating Gold Facts gold.fact_handover_table
=======================================================
*/

IF OBJECT_ID('gold.fact_handover_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_handover_table;
GO

CREATE VIEW gold.fact_handover_table AS 
SELECT
        date,          
        h.staff_id,      
        u.staff_name,
        laptop_model,
        laptop_serial_number,
        other_accessories,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(remarks, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS remarks
FROM Silver.handover_table h
LEFT JOIN SILVER.user_table u
ON u.staff_id = h.staff_id
GO

/*
=======================================================
Creating Gold Facts gold.fact_physical_damage_table
=======================================================
*/

IF OBJECT_ID('gold.fact_physical_damage_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_physical_damage_table;
GO

CREATE VIEW gold.fact_physical_damage_table AS 
SELECT
        date,          
        staff_id,        
        laptop_model,
        laptop_serial_number,
        damage_detail,
        cost_code
FROM Silver.physical_damage_table
GO

/*
=======================================================
Creating Gold Facts gold.fact_store_assets_table
=======================================================
*/

IF OBJECT_ID('gold.fact_store_assets_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_store_assets_table;
GO

CREATE VIEW gold.fact_store_assets_table AS 

WITH storing_cte AS 
(
    SELECT 
    old_asset_model AS laptop_model,
    old_asset_serial_number AS laptop_serial_number,
    'Breakfix' AS remarks
    FROM SILVER.breakfix_table
    WHERE old_asset_model IN ('HP Book 2.0 Model','Dell Laptop X12 Model','Lenovo laptop 324 Model','Mac Book M2 Model')

    UNION ALL

    SELECT 
    replaced_asset_model AS laptop_model,
    replaced_asset_serial_number AS laptop_serial_number,
    'Breakfix' AS remarks
    FROM SILVER.breakfix_table
    WHERE replaced_asset_model IN ('HP Book 2.0 Model','Dell Laptop X12 Model','Lenovo laptop 324 Model','Mac Book M2 Model')

    UNION ALL

    SELECT 
    laptop_model,
    laptop_serial_number,
    'Handover' AS remarks
    FROM Silver.handover_table
    WHERE laptop_model IN ('HP Book 2.0 Model','Dell Laptop X12 Model','Lenovo laptop 324 Model','Mac Book M2 Model')

    UNION ALL 

    SELECT 
    laptop_model,
    laptop_serial_number,
    'Physical Damage'
    FROM Silver.physical_damage_table
    WHERE laptop_model IN ('HP Book 2.0 Model','Dell Laptop X12 Model','Lenovo laptop 324 Model','Mac Book M2 Model')
)

SELECT
       s.laptop_model,
       s.laptop_serial_number,
       CASE
            WHEN EXISTS(
                SELECT 1 FROM storing_cte WHERE cte.laptop_serial_number = s.laptop_serial_number
            ) THEN 'stock'
            ELSE s.[status]
        END AS [status],
       am.manufacturing_date,
       end_of_life,
       am.warranty_period_months,
       am.product_service_cost,
       CASE
            WHEN EXISTS(
                 SELECT 1 FROM storing_cte WHERE cte.laptop_serial_number = s.laptop_serial_number
            ) THEN cte.remarks
            ELSE 'ALLOCATED'
       END AS remarks
FROM Silver.store_assets_table s
LEFT JOIN SILVER.assets_master_table am
ON am.product_name = s.laptop_model
LEFT JOIN storing_cte cte
ON cte.laptop_serial_number = s.laptop_serial_number

GO

/*
===========================================================
Creating Gold Facts gold.fact_daily_asset_management_table
===========================================================
*/

IF OBJECT_ID('gold.fact_daily_asset_management_table', 'V') IS NOT NULL
    DROP VIEW gold.fact_daily_asset_management_table;
GO

CREATE VIEW gold.fact_daily_asset_management_table AS 

WITH daily_transaction AS 
(
    SELECT 
        [DATE] AS [DATE],
        staff_id AS staff_id,
        req_id AS req_id,
        NULL AS old_laptop_model,
        NULL AS old_laptop_model_serial_number,
        NULL AS new_laptop_model,
        NULL AS new_laptop_model_serial_number,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(accessories, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS issued_accessories,
        NULL AS temporary_accessories,
        NULL AS handover_accessories,
        NULL AS missing_asset,
        NULL AS cost_code,
        NULL AS damage_detail,
        NULL AS remarks,
        am.cost AS production_cost  
    FROM SILVER.issued_accessories_table i
    LEFT JOIN silver.assets_master_table am
    ON am.product_name = i.accessories

    UNION ALL 

    SELECT 
        [DATE] AS [DATE],
        staff_id AS staff_id,
        NULL AS req_id,
        old_asset_model AS old_laptop_model,
        old_asset_serial_number old_laptop_model_serial_number,
        replaced_asset_model AS new_laptop_model,
        replaced_asset_serial_number AS new_laptop_model_serial_number,
        NULL AS issued_accessories,
        NULL AS temporary_accessories,
        NULL AS handover_accessories,
        NULL AS missing_asset,
        NULL AS cost_code,
        NULL AS damage_detail,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(remarks, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS remarks,
        am.cost AS production_cost  
    FROM SILVER.breakfix_table b
    LEFT JOIN silver.assets_master_table am
    ON am.product_name = b.replaced_asset_model

    UNION ALL

    SELECT 
        [DATE] AS [DATE],
        staff_id AS staff_id,
        NULL AS req_id,
        NULL AS old_laptop_model,
        NULL AS old_laptop_model_serial_number,
        NULL AS new_laptop_model,
        NULL AS new_laptop_model_serial_number,
        NULL AS issued_accessories,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(accessories, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS temporary_accessories,
        NULL AS handover_accessories,
        NULL AS missing_asset,
        NULL AS cost_code,
        NULL AS damage_detail,
        NULL AS remarks,
        am.cost AS production_cost  
    FROM SILVER.temporary_asset_table t
    LEFT JOIN silver.assets_master_table am
    ON am.product_name = t.accessories   

    UNION ALL

    SELECT 
        [DATE] AS [DATE],
        staff_id AS staff_id,
        NULL AS req_id,
        laptop_model AS old_laptop_model,
        laptop_serial_number old_laptop_model_serial_number,
        NULL AS new_laptop_model,
        NULL AS new_laptop_model_serial_number,
        NULL AS issued_accessories,
        NULL AS temporary_accessories,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(other_accessories, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS handover_accessories,
        NULL AS missing_asset,
        NULL AS cost_code,
        NULL AS damage_detail,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(remarks, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS remarks,
        am.cost AS production_cost  
    FROM SILVER.handover_table h
    LEFT JOIN silver.assets_master_table am
    ON am.product_name = h.other_accessories 

    UNION ALL

    SELECT 
        [DATE] AS [DATE],
        staff_id AS staff_id,
        NULL AS req_id,
        laptop_model AS old_laptop_model,
        laptop_serial_number AS old_laptop_model_serial_number,
        NULL AS new_laptop_model,
        NULL AS new_laptop_model_serial_number,
        NULL AS issued_accessories,
        NULL AS temporary_accessories,
        NULL AS handover_accessories,
        NULL AS missing_asset,
        cost_code, 
        damage_detail AS damage_detail,
        NULL AS remarks,
        am.cost AS production_cost  
    FROM SILVER.physical_damage_table p
    LEFT JOIN silver.assets_master_table am
    ON am.product_name = p.laptop_model   

    UNION ALL

    SELECT 
        [DATE] AS [DATE],
        staff_id AS staff_id,
        NULL AS req_id,
        NULL AS old_laptop_model,
        NULL AS old_laptop_model_serial_number,
        NULL AS new_laptop_model,
        NULL AS new_laptop_model_serial_number,
        NULL AS issued_accessories,
        NULL AS temporary_accessories,
        NULL AS handover_accessories,
        LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(missing_asset, CHAR(160), ' '),
                            CHAR(9), ' '),
                        CHAR(10), ' '),
                    CHAR(13), ' ')
        )) AS missing_asset,
        cost_code, 
        NULL AS damage_detail,
        NULL AS remarks,
        am.cost AS production_cost  
    FROM SILVER.missing_asset_table m
    LEFT JOIN silver.assets_master_table am
    ON am.product_name = m.missing_asset  
)

    SELECT 
        [date],
        d.staff_id,
        d.req_id,
        d.old_laptop_model,
        d.old_laptop_model_serial_number,
        d.new_laptop_model,
        d.new_laptop_model_serial_number,
        d.issued_accessories,
        d.temporary_accessories,
        d.handover_accessories,
        d.missing_asset,
        CASE
            WHEN d.cost_code IS NULL THEN u.cost_center
            ELSE d.cost_code
        END cost_code,
        d.damage_detail,
        d.remarks,
        d.production_cost
    FROM daily_transaction d
    LEFT JOIN silver.user_table u
    ON u.staff_id = d.staff_id
GO

SELECT * FROM Gold.dim_asset_allocation_table
GO
SELECT * FROM GOLD.dim_assets_master_table
GO
SELECT * FROM GOLD.dim_store_assets_table
GO
SELECT * FROM Gold.dim_user_table
GO
SELECT * FROM GOLD.fact_breakfix_table
GO
SELECT * FROM GOLD.fact_daily_asset_management_table
GO
SELECT * FROM Gold.fact_handover_table
GO
SELECT * FROM GOLD.fact_issued_accessories_table
GO
SELECT * FROM GOLD.fact_physical_damage_table
GO
SELECT * FROM Gold.fact_store_assets_table
GO
SELECT * FROM Gold.fact_temporary_asset_table
GO
SELECT * FROM Gold.fact_user_asset_info_table
GO
SELECT * FROM GOLD.fact_user_info_table
GO