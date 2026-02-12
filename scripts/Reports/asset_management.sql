/*
===============================================================================
Asset Management Report
===============================================================================
*/
IF OBJECT_ID('gold.report_asset_management', 'V') IS NOT NULL
    DROP VIEW gold.report_asset_management;
GO  

with total_issues_by_accessories AS (
SELECT accessories AS accessories,SUM(total_issues) AS  total_issues , ROW_NUMBER() OVER(ORDER BY SUM(total_issues) DESC) AS ranking FROM (
    SELECT accessories AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_temporary_asset_table GROUP BY accessories
    UNION ALL
    SELECT old_asset_model AS accessories,COUNT(*) AS total_issues FROM Gold.fact_breakfix_table GROUP BY old_asset_model
    UNION ALL
    SELECT laptop_model AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_physical_damage_table GROUP BY laptop_model
    UNION ALL
    SELECT missing_asset AS accessories,COUNT(*) AS total_issues FROM Gold.fact_missing_asset_table GROUP BY missing_asset
)t GROUP BY accessories
),
total_issues_by_category AS(


SELECT 
    accessories,
    SUM(total_handover_issues)        AS total_handover_issues,
    SUM(total_breakfix_issues)        AS total_breakfix_issues,
    SUM(total_physical_damage_issues) AS total_physical_damage_issues,
    SUM(total_missing_issues)         AS total_missing_issues,
    SUM(total_temporary_issues)       AS total_temporary_issues
FROM (
    
    SELECT 
        TRIM(REPLACE(REPLACE(REPLACE(REPLACE(accessories, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' ')) AS accessories,
        CAST(NULL AS INT) AS total_handover_issues,
        CAST(NULL AS INT) AS total_breakfix_issues,
        CAST(NULL AS INT) AS total_physical_damage_issues,
        CAST(NULL AS INT) AS total_missing_issues,
        COUNT(*) AS total_temporary_issues
    FROM GOLD.fact_temporary_asset_table 
    GROUP BY TRIM(REPLACE(REPLACE(REPLACE(REPLACE(accessories, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' '))

    UNION ALL
    
    SELECT 
        TRIM(REPLACE(REPLACE(REPLACE(REPLACE(old_asset_model, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' ')),
        CAST(NULL AS INT),
        COUNT(*),
        CAST(NULL AS INT),
        CAST(NULL AS INT),
        CAST(NULL AS INT)
    FROM Gold.fact_breakfix_table
    GROUP BY TRIM(REPLACE(REPLACE(REPLACE(REPLACE(old_asset_model, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' '))

    UNION ALL
    
    SELECT 
        TRIM(REPLACE(REPLACE(REPLACE(REPLACE(laptop_model, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' ')),
        CAST(NULL AS INT),
        CAST(NULL AS INT),
        COUNT(*),
        CAST(NULL AS INT),
        CAST(NULL AS INT)
    FROM GOLD.fact_physical_damage_table 
    GROUP BY TRIM(REPLACE(REPLACE(REPLACE(REPLACE(laptop_model, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' '))

    UNION ALL

    SELECT 
        TRIM(REPLACE(REPLACE(REPLACE(REPLACE(missing_asset, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' ')),
        CAST(NULL AS INT),
        CAST(NULL AS INT),
        CAST(NULL AS INT),
        COUNT(*),
        CAST(NULL AS INT)
    FROM Gold.fact_missing_asset_table 
    GROUP BY TRIM(REPLACE(REPLACE(REPLACE(REPLACE(missing_asset, CHAR(160),' '), CHAR(9),' '), CHAR(10),' '), CHAR(13),' '))

) x
GROUP BY accessories

)

SELECT  
CASE
    WHEN laptop_model = 'Wireless Headset Cushion' THEN 'Wireless Headset Cushion'
    WHEN laptop_model = 'JBL Wireless Headset' THEN 'JBL Wireless Headset'
    WHEN laptop_model = 'HP Book 2.0 Model' THEN 'HP Book 2.0 Model'
    WHEN laptop_model = 'Dell Laptop X12 Model' THEN 'Dell Laptop X12 Model'
    WHEN laptop_model = 'Lenovo laptop 324 Model' THEN 'Lenovo laptop 324 Model'
    WHEN laptop_model = 'Mac Book M2 Model' THEN 'Mac Book M2 Model'
    ELSE 'Other Assets'
END AS assets_model,
COUNT(*) AS toatal_assets_by_assets,
t.total_issues AS total_issues_by_assets,
t.total_issues,  tc.total_breakfix_issues, tc.total_physical_damage_issues, tc.total_missing_issues,tc.total_handover_issues
FROM Gold.fact_store_assets_table  ft
LEFT JOIN total_issues_by_accessories t 
ON t.accessories = ft.laptop_model 
LEFT JOIN total_issues_by_category tc
ON tc.accessories = ft.laptop_model
WHERE t.accessories IN ('Wireless Headset Cushion','JBL Wireless Headset','HP Book 2.0 Model','Dell Laptop X12 Model','Lenovo laptop 324 Model','Mac Book M2 Model')
GROUP BY laptop_model, t.total_issues, tc.total_handover_issues, tc.total_breakfix_issues, tc.total_physical_damage_issues, tc.total_missing_issues ORDER BY COUNT(*) DESC




