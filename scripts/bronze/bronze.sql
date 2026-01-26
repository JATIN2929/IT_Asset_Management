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
IF OBJECT_ID('bronze.user_table', 'U') IS NOT NULL
        DROP TABLE bronze.user_table;

    CREATE TABLE bronze.user_table (
        staff_id                         INT,
        staff_name              NVARCHAR(50),
        job_title               NVARCHAR(50),
        grade_level                      INT,
        employee_statues        NVARCHAR(50),
        functional_manager      NVARCHAR(50),
        mobile                           INT,
        country                 NVARCHAR(50),
        department              NVARCHAR(50),
        cost_center                      INT,
        email                    NVARCHAR(50)
    );

IF OBJECT_ID('bronze.asset_allocation_table', 'U') IS NOT NULL
        DROP TABLE bronze.asset_allocation_table;

    CREATE TABLE bronze.asset_allocation_table (
        product_id                         INT,
        staff_id                           INT,
        product_name              NVARCHAR(50),
        serial_number                      INT,
        req_id                             INT,
        issued_date                       DATE,
        asset_collection_status   NVARCHAR(50),
        product_cost                       INT,
        cost_center                        INT
    );

IF OBJECT_ID('bronze.temporary_asset_table', 'U') IS NOT NULL
        DROP TABLE temporary_asset_table;

    CREATE TABLE temporary_asset_table (
        date                            DATE,
        staff_id                         INT,
        accessories                 NVARCHAR,
        status                   NVARCHAR(50) 
    );

IF OBJECT_ID('bronze.store_assets_table', 'U') IS NOT NULL
        DROP TABLE bronze.store_assets_table;

    CREATE TABLE bronze.store_assets_table (
        laptop_serial_number   NVARCHAR(50),
        laptop_model  NVARCHAR(50),
        status        NVARCHAR(50),
        end_of_life   NVARCHAR(50),
    );

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

IF OBJECT_ID('bronze.missing_asset_table', 'U') IS NOT NULL
        DROP TABLE bronze.missing_asset_table;

    CREATE TABLE bronze.missing_asset_table (
        staff_id                         INT,
        date                            DATE,
        missing_asset               NVARCHAR,
        cost_code                        INT,
    );

IF OBJECT_ID('bronze.issued_accessories_table', 'U') IS NOT NULL
        DROP TABLE bronze.issued_accessories_table;

     CREATE TABLE bronze.issued_accessories_table (
        date                            DATE,
        staff_id                         INT,
        req_id                  NVARCHAR(50),
        accessories                 NVARCHAR,
    );

IF OBJECT_ID('bronze.handover_table', 'U') IS NOT NULL
        DROP TABLE bronze.handover_table;

    CREATE TABLE bronze.handover_table (
        date                            DATE,
        staff_id                         INT,
        staff_name              NVARCHAR(50),
        laptop_model            NVARCHAR(50),
        laptop_serial_number    NVARCHAR(50),         
        other_accessories           NVARCHAR,
        remarks                     NVARCHAR
     );

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
        issue                            NVARCHAR,
        remarks                          NVARCHAR  
    );

IF OBJECT_ID('bronze.assets_master_table', 'U') IS NOT NULL
        DROP TABLE assets_master_table;

    CREATE TABLE assets_master_table (
        product_id                 INT,
        product_name      NVARCHAR(50),
        cost                       INT,
        manufacturing_date        DATE,
        warranty_period_months     INT,
        end_of_life_date          DATE,
        product_service_cost       INT
    );
