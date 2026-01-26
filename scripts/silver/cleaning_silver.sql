/*
===============================
Checking bronze.user_table
===============================
*/

---Check For Nulls and Duplicates in Primary key and Clean Data---
---Ecpectation: No Nulls and Duplicates in Primary key columns---


SELECT staff_id,cost_center,department,COUNT(*) FROM Bronze.user_table
GROUP BY email,cost_center,department,staff_id
HAVING COUNT(*) > 1 OR email IS NULL OR cost_center IS NULL OR department IS NULL OR staff_id IS NULL
OR (SELECT email,cost_center,department,staff_id FROM Bronze.user_table) IS NULL   -- NO ERROR FOUND

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



