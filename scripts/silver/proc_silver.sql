/* 
====================================================================
Stored Procedures to Load Data into Silver Tables
====================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
     DECLARE @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME;
    BEGIN TRY 
        SET @start_time = GETDATE();
        PRINT 'Data Load into Silver Tables Started at: ' + CONVERT(NVARCHAR, @start_time, 120);

        -- BULK INSERT commands to load data into silver tables can be added here

        SET @end_time = GETDATE();
        PRINT 'Data Load into Silver Tables Completed at: ' + CONVERT(NVARCHAR, @end_time, 120);
        PRINT 'Total Duration (seconds): ' + CONVERT(NVARCHAR, DATEDIFF(SECOND, @start_time, @end_time));
        PRINT 'loading CRM Tables into Silver Tables;'

/*
========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN user_table
========================================================================
*/
    
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.user_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.user_table;
    PRINT '>> Loading cleaned data into silver.user_table';
    
    INSERT INTO silver.user_table (
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
    )
    SELECT 
        staff_id,
        staff_name,
        CASE 
            WHEN grade_level ='1' THEN 'CHAIRMAN'
            WHEN grade_level ='2' THEN 'MANAGING DIRECTOR'
            WHEN grade_level ='4' THEN 'VICE PRESIDENT'
            WHEN grade_level ='5' THEN 'ASSISTANT VICE PRESIDENT'
            WHEN grade_level ='6' THEN 'Manager'
            WHEN grade_level ='7' THEN 'SENIOR ANALYST'
            WHEN grade_level ='8' THEN 'ANALYST'
            WHEN grade_level ='9' THEN 'ASSOCIATE'
            WHEN grade_level ='10' THEN 'JUINOR ASSOCIATE'
            ELSE job_title
        END job_title,
        employee_status,
        functional_manager,
        COALESCE(mobile,NULL,'UNKNOWN') AS mobile,
        country,department,cost_center,email 
    FROM Bronze.user_table

/*
===========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN asset_allocation_table
===========================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.asset_allocation_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.asset_allocation_table;
    PRINT '>> Loading cleaned data into silver.asset_allocation_table';  

    INSERT INTO silver.asset_allocation_table (
        product_id,                         
        staff_id,                           
        product_name,              
        serial_number,             
        req_id,                    
        issued_date,                         
        product_cost,                      
        cost_center 
    )
    SELECT 
        product_id,
        staff_id,
        product_name,
        serial_number AS laptop_serial_number,
        req_id,
        issued_date,
        product_cost,
        cost_center
    FROM Bronze.asset_allocation_table
/*
==========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN temporary_asset_table
==========================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.temporary_asset_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.temporary_asset_table;
    PRINT '>> Loading cleaned data into silver.temporary_asset_table';

    INSERT INTO silver.temporary_asset_table (
        date,                         
        staff_id,                      
        accessories,        
        status                
    )
    SELECT 
        CAST(date AS DATE),
        staff_id,
        LTRIM(RTRIM(s.[value])) AS accessories,
        status
    FROM bronze.temporary_asset_table 
    CROSS APPLY STRING_SPLIT(accessories, '|') s 
    WHERE accessories IS NOT NULL
        AND LTRIM(RTRIM(value)) != ''

/*
========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN store_assets_table
========================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.store_assets_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.store_assets_table;
    PRINT '>> Loading cleaned data into silver.store_assets_table';

    INSERT INTO silver.store_assets_table (
        laptop_serial_number,   
        laptop_model,  
        status,        
        end_of_life   
    )
    SELECT
        laptop_serial_number,   
        laptop_model,  
        status,
        CASE
            WHEN SUBSTRING(LOWER(TRIM(end_of_life)),1,3) = 'yes' THEN 'YES'
            WHEN SUBSTRING(LOWER(TRIM(end_of_life)),1,2) = 'no' THEN 'NO'
            ELSE 'UNKNOWN'
        END end_of_life  
    FROM Bronze.store_assets_table

/*
==========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN physical_damage_table
==========================================================================
*/
    
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.physical_damage_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.physical_damage_table;
    PRINT '>> Loading cleaned data into silver.physical_damage_table';

    INSERT INTO silver.physical_damage_table (
        date,                       
        staff_id,                
        laptop_model,        
        laptop_serial_number,        
        damage_detail,         
        cost_code                   
    )
    SELECT 
        CAST([date] AS DATE),
        staff_id,
        laptop_model,        
        laptop_serial_number,        
        damage_detail,         
        cost_code 
    FROM Bronze.physical_damage_table

