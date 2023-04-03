-- Window Function
select * from hr_employee;

-- write a sql to display maximum salary from HR_Employee table
select department,max(income) from hr_employee group by Department;

-- wrte a query to show employee id,age, jobrole, gender details of employee with department having highest salary
-- over()
-- Adding over() aggregate function it will work as an analytical 
-- over() : used to specify query t create window of records. 

-- show maximum salary from overall data
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,max(income) over()
from hr_employee as hremp;

select *,max(income) over() from hr_employee ;

-- show maximum salary from each job role
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,max(income) 
over(partition by jobrole) as max_jobrole_income from hr_employee as hremp;

select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,max(income) 
over(partition by jobrole order by EmployeeID) as max_jobrole_income from hr_employee as hremp;

-- ROW_NUMBER()
-- Write a query which will show first 3 employee from each job role to  join the company.
select jobrole, employeeid  from hr_employee order by  EmployeeID limit 3;

select * from (
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.department, row_number()
over(partition by jobrole order by EmployeeID) as row_num  from hr_employee as hremp) as t where row_num < 4  ;

-- RANK()
-- Write a query to show top 3 employee from each department earning highest salary.
select * from (
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income,
rank() over(partition by jobrole order by income) as rank_val from hr_employee as hremp)as t where rank_val < 4 ;

--  Apply ranking on Employee AGE 
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income,
rank() over(partition by jobrole order by age desc) as rank_val from hr_employee as hremp;

-- DENSE_RANK()
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income, hremp.workex,
rank() over(partition by jobrole order by age desc , workex desc) as rank_val from hr_employee as hremp;

-- Lag()
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income, hremp.workex,
lag((income),5,0) over(partition by jobrole  order by EmployeeID) as previous_income from hr_employee as hremp;

select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income, hremp.workex,
lag((income),5,'NO DATA AVAILABLE') over(partition by jobrole  order by EmployeeID) as previous_income from hr_employee as hremp;

-- Lead()
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income, hremp.workex,
lead(income) over(partition by jobrole  order by EmployeeID) as next_income from hr_employee as hremp; 

-- Combine more than one window functions with over
select hremp.employeeid,hremp.age, hremp.jobrole, hremp.gender,hremp.department,hremp.income, hremp.workex,
lag(income) over(partition by jobrole  order by EmployeeID) as previous_income ,
lead(income) over(partition by jobrole  order by EmployeeID) as next_income 
from hr_employee as hremp;


-- Write a query to show if income of an employee is higher, lower or equal to the previous employee.

select employeeid, age, jobrole, gender, department, income, workex,
lag(income) over(partition by jobrole  order by EmployeeID) as previous_income ,
case 
when  income>lag(income) over(partition by jobrole  order by EmployeeID) then 'higher'
when  income<lag(income) over(partition by jobrole  order by EmployeeID) then 'lower'
when  income=lag(income) over(partition by jobrole  order by EmployeeID) then 'equal'
end as category
from hr_employee as hremp;





