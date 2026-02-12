/*
===============================================================================
Incident Management Report
===============================================================================
*/

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
),
average_result AS(
    SELECT
        issue_year,
        AVG(total_breakfix_issues) AS average_breakfix_issues,
        AVG(total_temporary_issues) AS average_temporary_issues,
        AVG(total_handover_issues) AS average_handover_issues,
        AVG(total_missing_issues) AS average_missing_issues,
        AVG(total_damage_issues) AS average_damage_issues        
    FROM total_issues 
    GROUP BY issue_year
)
    SELECT 

        t.issue_month, 
        t.issue_year,

        t.total_breakfix_issues,
        a.average_breakfix_issues,
        t.total_breakfix_issues - a.average_breakfix_issues AS diff_by_average_breakfix_issues,
        LAG(t.total_breakfix_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS post_month_issues,
        t.total_breakfix_issues - LAG(t.total_breakfix_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS diff_by_breakfix_issues,
        CONCAT(ROUND((CAST(t.total_breakfix_issues AS FLOAT) /SUM(t.total_breakfix_issues)OVER())*100,2),'%') AS percentage_of_total,

        t.total_damage_issues,
        a.average_damage_issues,
        LAG(t.total_damage_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS post_month_issues,
        total_damage_issues - LAG(total_damage_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS diff_by_damage_issues,
        t.total_damage_issues - a.average_damage_issues AS diff_by_average_damage_issues,
        CONCAT(ROUND((CAST(t.total_damage_issues AS FLOAT) /SUM(t.total_damage_issues)OVER())*100,2),'%') AS percentage_of_total, 

        t.total_handover_issues,
        a.average_handover_issues,
        LAG(t.total_handover_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS post_month_issues,
        t.total_handover_issues - LAG(t.total_handover_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS diff_by_handover_issues,
        t.total_handover_issues - a.average_handover_issues AS diff_by_average_handover_issues,
        CONCAT(ROUND((CAST(t.total_handover_issues AS FLOAT) /SUM(t.total_handover_issues)OVER())*100,2),'%') AS percentage_of_total,

        t.total_missing_issues,
        a.average_missing_issues,
        LAG(t.total_missing_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS post_month_issues,
        t.total_missing_issues - LAG(t.total_missing_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS diff_by_missing_issues,
        t.total_missing_issues - a.average_missing_issues AS diff_by_average_missing_issues,
        CONCAT(ROUND((CAST(t.total_missing_issues AS FLOAT) /SUM(t.total_missing_issues)OVER())*100,2),'%') AS percentage_of_total,

        t.total_temporary_issues,
        a.average_temporary_issues,
        LAG(t.total_temporary_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS post_month_issues,
        t.total_temporary_issues - LAG(t.total_temporary_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) AS diff_by_temporary_issues,
        t.total_temporary_issues - a.average_temporary_issues AS diff_by_average_temporary_issues,
        CONCAT(ROUND((CAST(t.total_temporary_issues AS FLOAT) /SUM(t.total_temporary_issues)OVER())*100,2),'%') AS percentage_of_total,

        CASE
            WHEN t.total_breakfix_issues < a.average_breakfix_issues THEN 'BELOW'
            WHEN t.total_breakfix_issues > a.average_breakfix_issues THEN 'ABOVE'
            WHEN t.total_damage_issues < a.average_damage_issues THEN 'BELOW'
            WHEN t.total_damage_issues > a.average_damage_issues THEN 'ABOVE'
            WHEN t.total_handover_issues < a.average_handover_issues THEN 'BELOW'
            WHEN t.total_handover_issues > a.average_handover_issues THEN 'ABOVE'
            WHEN t.total_missing_issues < a.average_missing_issues THEN 'BELOW'
            WHEN t.total_missing_issues > a.average_missing_issues THEN 'ABOVE'
            WHEN t.total_temporary_issues < a.average_temporary_issues THEN 'BELOW'
            WHEN t.total_temporary_issues > a.average_temporary_issues THEN 'ABOVE'
            ELSE 'Equal to Average'
        END avg_change,

        CASE
            WHEN t.total_breakfix_issues < LAG(t.total_breakfix_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'DECREASE'
            WHEN t.total_breakfix_issues > LAG(t.total_breakfix_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'INCREASE'
            WHEN t.total_damage_issues < LAG(t.total_damage_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'DECREASE'
            WHEN t.total_damage_issues > LAG(t.total_damage_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'INCREASE'
            WHEN t.total_handover_issues < LAG(t.total_handover_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'DECREASE'
            WHEN t.total_handover_issues > LAG(t.total_handover_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'INCREASE'
            WHEN t.total_missing_issues < LAG(t.total_missing_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'DECREASE'
            WHEN t.total_missing_issues > LAG(t.total_missing_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'INCREASE'
            WHEN t.total_temporary_issues < LAG(t.total_temporary_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'DECREASE'
            WHEN t.total_temporary_issues > LAG(t.total_temporary_issues) OVER (PARTITION BY t.issue_year ORDER BY t.issue_year,t.issue_month) THEN  'INCREASE'
            ELSE 'NO CHANGE'
        END diff_by_issue_change

    FROM total_issues t
    LEFT JOIN average_result a
    ON a.issue_year = t.issue_year 
    ORDER BY t.issue_year,t.issue_month

