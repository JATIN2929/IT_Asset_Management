/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

--- Calculating percentage change of issues over time with respect to total issues.

with total_issues AS (
    SELECT 
        FORMAT([date], 'yyyy') AS issue_year,FORMAT([date], 'MMM') AS issue_month,
        COUNT(new_laptop_model)AS total_breakfix_issues,
        COUNT(temporary_accessories) AS total_temporary_issues,
        COUNT(handover_accessories) AS total_handover_issues,
        COUNT(missing_asset) AS total_missing_issues,
        COUNT(damage_detail) AS total_damage_issues
    FROM Gold.fact_daily_asset_management_table 
    GROUP BY FORMAT([date], 'yyyy'),FORMAT([date], 'MMM')
)

    SELECT
    issue_month,
    issue_year,
    CONCAT(ROUND((CAST(t.total_breakfix_issues AS FLOAT) /SUM(t.total_breakfix_issues)OVER())*100,2),'%') AS percentage_of_breakix,
    CONCAT(ROUND((CAST(t.total_damage_issues AS FLOAT) /SUM(t.total_damage_issues)OVER())*100,2),'%') AS percentage_of_damage,
    CONCAT(ROUND((CAST(t.total_handover_issues AS FLOAT) /SUM(t.total_handover_issues)OVER())*100,2),'%') AS percentage_of_handover,
    CONCAT(ROUND((CAST(t.total_temporary_issues AS FLOAT) /SUM(t.total_temporary_issues)OVER())*100,2),'%') AS percentage_of_temporary
    FROM total_issues t
    ORDER BY issue_year,issue_month