    INSERT INTO silver.user_table (
        staff_id,                         
        staff_name,              
        job_title,                                
        employee_status,        
        functional_manager,      
        mobile,                  
        country,                 
        department,             
        cost_center,                     
        email                  
    )
    SELECT 
    staff_id,
    staff_name,
    CASE 
        WHEN grade_level ='1' THEN 'CHAIRMAN'
        WHEN grade_level ='2' THEN 'MANAGING DIRECTOR'
        WHEN grade_level ='4' THEN 'VICE PRESIDENT'
        WHEN grade_level ='5' THEN 'ASSISTANT VICE PRESIDENT'
        WHEN grade_level ='6' THEN 'Manager'
        WHEN grade_level ='7' THEN 'SENIOR ANALYST'
        WHEN grade_level ='8' THEN 'ANALYST'
        WHEN grade_level ='9' THEN 'ASSOCIATE'
        WHEN grade_level ='10' THEN 'JUINOR ASSOCIATE'
        ELSE job_title
    END job_title,
    employee_status,
    functional_manager,
    COALESCE(mobile,NULL,'UNKNOWN') AS mobile,
    country,department,cost_center,email 
    FROM Bronze.user_table

