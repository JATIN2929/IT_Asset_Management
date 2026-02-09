/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

--- Check total number of users visited for some IT issue
SELECT COUNT(DISTINCT staff_id) AS toatl_users_visited_IT FROM Gold.fact_daily_asset_management_table WHERE issued_accessories IS NULL

--- Check total number of users visited for some IT issue on basis of issues
SELECT COUNT(DISTINCT staff_id ) AS user_with_temporary_asset FROM Gold.fact_daily_asset_management_table WHERE temporary_accessories IS NOT NULL
SELECT COUNT(DISTINCT staff_id ) AS user_with_breakfix_asset FROM Gold.fact_daily_asset_management_table WHERE new_laptop_model IS NOT NULL
SELECT COUNT(DISTINCT staff_id ) AS user_with_physical_damage_asset FROM Gold.fact_daily_asset_management_table WHERE damage_detail IS NOT NULL
SELECT COUNT(DISTINCT staff_id ) AS user_with_missing_asset FROM Gold.fact_daily_asset_management_table WHERE missing_asset IS NOT NULL

--- Check for which assets how much issues reported
SELECT accessories,SUM(total_issues) AS  total_issues  FROM (
    SELECT accessories,COUNT(*) AS total_issues FROM GOLD.fact_temporary_asset_table GROUP BY accessories
    UNION ALL
    SELECT other_accessories AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_handover_table GROUP BY other_accessories
    UNION ALL
    SELECT laptop_model AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_physical_damage_table GROUP BY laptop_model
    UNION ALL
    SELECT missing_asset AS accessories,COUNT(*) AS total_issues FROM Gold.fact_missing_asset_table GROUP BY missing_asset
)t GROUP BY accessories ORDER BY total_issues DESC

--- Check average life of assets on the basis of warranty
SELECT 
AVG(total_life_of_product) AS average_life_of_product,
AVG(warranty_period_months) AS warranty_period_months,
AVG(life_left_post_warranty) AS average_life_left_post_warranty
FROM (
    SELECT 
        product_name,
        DATEDIFF(MONTH,manufacturing_date,end_of_life_date) AS total_life_of_product,
        warranty_period_months,
        DATEDIFF(MONTH,manufacturing_date,end_of_life_date) - warranty_period_months AS life_left_post_warranty
    FROM GOLD.dim_assets_master_table
)t

--- Check number of varios laptop on based on laptop model on various job_title
SELECT al.product_name,u.job_title,COUNT(al.product_name) AS total_asset FROM Gold.dim_asset_allocation_table al LEFT JOIN Gold.dim_user_table u 
ON U.staff_id = al.staff_id WHERE product_name IN('Dell Laptop X12 Model','Lenovo Laptop 324 Model','MacBook M2 Model','HP Book 2.0 Model') GROUP BY al.product_name,u.job_title
ORDER BY product_name,COUNT(al.product_name) DESC
 
--- Check number of varios laptop issued on basis of job_title
SELECT u.job_title,COUNT(al.product_name) AS total_asset FROM Gold.dim_asset_allocation_table al LEFT JOIN Gold.dim_user_table u 
ON U.staff_id = al.staff_id WHERE product_name IN('Dell Laptop X12 Model','Lenovo Laptop 324 Model','MacBook M2 Model','HP Book 2.0 Model') GROUP BY job_title
ORDER BY COUNT(al.product_name) DESC