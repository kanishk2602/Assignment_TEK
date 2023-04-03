use joinDB;

create table if not exists emp( empid varchar(50), emp_name varchar(50), salary int, department_id varchar(50),
manager_id varchar(50));
insert into emp values ('TEK104','Kanishk',10000,'D1','M1');
insert into emp values ('TEK104','Qwerty',30000,'D2','M2');
insert into emp values ('TEK103','Abcde',20000,'D2','M2');
insert into emp values ('TEK105','Wxyz',40000,'D3','M3');
insert into emp values ('TEK106','Pqrst',70000,'D1','M1');
insert into emp values ('TEK107','Lmnop',80000,'D3','M3');
insert into emp values ('TEK111','asdfg',888,'D13','M13');

create table if not exists department( department_id varchar(50),department_name varchar(50));
insert into department values ('D1','DI');
insert into department values ('D2','DA');
insert into department values ('D3','ECA');
insert into department values ('D4','EI');
insert into department values ('D5','TDA');

create table if not exists manager(manager_id varchar(50), manager_name varchar(50), department_id varchar(50));
insert into manager values ('M1','ABC','D1');
insert into manager values ('M2','DEF','D2');
insert into manager values ('M3','GHI','D3');
insert into manager values ('M4','XYZ','D4');

create table if not exists project(project_id varchar(50), project_name varchar(50), team_member_id varchar(50));
insert into project values
('P1','Data Migration','TEK104'),
('P1','Data Migration','TEK105'),
('P2','ETL Tool','TEK106'),
('P2','ETL Tool ','TEK107');

-- 1. Display all records from all tables
select * from emp;
select * from department;
select * from manager;
select * from project;

-- 2. Fetch the employee name and department name they are working.
select em.emp_name, dept.department_name from emp em join department dept 
on (em.department_id = dept.department_id);

-- 3. Fetch all employee name and their department name they are working.
select em.emp_name, dept.department_name from emp em left outer join department dept 
on (em.department_id = dept.department_id);

-- 4. Fetch all departments name and employee name working in it. 
select em.emp_name, dept.department_name from emp em right outer join department dept 
on (em.department_id = dept.department_id);

-- 5. Fetch all departments name and all employee name working in it. 
select em.emp_name, dept.department_name from emp em left outer join department dept 
on (em.department_id = dept.department_id)
union
select em.emp_name, dept.department_name from emp em right outer join department dept 
on (em.department_id = dept.department_id);

-- 6. Fetch details of ALL emp, their manager, their department and the projects they work on. 
select * from emp em  left join manager man 
on (em.department_id = man.department_id)
left JOIN project pro on (pro.team_member_id = em.empid)
left JOIN department dept  on (em.department_id = dept.department_id);

-- 7.  Fetch details of only emp, their manager, their department and the projects they work on. 
select * from emp em left join manager man 
on (em.department_id = man.department_id)
JOIN project pro on (pro.team_member_id = em.empid)
JOIN department dept  on (em.department_id = dept.department_id);

-- Display all employee who have been assigned with projects having manager, and dept
select * from emp em inner join project pro on (pro.team_member_id = em.empid)
inner join manager man on (em.department_id = man.department_id)
inner join department dept  on (em.department_id = dept.department_id);

-- Display all employees who hhave been asigned with projects and also all managers and all departments. 
select * from emp em inner join project pro on (pro.team_member_id = em.empid)
right join manager man on (em.department_id = man.department_id)
right join department dept  on (man.department_id = dept.department_id);
-- union
-- select * from emp em inner join project pro on (pro.team_member_id = em.empid)
-- right join manager man on (em.department_id = man.department_id)
-- left join department dept  on (man.department_id = dept.department_id);


-- MySQL CROSS JOIN
-- Result set will include all rows from both tables, where each row is the combination of the rows in the first
-- table with the row in second table. 
-- Returns cartesian product
select * from emp;
select * from department;
select em.emp_name, dept.department_name
from emp em  -- 6
cross join department dept; -- 4
-- Total result will be 6 x 4 = 24

-- Write a query to fetch all employee name and their coressponding department name . 
-- Also make sure to display the company name and company location corresponding to each employee

drop table if exists company;
create table company (company_id varchar(50) ,company_name varchar(40),location varchar(50));
insert into company values ('C0001', 'TEK Systems','Hyderabad');

select em.empid,em.emp_name, dept.department_name,c.company_name, c.location from emp em
join department dept on (em.department_id = dept.department_id)
cross join company c;

-- NATURAL JOIN
-- Natural Join is similar to inner join without condition
select em.emp_name, dept.department_name from emp em 
natural join department dept;

-- Natural join between tables with no common column names then it will do cross join. 
select em.emp_name, pro.project_name ,pro.team_member_id 
from emp em natural join project pro;

-- SELF JOIN
-- It joins a table with itself using either INNER JOIN or LEFT JOIN. 
-- Self join can also be done using where clause. 
select em.emp_name, em.empid, e.emp_name, e.empid from emp em 
inner join emp e on em.emp_name = e.emp_name;

-- Show all employees having same salary
select em.emp_name,  em.salary from emp em 
join emp e on em.salary = e.salary; 
-- != or <> (not equals to)
