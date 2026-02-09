/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

with total_issues AS (
    SELECT 
        am.[date] AS issue_date,
        al.product_name,
        COUNT(new_laptop_model)AS total_breakfix_issues,
        COUNT(temporary_accessories) AS total_temporary_issues,
        COUNT(handover_accessories) AS total_handover_issues,
        COUNT(missing_asset) AS total_missing_issues,
        COUNT(damage_detail) AS total_damage_issues
    FROM Gold.fact_daily_asset_management_table am
    LEFT JOIN Gold.dim_asset_allocation_table al
        ON al.staff_id = am.staff_id
    GROUP BY al.product_name
)

SELECT * FROM total_issues