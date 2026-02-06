--- Check MAX, MIN and AVG cost and product_service_cost 
SELECT MAX(cost) AS max_cost, MIN(cost) AS min_cost, AVG(cost) AS average_cost FROM Gold.dim_assets_master_table

SELECT MAX(product_service_cost) AS max_product_service_cost, MIN(product_service_cost) min_product_service_cost, AVG(product_service_cost) AS avg_product_service_cost FROM Gold.dim_assets_master_table

--- Check oldest and youngest manufacturing date and end of life date and difference 
SELECT MIN(manufacturing_date) AS oldest_manufacturing_date, MAX(manufacturing_date) AS youngest_manufacturing_date FROM GOLD.dim_assets_master_table

SELECT MIN(end_of_life_date) AS oldest_end_of_life_date, MAX(end_of_life_date) AS youngest_end_of_life_date FROM GOLD.dim_assets_master_table

--- Check life of diiferent products and comapring and analyzing the waranty period of that particular product
SELECT MAX(warranty_period_months) AS max_warranty_period, MIN(warranty_period_months) AS min_warranty_period FROM Gold.dim_assets_master_table

SELECT 
product_name,
DATEDIFF(MONTH,manufacturing_date,end_of_life_date) AS total_life_of_product,
warranty_period_months,
DATEDIFF(MONTH,manufacturing_date,end_of_life_date) - warranty_period_months AS life_left_post_warranty
FROM GOLD.dim_assets_master_table

--- To check life_left_post_warranty for all products
SELECT DISTINCT DATEDIFF(MONTH,manufacturing_date,end_of_life_date) - warranty_period_months AS life_left_post_warranty FROM GOLD.dim_assets_master_table

--- Check oldest and youngest issued date of assets
SELECT MAX(issued_date) AS last_issued_date, MIN(issued_date) AS first_issued_date FROM Gold.dim_asset_allocation_table
SELECT MAX([DATE]) AS last_breakfix_date, MIN([DATE]) AS first_breakfix_date FROM Gold.fact_breakfix_table
SELECT MAX([DATE]) AS last_temporary_asset_date, MIN([DATE]) AS first_temporary_asset_date FROM Gold.fact_temporary_asset_table
SELECT MAX([DATE]) AS last_handover_date, MIN([DATE]) AS first_handover_date FROM Gold.fact_handover_table
SELECT MAX([DATE]) AS last_physical_damage_date, MIN([DATE]) AS first_physical_damage_date FROM Gold.fact_physical_damage_table
SELECT MAX([DATE]) AS last_missing_asset_date, MIN([DATE]) AS first_missing_asset_date FROM Gold.fact_missing_asset_table

