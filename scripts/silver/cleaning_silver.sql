/*
===============================
Checking bronze.user_table
===============================
*/

---Check For Nulls and Duplicates in Primary key and Clean Data---
---Ecpectation: No Nulls and Duplicates in Primary key columns---


SELECT staff_id,cost_center,department,COUNT(*) FROM Bronze.user_table
GROUP BY email,cost_center,department,staff_id
HAVING COUNT(*) > 1 OR email IS NULL OR cost_center IS NULL OR department IS NULL OR staff_id IS NULL -- NO ERROR FOUND

SELECT staff_name,functional_manager FROM Bronze.user_table
WHERE staff_name !=TRIM(staff_name)    -- NO ERROR FOUND
OR functional_manager != TRIM(functional_manager)

SELECT DISTINCT job_title FROM Bronze.user_table

SELECT DISTINCT grade_level FROM Bronze.user_table

SELECT job_title,grade_level 
FROM BRONZE.user_table
GROUP BY grade_level,job_title
HAVING COUNT(*) > 1 OR job_title IS NULL
ORDER BY grade_level

SELECT COUNT(*) FROM BRONZE.user_table
WHERE mobile IS NULL

SELECT DISTINCT employee_status FROM Bronze.user_table;

SELECT DISTINCT country FROM Bronze.user_table

/*
======================================
Checking bronze.asset_allocation
======================================
*/

SELECT * FROM Bronze.asset_allocation_table

SELECT
product_id,staff_id,COUNT(*)
FROM Bronze.asset_allocation_table
GROUP BY product_id,staff_id
HAVING COUNT(*) > 1 OR product_id IS NULL OR staff_id IS NULL

SELECT 
product_name,req_id
FROM Bronze.asset_allocation_table
WHERE product_name != TRIM(product_name)
AND req_id != TRIM(req_id)

SELECT DISTINCT SUBSTRING(serial_number,1,4) FROM Bronze.asset_allocation_table

SELECT 
MIN(issued_date),
MAX(issued_date)
FROM Bronze.asset_allocation_table

SELECT DISTINCT asset_collection_status FROM Bronze.asset_allocation_table

SELECT product_cost FROM Bronze.asset_allocation_table
WHERE product_cost<=0 AND product_cost IS NULL

/*
======================================
Checking bronze.temporary_asset_table
======================================
*/
SELECT * FROM Bronze.temporary_asset_table

SELECT MIN([date]),
MAX([date])
FROM Bronze.temporary_asset_table

SELECT staff_id FROM Bronze.temporary_asset_table
WHERE  EXISTS (SELECT staff_id FROM Bronze.user_table)

SELECT DISTINCT [status] FROM Bronze.temporary_asset_table
WHERE [status] != TRIM([status])

SELECT 
DISTINCT accessories
FROM Bronze.temporary_asset_table
WHERE accessories NOT LIKE '%|%'

SELECT 
DISTINCT accessories, staff_id
FROM Bronze.temporary_asset_table
WHERE accessories LIKE '%|%'

SELECT 
    CAST(b.date AS DATE),
    b.staff_id,
    LTRIM(RTRIM(s.[value])) AS accessories,
    b.status
    
FROM bronze.temporary_asset_table b
CROSS APPLY STRING_SPLIT(accessories, '|') s 
WHERE b.accessories IS NOT NULL
  AND LTRIM(RTRIM(value)) != ''
ORDER BY b.staff_id

select  staff_id, COUNT(*)
from Bronze.temporary_asset_table
GROUP BY staff_id
HAVING COUNT(*) > 1 or staff_id is null

/*
======================================
Checking bronze.store_assets_table
======================================
*/

SELECT * FROM Bronze.store_assets_table

SELECT DISTINCT [status]
FROM BRONZE.store_assets_table

SELECT DISTINCT LOWER(TRIM(end_of_life))
FROM BRONZE.store_assets_table

SELECT 
CASE
    WHEN SUBSTRING(LOWER(TRIM(end_of_life)),1,3) = 'yes' THEN 'YES'
    WHEN SUBSTRING(LOWER(TRIM(end_of_life)),1,2) = 'no' THEN 'NO'
    ELSE 'UNKNOWN'
END end_of_life
FROM Bronze.store_assets_table

/*
======================================
Checking bronze.physical_damage_table
======================================
*/

SELECT * FROM Bronze.physical_damage_table

/*
======================================
Checking bronze.missing_assets_table
======================================
*/

SELECT distinct missing_asset FROM Bronze.missing_asset_table

/*
==========================================
Checking bronze.issued_accessories_table
==========================================
*/

SELECT req_id,COUNT(*) FROM Bronze.issued_accessories_table
GROUP BY req_id
HAVING COUNT(*) > 1 OR req_id IS NULL

SELECT 
staff_id,
LTRIM(RTRIM(s.[value])) AS accessories
FROM Bronze.issued_accessories_table
CROSS APPLY string_split(accessories,'|') s
WHERE accessories IS NOT NULL
    AND LTRIM(RTRIM([value])) != ''


/*
==========================================
Checking bronze.handover_table
==========================================
*/

SELECT * FROM Bronze.handover_table

SELECT 
DISTINCT remarks
FROM Bronze.handover_table

SELECT 
staff_id,
LTRIM(RTRIM(s.[value])) AS other_accessories
FROM Bronze.handover_table
CROSS APPLY string_split(other_accessories,'|') s
WHERE other_accessories IS NOT NULL
    AND LTRIM(RTRIM([value])) != ''

/*
==========================================
Checking bronze.breakfix_table
==========================================
*/

SELECT * FROM Bronze.breakfix_table

SELECT DISTINCT reason FROM Bronze.breakfix_table

SELECT DISTINCT issue FROM Bronze.breakfix_table

SELECT 
hostname,COUNT(*)
FROM Bronze.breakfix_table
GROUP BY hostname
HAVING COUNT(*)> 1 OR hostname IS NULL


/*
==========================================
Checking bronze.assets_master_table
==========================================
*/

SELECT * FROM Bronze.assets_master_table