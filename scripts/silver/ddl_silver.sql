BEGIN
    DECLARE @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME;
    BEGIN TRY 
        SET @start_time = GETDATE();
        PRINT 'Data Load into silver Tables Started at: ' + CONVERT(NVARCHAR, @start_time, 120);

        -- BULK INSERT commands to load data into silver tables can be added here

        SET @end_time = GETDATE();
        PRINT 'Data Load into silver Tables Completed at: ' + CONVERT(NVARCHAR, @end_time, 120);
        PRINT 'Total Duration (seconds): ' + CONVERT(NVARCHAR, DATEDIFF(SECOND, @start_time, @end_time));
        PRINT 'loading Tables into Silver Tables;'

/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/

  
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');

--Creating table and loading data into silver.user_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.user_table', 'U') IS NOT NULL
        DROP TABLE silver.user_table;

    CREATE TABLE silver.user_table (
        staff_id                         INT,
        staff_name              NVARCHAR(50),
        job_title               NVARCHAR(50),
        employee_status        NVARCHAR(50),
        functional_manager      NVARCHAR(50),
        mobile                  NVARCHAR(50),
        country                 NVARCHAR(50),
        department              NVARCHAR(50),
        cost_center                      INT,
        email                   NVARCHAR(50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.user_table';

--Creating table and loading data into silver.asset_allocation_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.asset_allocation_table', 'U') IS NOT NULL
        DROP TABLE silver.asset_allocation_table;

    CREATE TABLE silver.asset_allocation_table (
        product_id                         INT,
        staff_id                           INT,
        product_name              NVARCHAR(50),
        serial_number             NVARCHAR(50),
        req_id                    NVARCHAR(50),
        issued_date                       DATE,
        asset_collection_status   NVARCHAR(50),
        product_cost                       INT,
        cost_center                        INT,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.asset_allocation_table';

--Creating table and loading data into silver.temporary_asset_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.temporary_asset_table', 'U') IS NOT NULL
        DROP TABLE silver.temporary_asset_table;

    CREATE TABLE silver.temporary_asset_table (
        date                            DATE,
        staff_id                         INT,
        accessories            NVARCHAR(255),
        status                   NVARCHAR(50),
        dwh_create_date DATETIME2 DEFAULT GETDATE() 
    );

    PRINT '>> Inserting Data Into: silver.temporary_asset_table';

--Creating table and loading data into silver.store_assets_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.store_assets_table', 'U') IS NOT NULL
        DROP TABLE silver.store_assets_table;

    CREATE TABLE silver.store_assets_table (
        laptop_serial_number   NVARCHAR(50),
        laptop_model  NVARCHAR(50),
        status        NVARCHAR(50),
        end_of_life   NVARCHAR(50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.store_assets_table';

--Creating table and loading data into silver.physical_damage_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.physical_damage_table', 'U') IS NOT NULL
        DROP TABLE silver.physical_damage_table;

    CREATE TABLE silver.physical_damage_table (
        date                            DATE,
        staff_id                         INT,
        laptop_model            NVARCHAR(50),
        laptop_serial_number    NVARCHAR(50),         
        damage_detail           NVARCHAR(50),
        cost_code                        INT,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.physical_damage_table';

--Creating table and loading data into silver.missing_asset_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.missing_asset_table', 'U') IS NOT NULL
        DROP TABLE silver.missing_asset_table;

    CREATE TABLE silver.missing_asset_table (
        staff_id                         INT,
        date                            DATE,
        missing_asset          NVARCHAR(255),
        cost_code                        INT,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.missing_asset_table';

--Creating table and loading data into silver.issued_accessories_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.issued_accessories_table', 'U') IS NOT NULL
        DROP TABLE silver.issued_accessories_table;

     CREATE TABLE silver.issued_accessories_table (
        date                            DATE,
        staff_id                         INT,
        req_id                  NVARCHAR(50),
        accessories            NVARCHAR(255),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.issued_accessories_table';

--Creating table and loading data into silver.handover_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.handover_table', 'U') IS NOT NULL
        DROP TABLE silver.handover_table;

    CREATE TABLE silver.handover_table (
        date                            DATE,
        staff_id                         INT,
        staff_name              NVARCHAR(50),
        laptop_model            NVARCHAR(50),
        laptop_serial_number    NVARCHAR(50),         
        other_accessories      NVARCHAR(255),
        remarks                NVARCHAR(255),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
     );

    PRINT '>> Inserting Data Into: silver.handover_table';

--Creating table and loading data into silver.breakfix_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.breakfix_table', 'U') IS NOT NULL
        DROP TABLE silver.breakfix_table;

    CREATE TABLE silver.breakfix_table (
        date                                 DATE,
        staff_id                              INT,
        reason                       NVARCHAR(50),
        old_asset_model              NVARCHAR(50),
        old_asset_serial_number      NVARCHAR(50),
        replaced_asset_model         NVARCHAR(50),
        replaced_asset_serial_number NVARCHAR(50),
        hostname                     NVARCHAR(50),
        issue                       NVARCHAR(100),
        remarks                     NVARCHAR(255),
        dwh_create_date DATETIME2 DEFAULT GETDATE() 
    );

    PRINT '>> Inserting Data Into: silver.breakfix_table';

--Creating table and loading data into silver.assets_master_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('silver.assets_master_table', 'U') IS NOT NULL
        DROP TABLE silver.assets_master_table;

    CREATE TABLE silver.assets_master_table (
        product_id                 INT,
        product_name      NVARCHAR(50),
        cost                       INT,
        manufacturing_date        DATE,
        warranty_period_months     INT,
        end_of_life_date          DATE,
        product_service_cost      FLOAT,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT '>> Inserting Data Into: silver.assets_master_table'; 

END TRY 
    BEGIN CATCH 
        PRINT '=========================================='
            PRINT 'ERROR OCCURED DURING LOADING silver LAYER'
            PRINT 'Error Message' + ERROR_MESSAGE();
            PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
            PRINT '=========================================='
	END CATCH
END
