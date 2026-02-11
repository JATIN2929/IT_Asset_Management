/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each functional manager */

SELECT 
    manager,
    SUM(total_product_cost) AS total_asset_cost,
    CASE
        WHEN SUM(total_product_cost) > 7000000 THEN 'High Cost Consumed'
        WHEN SUM(total_product_cost) BETWEEN 5000000 AND 7000000 THEN 'Medium Cost Consumed'
        ELSE 'Less Cost Consumed'
    END AS cost_consumed
    FROM(
    SELECT u.functional_manager AS manager,
        al.product_name,SUM(al.product_cost) AS total_product_cost 
    FROM Gold.dim_asset_allocation_table al
    LEFT JOIN Gold.fact_user_info_table u
    ON u.staff_id = al.staff_id
    GROUP BY u.functional_manager,al.product_name 
)t GROUP BY manager ORDER BY total_asset_cost DESC