/*
========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN missing_asset_table
========================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.missing_asset_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.missing_asset_table;
    PRINT '>> Loading cleaned data into silver.missing_asset_table';

    INSERT INTO silver.missing_asset_table (
        staff_id,               
        date,                
        missing_asset,       
        cost_code       
    )
    SELECT 
        staff_id,               
        CAST([date] AS DATE),               
        missing_asset,       
        cost_code 
    FROM Bronze.missing_asset_table

/*
=============================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN issued_accessories_table
=============================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.issued_accessories_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.issued_accessories_table;
    PRINT '>> Loading cleaned data into silver.issued_accessories_table';

    INSERT INTO silver.issued_accessories_table (
        date,          
        staff_id,      
        req_id,       
        accessories  
    )
    SELECT 
        CAST([date] AS DATE),          
        staff_id,      
        req_id,
        LTRIM(RTRIM(s.[value])) AS accessories
    FROM Bronze.issued_accessories_table
    CROSS APPLY string_split(accessories,'|') s
    WHERE accessories IS NOT NULL
        AND LTRIM(RTRIM([value])) != ''

/*
========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN handover_table
========================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.handover_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.handover_table;
    PRINT '>> Loading cleaned data into silver.handover_table';

    INSERT INTO silver.handover_table (
        date,                         
        staff_id,               
        laptop_model,          
        laptop_serial_number,            
        other_accessories, 
        remarks            
    )
    SELECT
        CAST([date] AS DATE),                         
        staff_id,               
        laptop_model,          
        laptop_serial_number,            
        LTRIM(RTRIM(s.[value])) AS other_accessories,
        remarks 
    FROM Bronze.handover_table
    CROSS APPLY string_split(other_accessories,'|') s
    WHERE other_accessories IS NOT NULL
        AND LTRIM(RTRIM([value])) != ''

/*
========================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER IN breakfix_table
========================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.breakfix_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.breakfix_table;
    PRINT '>> Loading cleaned data into silver.breakfix_table';

    INSERT INTO silver.breakfix_table (
        date,                              
        staff_id,                            
        reason,                     
        old_asset_model,              
        old_asset_serial_number,     
        replaced_asset_model,      
        replaced_asset_serial_number,
        hostname,            
        issue,                  
        remarks                  
    )
    SELECT
        CAST([date]AS DATE),                              
        staff_id,                            
        reason,                     
        old_asset_model,              
        old_asset_serial_number,     
        replaced_asset_model,      
        replaced_asset_serial_number,
        hostname,            
        issue,                  
        remarks 
    FROM Bronze.breakfix_table

/*
=============================================================================
 CLEANING DATA FROM BRONZE LAYER TO SILVER LAYER silver.assets_master_table
=============================================================================
*/
    SET @batch_start_time = GETDATE();
        PRINT '  Loading silver.assets_master_table started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    TRUNCATE TABLE silver.assets_master_table;
    PRINT '>> Loading cleaned data into silver.assets_master_table';

    INSERT INTO silver.assets_master_table (
        product_id,      
        product_name,    
        cost,                  
        manufacturing_date,     
        warranty_period_months,   
        end_of_life_date,        
        product_service_cost    
    )
    SELECT
        product_id,      
        product_name,    
        cost,                  
        CAST(manufacturing_date AS DATE),     
        warranty_period_months,        
        CAST(end_of_life_date AS DATE),
        product_service_cost   
    FROM Bronze.assets_master_table

END TRY 
    BEGIN CATCH 
        PRINT '=========================================='
            PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
            PRINT 'Error Message' + ERROR_MESSAGE();
            PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
            PRINT '=========================================='
	END CATCH
END

EXEC Silver.load_silver
GO

SELECT * FROM Silver.user_table
GO

SELECT * FROM Silver.asset_allocation_table
GO

SELECT * FROM Silver.temporary_asset_table
GO

SELECT * FROM Silver.store_assets_table
GO

SELECT * FROM Silver.physical_damage_table
GO

SELECT * FROM Silver.missing_asset_table
GO

SELECT * FROM Silver.issued_accessories_table
GO

SELECT * FROM Silver.handover_table
GO

SELECT * FROM Silver.breakfix_table
GO

SELECT * FROM Silver.assets_master_table
GO
