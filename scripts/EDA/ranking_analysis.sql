/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

--- Check top 5 assets for which assets how much issues reported
SELECT * FROM (
SELECT accessories,SUM(total_issues) AS  total_issues , ROW_NUMBER() OVER(ORDER BY SUM(total_issues) DESC) AS ranking FROM (
    SELECT accessories,COUNT(*) AS total_issues FROM GOLD.fact_temporary_asset_table GROUP BY accessories
    UNION ALL
    SELECT old_asset_model AS accessories,COUNT(*) AS total_issues FROM Gold.fact_breakfix_table GROUP BY old_asset_model
    UNION ALL
    SELECT laptop_model AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_physical_damage_table GROUP BY laptop_model
    UNION ALL
    SELECT missing_asset AS accessories,COUNT(*) AS total_issues FROM Gold.fact_missing_asset_table GROUP BY missing_asset
)t GROUP BY accessories
)g WHERE ranking <=5 

--- Check ranking of functional manager on basis of employees
SELECT * FROM(
SELECT functional_manager,COUNT(DISTINCT staff_id) AS total_employees, RANK() OVER(ORDER BY COUNT(DISTINCT staff_id) DESC)  AS ranking FROM Gold.fact_user_info_table GROUP BY functional_manager
)t WHERE ranking <=5

--- Check ranking of functional manager on basis of total_asset_cost of there employees
SELECT * FROM(
SELECT manager,SUM(total_product_cost) AS total_asset_cost,RANK()OVER(ORDER BY SUM(total_product_cost) DESC) AS ranking FROM(
SELECT u.functional_manager AS manager,al.product_name,SUM(al.product_cost) AS total_product_cost FROM Gold.dim_asset_allocation_table al
LEFT JOIN Gold.fact_user_info_table u
ON u.staff_id = al.staff_id
GROUP BY u.functional_manager,al.product_name 
)t GROUP BY manager 
)g WHERE ranking<=5