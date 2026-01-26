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
