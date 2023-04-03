-- SQL Stored Procedures
-- 1. Stored Procedure is a database object.
-- 2. A stored procedure is a series of declarative SQL statement
-- 3. Stored Procedure can be stored in the database and can be reused over and over again. 
-- 4. Parameters can be passed to stored procedure so that stored procedure can act based on parameter value(s). 
-- 5. SQL creates an execution plan and stores it in the cache.
-- Types : stored procedurs 
-- 1.) User Defined stored procedure : it is created by DB developers, administrators, these stored procedure
--                                     contains one or more sql statements to select, to delete, to update from DB table
-- 2.) System stored procedure : Are created and executed by SQL server for server admin activities. 

-- Syntax:
-- create procedure procedure_name()
-- begin
-- 	declare var varchar(20);
--     declare var1 float;
-- end;

-- Create, Alter, Parameters, Encrypt procedure

use hremployeedb;

select * from hr_employee where department = 'sales';
 
-- delimiter redefines the mysql delimitere
DELIMITER //
drop procedure if exists sales_dept_list;
create procedure sales_dept_list ()
begin
select * from hr_employee where Department="Sales";
end //
-- redefine delimiter to':'
DELIMITER ;
call sales_dept_list;

delimiter ##
create procedure RND_dept(dept_id varchar(50), emp_age int)
begin
select * from hr_employee where department = dept_id;
select * from hr_employee where age > emp_age;
end ##

call RND_dept('Research & Development', 34);


