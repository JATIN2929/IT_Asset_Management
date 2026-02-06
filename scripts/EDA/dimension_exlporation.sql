-- Check exising job_title 
SELECT DISTINCT job_title
FROM GOLD.dim_user_table

-- Check existing employee_status level
SELECT DISTINCT employee_status FROM Gold.dim_user_table

-- Check existing functional_manager level
SELECT DISTINCT functional_manager FROM Gold.dim_user_table

-- Check existing product_name level
SELECT DISTINCT product_name FROM GOLD.dim_assets_master_table
