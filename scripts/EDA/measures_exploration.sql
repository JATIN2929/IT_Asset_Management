/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

--- Check total users,department,functional_manager,county
SELECT COUNT(DISTINCT staff_id) AS total_users, COUNT(DISTINCT department) AS total_department, COUNT(DISTINCT functional_manager) AS total_functional_manager, COUNT(DISTINCT country) AS total_country FROM GOLD.fact_user_info_table

--- Check total users on basis of employee status
SELECT employee_status,COUNT(staff_id) AS total_users_by_employye_status FROM GOLD.fact_user_info_table GROUP BY employee_status

--- Check MAX, MIN and AVG cost and product_service_cost 
SELECT MAX(cost) AS max_cost, MIN(cost) AS min_cost, AVG(cost) AS average_cost FROM Gold.dim_assets_master_table

SELECT MAX(product_service_cost) AS max_product_service_cost, MIN(product_service_cost) min_product_service_cost, AVG(product_service_cost) AS avg_product_service_cost FROM Gold.dim_assets_master_table

--- Check total number of products 
SELECT COUNT(product_name) AS total_products FROM Gold.dim_assets_master_table

--- Check total request made
SELECT COUNT(DISTINCT req_id) AS total_request FROM Gold.fact_user_asset_info_table

--- Check total issued assets, temporary asstes , total handover assets , physical damage assets, missing assets
SELECT COUNT(accessories) AS total_issued_accessories FROM GOLD.fact_issued_accessories_table
SELECT COUNT(accessories) AS total_temporary_asset FROM GOLD.fact_temporary_asset_table
SELECT COUNT(other_accessories) AS total_handover_assets FROM GOLD.fact_handover_table
SELECT COUNT(laptop_model) AS total_physical_damage_assets FROM GOLD.fact_physical_damage_table
SELECT COUNT(missing_asset) AS total_missing_assets FROM GOLD.fact_missing_asset_table

--- Check average assets issued to a user
SELECT AVG(total_issued_accessories) AS average_issued_assets FROM
(
SELECT staff_id,COUNT(accessories) AS total_issued_accessories FROM GOLD.fact_issued_accessories_table GROUP BY staff_id
)t 

--- Check total breakfix done
SELECT COUNT(DISTINCT staff_id) AS total_users_with_breakfix FROM Gold.fact_breakfix_table 
SELECT COUNT(*) AS total_breakfix FROM GOLD.fact_breakfix_table 
SELECT reason, COUNT(*) AS total_breakfix_by_reason FROM GOLD.fact_breakfix_table GROUP BY reason
SELECT issue, COUNT(*) AS total_breakfix_by_issue FROM GOLD.fact_breakfix_table GROUP BY issue
SELECT old_asset_model, COUNT(*) AS total_breakfix_by_asset FROM GOLD.fact_breakfix_table GROUP BY old_asset_model 
SELECT old_asset_model, COUNT(*) AS total_breakfix_by_laptop_model FROM GOLD.fact_breakfix_table WHERE old_asset_model != 'Wireless Headset Cushion' AND old_asset_model != 'JBL Wireless Headset' GROUP BY old_asset_model ORDER BY COUNT(*) DESC

--- Check total users who have taken temporary assets
SELECT COUNT(DISTINCT staff_id) AS total_users_with_temporary_asset FROM GOLD.fact_temporary_asset_table
SELECT accessories,COUNT(DISTINCT staff_id) AS total_users_with_temporary_asset_by_accessories FROM GOLD.fact_temporary_asset_table GROUP BY accessories

--- Check total users who have taken handover assets
SELECT COUNT(DISTINCT staff_id) AS total_users_with_handover FROM GOLD.fact_handover_table
SELECT remarks,COUNT(DISTINCT staff_id) AS total_handover_by_reason FROM GOLD.fact_handover_table GROUP BY remarks

--- Check total users who have taken physical damage assets
SELECT COUNT(DISTINCT staff_id) AS total_users_with_physical_damage FROM GOLD.fact_physical_damage_table
SELECT damage_detail,COUNT(DISTINCT staff_id) AS total_handover_by_damage_detail FROM GOLD.fact_physical_damage_table GROUP BY damage_detail 

--- Check total users who have taken missing assets
SELECT COUNT(DISTINCT staff_id) AS total_users_with_missing_asset FROM Gold.fact_missing_asset_table
SELECT missing_asset,COUNT(*) AS total_missing_asset_by_type FROM Gold.fact_missing_asset_table GROUP BY missing_asset

--- Check total assets in store
SELECT COUNT(*) AS toatal_assets FROM Gold.fact_store_assets_table
SELECT laptop_model,COUNT(*) AS toatal_assets_by_assets FROM Gold.fact_store_assets_table GROUP BY laptop_model
SELECT laptop_model,COUNT(*) AS toatal_assets_by_assets FROM Gold.fact_store_assets_table  WHERE laptop_model != 'Wireless Headset Cushion' AND laptop_model != 'JBL Wireless Headset' GROUP BY laptop_model ORDER BY COUNT(*) DESC
SELECT [status],COUNT(*) AS toatal_assets_by_status FROM Gold.fact_store_assets_table GROUP BY [status]