create database if not exists joinDB;
use joinDB;

-- 1. 
create table if not exists expense( orderid int, ex_date datetime, id int,expanse int);
-- 2. 
insert into expense values (104,'2021-04-08',3,5000);
insert into expense values (102,'2021-05-08',3,2500);
insert into expense values (103,'2021-03-20',2,2560);
insert into expense values (105,'2021-01-20',4,3060);
insert into expense values (106,'2022-03-21',7,5001);
insert into expense values (107,'2022-02-21',8,2329);
insert into expense values (108,'2022-01-21',9,1399);
insert into expense values (109,'2022-03-21',4,4099);
select * from expense;

-- 3.
create table if not exists employee(id int ,emp_name varchar(50), age int ,address varchar(50), salary decimal(6,2));
-- 4. 
insert into employee values (1,'Ramesh',32,'Delhi',80000.00);
insert into employee values (2,'Kiran',23,'Patna',60000.00);
insert into employee values (3,'Shilpa',21,'Ranchi',20000.00);
insert into employee values (4,'Chandan',23,'Patliputra',26000.00);
insert into employee values (5,'Harsha',24,'Chandighar',34000.00);
insert into employee values (6,'Manohar',20,'UP',180000.00);
insert into employee values (7,'Mufty',22,'Lucknow',40000.00);
select * from employee;

 -- 5. INNER JOIN
 -- Fetch all the orders placed by employees having matching id present in employee table
 -- ON is clause : to define relationship clause between both table
  select * from employee emp JOIN expense exp 
  ON (emp.id = exp.id);
  
select emp.id, emp.emp_name, emp.salary, exp.orderid,
exp.expanse from employee emp 
JOIN expense exp 
ON (emp.id = exp.id);
  
  -- 6. LEFT OUTER JOIN
select emp.id, emp.emp_name, emp.salary, exp.orderid,
exp.expanse from employee emp 
LEFT OUTER JOIN expense exp 
ON (emp.id = exp.id);
  -- (inner join) + left side of the table
  
  -- 7. RIGHT OUTER JOIN
select emp.id, emp.emp_name, emp.salary, exp.orderid,
exp.expanse from employee emp 
right OUTER JOIN expense exp 
ON (emp.id = exp.id);

-- 8. FULL OUTER JOIN
select * from employee emp 
LEFT OUTER JOIN expense exp 
ON (emp.id = exp.id)
UNION
(select* from employee emp 
RIGHT OUTER JOIN expense exp 
ON (emp.id = exp.id));
  
  
  
  