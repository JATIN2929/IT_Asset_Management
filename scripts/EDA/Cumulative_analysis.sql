===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

--- Change in total_breakfix over months and calculate running total and moving average
SELECT 
FORMAT(breakfix_date, 'yyyy') AS breakfix_year,
FORMAT(breakfix_date, 'MMM') AS breakfix_month,
total_assets,
SUM(total_assets) OVER(PARTITION BY YEAR(breakfix_date) ORDER BY breakfix_date) AS running_total,
AVG(total_assets)  OVER(PARTITION BY YEAR(breakfix_date) ORDER BY breakfix_date) AS moving_average
FROM(
SELECT DATETRUNC(MONTH,[date]) AS breakfix_date,COUNT(*) AS total_assets FROM Gold.fact_breakfix_table GROUP BY DATETRUNC(MONTH,[date])
)t

--- Change in total_issud_assets over months   and calculate running total and moving average 
SELECT 
FORMAT(issued_date, 'yyyy') AS issued_year,
FORMAT(issued_date, 'MMM') AS issued_month,
total_assets,
SUM(total_assets) OVER(PARTITION BY YEAR(issued_date) ORDER BY issued_date) AS running_total,
AVG(total_assets)  OVER(PARTITION BY YEAR(issued_date) ORDER BY issued_date) AS moving_average
FROM(
SELECT DATETRUNC(MONTH,[date]) AS issued_date,COUNT(*) AS total_assets FROM Gold.fact_issued_accessories_table GROUP BY DATETRUNC(MONTH,[date])
)t

--- Change in total_temporary_assets over months and calculate running total and moving average 
SELECT 
FORMAT(temporary_asset_date, 'yyyy') AS temporary_asset_year,
FORMAT(temporary_asset_date, 'MMM') AS temporary_asset_month,
total_assets,
SUM(total_assets) OVER(PARTITION BY YEAR(temporary_asset_date) ORDER BY temporary_asset_date) AS running_total,
AVG(total_assets)  OVER(PARTITION BY YEAR(temporary_asset_date) ORDER BY temporary_asset_date) AS moving_average
FROM(
SELECT DATETRUNC(MONTH,[date]) AS temporary_asset_date,COUNT(*) AS total_assets FROM Gold.fact_temporary_asset_table GROUP BY DATETRUNC(MONTH,[date])
)t

--- Change in total_handover_assets over months and calculate running total and moving average 
SELECT 
FORMAT(handover_date, 'yyyy') AS breakfix_year,
FORMAT(handover_date, 'MMM') AS breakfix_month,
total_assets,
SUM(total_assets) OVER(PARTITION BY YEAR(handover_date) ORDER BY handover_date) AS running_total,
AVG(total_assets)  OVER(PARTITION BY YEAR(handover_date) ORDER BY handover_date) AS moving_average
FROM(
SELECT DATETRUNC(MONTH,[date]) AS handover_date,COUNT(*) AS total_assets FROM Gold.fact_handover_table GROUP BY DATETRUNC(MONTH,[date])
)t

--- Change in total_physical_damage over months and calculate running total and moving average 
SELECT 
FORMAT(physical_damage_date, 'yyyy') AS breakfix_year,
FORMAT(physical_damage_date, 'MMM') AS breakfix_month,
total_assets,
SUM(total_assets) OVER(PARTITION BY YEAR(physical_damage_date) ORDER BY physical_damage_date) AS running_total,
AVG(total_assets)  OVER(PARTITION BY YEAR(physical_damage_date) ORDER BY physical_damage_date) AS moving_average
FROM(
SELECT DATETRUNC(MONTH,[date]) AS physical_damage_date,COUNT(*) AS total_assets FROM Gold.fact_physical_damage_table GROUP BY DATETRUNC(MONTH,[date])
)t

--- Change in total_missing_assets over months and calculate running total and moving average 
SELECT 
FORMAT(missing_asset_date, 'yyyy') AS missing_asset_year,
FORMAT(missing_asset_date, 'MMM') AS missing_asset_month,
total_assets,
SUM(total_assets) OVER(PARTITION BY YEAR(missing_asset_date) ORDER BY missing_asset_date) AS running_total,
AVG(total_assets)  OVER(PARTITION BY YEAR(missing_asset_date) ORDER BY missing_asset_date) AS moving_average
FROM(
SELECT DATETRUNC(MONTH,[date]) AS missing_asset_date,COUNT(*) AS total_assets FROM Gold.fact_missing_asset_table GROUP BY DATETRUNC(MONTH,[date])
)t
