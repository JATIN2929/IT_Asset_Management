/* 
====================================================================
Stored Procedures to Load Data into Bronze Tables
====================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME;
    BEGIN TRY 
        SET @start_time = GETDATE();
        PRINT 'Data Load into Bronze Tables Started at: ' + CONVERT(NVARCHAR, @start_time, 120);

        -- BULK INSERT commands to load data into bronze tables can be added here

        SET @end_time = GETDATE();
        PRINT 'Data Load into Bronze Tables Completed at: ' + CONVERT(NVARCHAR, @end_time, 120);
        PRINT 'Total Duration (seconds): ' + CONVERT(NVARCHAR, DATEDIFF(SECOND, @start_time, @end_time));
        PRINT 'loading Tables into Broze Tables;'

/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

  
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');

--Creating table and loading data into bronze.user_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.user_table', 'U') IS NOT NULL
        DROP TABLE bronze.user_table;


    CREATE TABLE bronze.user_table (
        staff_id                         INT,
        staff_name              NVARCHAR(50),
        job_title               NVARCHAR(50),
        grade_level                      INT,
        employee_status        NVARCHAR(50),
        functional_manager      NVARCHAR(50),
        mobile                  NVARCHAR(50),
        country                 NVARCHAR(50),
        department              NVARCHAR(50),
        cost_center                      INT,
        email                    NVARCHAR(50)
    );

    PRINT '>> Inserting Data Into: bronze.user_table';

    BULK INSERT bronze.user_table
    FROM '/var/opt/mssql/data/datasets/user_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.user_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.asset_allocation_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.asset_allocation_table', 'U') IS NOT NULL
        DROP TABLE bronze.asset_allocation_table;

    CREATE TABLE bronze.asset_allocation_table (
        product_id                         INT,
        staff_id                           INT,
        product_name              NVARCHAR(50),
        serial_number             NVARCHAR(50),
        req_id                    NVARCHAR(50),
        issued_date                       DATE,
        asset_collection_status   NVARCHAR(50),
        product_cost                       INT,
        cost_center                        INT
    );

    PRINT '>> Inserting Data Into: bronze.asset_allocation_table';

     BULK INSERT bronze.asset_allocation_table
    FROM '/var/opt/mssql/data/datasets/user_asset_allocation.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.asset_allocation_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.temporary_asset_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.temporary_asset_table', 'U') IS NOT NULL
        DROP TABLE bronze.temporary_asset_table;

    CREATE TABLE bronze.temporary_asset_table (
        date                            DATE,
        staff_id                         INT,
        accessories            NVARCHAR(255),
        status                   NVARCHAR(50) 
    );

    PRINT '>> Inserting Data Into: bronze.temporary_asset_table';

    BULK INSERT bronze.temporary_asset_table
    FROM '/var/opt/mssql/data/datasets/temporary_asset_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.temporary_asset_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.store_assets_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.store_assets_table', 'U') IS NOT NULL
        DROP TABLE bronze.store_assets_table;

    CREATE TABLE bronze.store_assets_table (
        laptop_serial_number   NVARCHAR(50),
        laptop_model  NVARCHAR(50),
        status        NVARCHAR(50),
        end_of_life   NVARCHAR(50),
    );

    BULK INSERT bronze.store_assets_table
    FROM '/var/opt/mssql/data/datasets/store_assets_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    PRINT '>> Inserting Data Into: bronze.store_assets_table';

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.store_assets_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.physical_damage_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.physical_damage_table', 'U') IS NOT NULL
        DROP TABLE bronze.physical_damage_table;

    CREATE TABLE bronze.physical_damage_table (
        date                            DATE,
        staff_id                         INT,
        laptop_model            NVARCHAR(50),
        laptop_serial_number    NVARCHAR(50),         
        damage_detail           NVARCHAR(50),
        cost_code                        INT,
    );

    PRINT '>> Inserting Data Into: bronze.physical_damage_table';

    BULK INSERT bronze.physical_damage_table
    FROM '/var/opt/mssql/data/datasets/physical_damage_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.physical_damage_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.missing_asset_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.missing_asset_table', 'U') IS NOT NULL
        DROP TABLE bronze.missing_asset_table;

    CREATE TABLE bronze.missing_asset_table (
        staff_id                         INT,
        date                            DATE,
        missing_asset          NVARCHAR(255),
        cost_code                        INT,
    );

    PRINT '>> Inserting Data Into: bronze.missing_asset_table';

    BULK INSERT bronze.missing_asset_table
    FROM '/var/opt/mssql/data/datasets/missing_assetS_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.missing_asset_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.issued_accessories_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.issued_accessories_table', 'U') IS NOT NULL
        DROP TABLE bronze.issued_accessories_table;

     CREATE TABLE bronze.issued_accessories_table (
        date                            DATE,
        staff_id                         INT,
        req_id                  NVARCHAR(50),
        accessories            NVARCHAR(255),
    );

    PRINT '>> Inserting Data Into: bronze.issued_accessories_table';

    BULK INSERT bronze.issued_accessories_table
    FROM '/var/opt/mssql/data/datasets/issued_accessories_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.issued_accessories_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.handover_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.handover_table', 'U') IS NOT NULL
        DROP TABLE bronze.handover_table;

    CREATE TABLE bronze.handover_table (
        date                            DATE,
        staff_id                         INT,
        staff_name              NVARCHAR(50),
        laptop_model            NVARCHAR(50),
        laptop_serial_number    NVARCHAR(50),         
        other_accessories      NVARCHAR(255),
        remarks                NVARCHAR(255)
     );

    PRINT '>> Inserting Data Into: bronze.handover_table';

    BULK INSERT bronze.handover_table
    FROM '/var/opt/mssql/data/datasets/handover_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )
    
    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.handover_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.breakfix_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.breakfix_table', 'U') IS NOT NULL
        DROP TABLE bronze.breakfix_table;

    CREATE TABLE bronze.breakfix_table (
        date                                 DATE,
        staff_id                              INT,
        reason                       NVARCHAR(50),
        old_asset_model              NVARCHAR(50),
        old_asset_serial_number      NVARCHAR(50),
        replaced_asset_model         NVARCHAR(50),
        replaced_asset_serial_number NVARCHAR(50),
        hostname                     NVARCHAR(50),
        issue                       NVARCHAR(100),
        remarks                     NVARCHAR(255)  
    );

    PRINT '>> Inserting Data Into: bronze.breakfix_table';
    
    BULK INSERT bronze.breakfix_table
    FROM '/var/opt/mssql/data/datasets/breakfix_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )

    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.breakfix_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--Creating table and loading data into bronze.assets_master_table
    SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.assets_master_table', 'U') IS NOT NULL
        DROP TABLE bronze.assets_master_table;

    CREATE TABLE bronze.assets_master_table (
        product_id                 INT,
        product_name      NVARCHAR(50),
        cost                       INT,
        manufacturing_date        DATE,
        warranty_period_months     INT,
        end_of_life_date          DATE,
        product_service_cost      FLOAT
    );

    PRINT '>> Inserting Data Into: bronze.assets_master_table';

    BULK INSERT bronze.assets_master_table
    FROM '/var/opt/mssql/data/datasets/assets_master_table.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    )
    SET @batch_end_time = GETDATE();
        PRINT '  Loading bronze.assets_master_table completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';    

END TRY 
    BEGIN CATCH 
        PRINT '=========================================='
            PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
            PRINT 'Error Message' + ERROR_MESSAGE();
            PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
            PRINT '=========================================='
	END CATCH
END

-- EXECUTE THE PROCEDURE TO LOAD DATA INTO BRONZE TABLES

EXEC bronze.load_bronze;
GO

SELECT * FROM BRONZE.user_table
GO

SELECT * FROM BRONZE.asset_allocation_table
GO

SELECT * FROM BRONZE.temporary_asset_table
GO

SELECT * FROM BRONZE.store_assets_table
GO

SELECT * FROM BRONZE.physical_damage_table
GO

SELECT * FROM BRONZE.missing_asset_table
GO

SELECT * FROM BRONZE.issued_accessories_table
GO

SELECT * FROM BRONZE.handover_table
GO

SELECT * FROM BRONZE.breakfix_table
GO

SELECT * FROM BRONZE.assets_master_table
GO

