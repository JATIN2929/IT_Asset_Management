/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions

--- Change in total_breakfix over months
SELECT FORMAT([date], 'yyyy') AS breakfix_year,FORMAT([date], 'MMM') AS breakfix_month,COUNT(*) AS total_breakfix FROM Gold.fact_breakfix_table GROUP BY  FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM') ORDER BY FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM')

--- Change in total_issud_assets over months
SELECT FORMAT([date], 'yyyy') AS issued_year,FORMAT([date], 'MMM') AS issued_month,COUNT(*) AS total_issued FROM Gold.fact_issued_accessories_table GROUP BY  FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM') ORDER BY FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM')

--- Change in total_temporary_assets over months
SELECT FORMAT([date], 'yyyy') AS temporary_asset_year,FORMAT([date], 'MMM') AS temporary_asset_month,COUNT(*) AS total_temporary_asset FROM Gold.fact_temporary_asset_table GROUP BY  FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM') ORDER BY FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM')

--- Change in total_handover_assets over months
SELECT FORMAT([date], 'yyyy') AS handover_asset_year,FORMAT([date], 'MMM') AS handover_asset_month,COUNT(*) AS total_handover_asset FROM Gold.fact_handover_table GROUP BY  FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM') ORDER BY FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM')

--- Change in total_physical_damage over months
SELECT FORMAT([date], 'yyyy') AS physical_damage_year,FORMAT([date], 'MMM') AS physical_damage_month,COUNT(*) AS total_physical_damage FROM Gold.fact_physical_damage_table GROUP BY  FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM') ORDER BY FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM')

--- Change in total_missing_assets over months
SELECT FORMAT([date], 'yyyy') AS missing_asset_year,FORMAT([date], 'MMM') AS missing_asset_month,COUNT(*) AS total_missing_asset FROM Gold.fact_missing_asset_table GROUP BY  FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM') ORDER BY FORMAT([date], 'yyyy') ,FORMAT([date], 'MMM')