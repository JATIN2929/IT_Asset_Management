# USER TABLE

> User table should contain following column names
> 
- Staff Id (should be 10 digit id) datatype - INT
- Name datatype VARCHAR
- Job Title datatype VARCHAR
- Grade Level - (should be between 1-10) datatype -INT
- Employee Type-(should be either employee or contractor) datatype VARCHAR
- Functional manager -(should be name of an existing employee only) datatype -VARCHAR
- Mobile datatype - INT
- Country
- Cost Center (it should vary among department) dataype VARCHAR
- Email (should have a specific domain name @tech.com)

> Rules to follow while creating this table
> 
- staff id should be unique
- there should be 1000 different department like IT, HR, Consultant, Customer support etc. like in a bank
- In grade level 1 is the highest and 10 is the lowest where 1 should be only 10 max and 2 will be given to MD as JOB title and 3 will be given to COO or CEO and rest can be like4 - Vice president 5- Assistant Vice president 6 -manager and rest can be based on profiles like analyst ,senior analyst, etc.
- mobile number is not necessary
- email should be in format like [firstname.lastname@tech.com](mailto:firstname.lastname@tech.com) in case of duplicay in names it should use firstname1[lastname@tech.com](mailto:firstname.lastname@tech.com), firstname2[lastname@tech.com](mailto:firstname.lastname@tech.com) and so on
- Functional manger will have grade level higher than the employee and for many employees functional manger can be same but not more than 20
- In case of grade level 1-3 Functional manager will be interrelated that is grade level can be same in some cases.
- Dataset should be of around 10000 employees
- In case of grade level of 1-3 functional manger should be within that grade level only and it should not be empty also cost center and department is different where cost center will be 8 digit code which will be used for charging department on basis of IT assets

[user_table.csv](attachment:f0dc897d-3e12-416b-bea6-2ca16c051afc:user_table.csv)
