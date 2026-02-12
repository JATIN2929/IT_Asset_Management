/*
===============================================================================
functional Manager Report
===============================================================================
*/

IF OBJECT_ID('gold.report_functional_manager', 'V') IS NOT NULL
    DROP VIEW gold.report_functional_manager;
GO

with total_issues AS (
    SELECT staff_id,accessories,COUNT(*) AS total_issues FROM GOLD.fact_temporary_asset_table GROUP BY staff_id,accessories
    UNION ALL
    SELECT staff_id,other_accessories AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_handover_table GROUP BY staff_id,other_accessories
    UNION ALL
    SELECT staff_id,laptop_model AS accessories,COUNT(*) AS total_issues FROM GOLD.fact_physical_damage_table GROUP BY staff_id,laptop_model
    UNION ALL
    SELECT staff_id,missing_asset AS accessories,COUNT(*) AS total_issues FROM Gold.fact_missing_asset_table GROUP BY staff_id,missing_asset
),
total_product_cost AS(
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
    )t GROUP BY manager 
),
total_users AS(
    SELECT functional_manager, COUNT(staff_id) AS total_users FROM Gold.fact_user_info_table GROUP BY functional_manager
),
final_report AS(
    SELECT 
        u.functional_manager AS manager,
        tu.total_users,
        SUM(t.total_issues) AS total_issues,
        pc.total_asset_cost,pc.cost_consumed 
    FROM total_issues t 
    LEFT JOIN Gold.fact_user_info_table u 
    ON u.staff_id = t.staff_id
    LEFT JOIN total_product_cost pc
    ON pc.manager = u.functional_manager
    LEFT JOIN total_users tu ON tu.functional_manager = u.functional_manager
    GROUP BY u.functional_manager,tu.total_users,pc.total_asset_cost,pc.cost_consumed
)
    SELECT * FROM final_report
    ORDER BY total_issues DESC
