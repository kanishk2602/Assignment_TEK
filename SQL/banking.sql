create database if not exists bankingDB;

show databases;

use bankingDB;

create table if not exists banking(age int, job varchar(50), marital varchar(50), education varchar(50),
default_value varchar(50), housing varchar(50), loan varchar(50), contact varchar(50),	
contact_month varchar(50), day_of_week varchar(50), duration int, campaign int, pdays int, previous int,
poutcome varchar(50), emp_var_rate decimal(3,1), cons_price_idx decimal(6,3), cons_conf_idx decimal(6,3),
euribor3m decimal(4,3), nr_employed decimal(5,1), y int);

desc banking;

-- DML
-- 1.SELECT
select 1+1;
-- Date and Time
select now();

-- 2. LIMIT - LIMIT the number of records
select age,job,marital from banking  limit 5;

select concat('Guy','Ritchie') as name;

-- 3. LOAD - It inserts records into table using csv files
--    LOCAL - It represents data location is in local  disk

-- Aggregate Function
-- 4. COUNT
select count(*) as count from banking;

-- 5. DISPLAY NUM OF MISSING ROWS
select count(*) as 'num(total)',
count(y) as 'num (non missing )',
count(*) - count(y) as 'num (missing )',
(count(*) - count(y)) * 100 / count(*) as '% missing form' from banking;

-- 
SET GLOBAL local_infile = TRUE;

LOAD  DATA LOCAL INFILE 'D:/SQL data/banking.csv'
into table banking
fields terminated by ','  -- delimiter of columns
lines terminated by '\n'
ignore 1 lines;  -- lines seperated by '\n' or '\r\n'

select * from banking limit 5;

-- 6. COUNT
select count(*) as 'num(total)',
count(y) as 'num (non missing )',
count(*) - count(y) as 'num (missing )',
(count(*) - count(y)) * 100 / count(*) as '% missing form' 
from banking;

-- 7. MAX, MIN, AVG or MEAN
select min(age) as MIN, max(age) as MAX, 
AVG(age) as MEAN from banking;

select min(duration) as MIN, max(duration) as MAX, 
AVG(duration) as MEAN from banking;

-- 8. SUM
select SUM(duration)/3600 as Total_Duration from banking;

-- 9. STD, VAR
select variance(duration) as variance, std(duration) as std_duration  from banking;
select variance(age) as variance, std(age) as std_age  from banking;

-- 10. WHERE
-- Where clause allows you to specify to search condition for rows returned by a query.
-- Where clause to filter rows based on specified conditions
select count(*) as positive_customers from banking where y = 1;

-- Show only not NULL values from education
select education, duration from banking where y=1 and education is not null;

-- 11. ORDER BY 
-- To sort the rows in the result set, we add ORDER BY clause to select statement
-- ORDER BY ASC, desc
-- First month is in descending order and then duration in ascending order.
select age, contact_month, duration from banking where y =1
order by contact_month desc, duration asc;

-- 12. DISTINCT : show unique values from each column
-- To drop duplicate set from result set.
-- Mysql evaluates DISTINCT clause after FROM, WHERE and SELECT and before ORDER BY clause
select distinct(education) as education from banking ;
select distinct(marital) as marital from banking ;

-- 13. LIKE:
-- LIKE Operator is a logical operator that tests whether a string contains specified pattern or not.
select count(*) as success_customer from banking where poutcome like 's%';

-- Count of Customer with education basic 6 year
select distinct education from banking;
select count(*) as edu from banking where education like "%6y";

-- 14. GROUP BY
-- Mysql evaluates GROUP BY clause after FROM and WHERE and before HAVING, SELECT, ORDER BY and LIMIT
-- FROM -> WHERE -> GROUPBY -> HAVING -> SELECT -> DISTINCT -> ORDERBY -> LIMIT

-- total customers contacted each month
SELECT contact_month, count(*)  as target from banking group by contact_month;  
-- total customers contacted every week for each month
SELECT contact_month, day_of_week, count(*)  as target from banking group by contact_month,day_of_week;

-- Show the duration of call in hours for each weekday in each month.
-- *WRONG* select (duration)/3600,contact_month,day_of_week from banking group by duration,contact_month,day_of_week;
select contact_month,day_of_week,sum(duration)/3600 from banking group by contact_month,day_of_week; 

-- 15. HAVING 
-- Mysql evaluates having clause after FROM, WHERE, GROUPBY and before SELECT, DISTINCT, ORDERBY, LIMIT

-- Find total duration, customers contacted in a month and total positive customers 
select contact_month, sum(y) as order_count, sum(duration)/3600 as total_duration_hours
from banking group by contact_month;

-- Use HAVING clause on group by result set
select contact_month, sum(y) as order_count, sum(duration)/3600 as total_duration_hours
from banking where y=1 group by contact_month having order_count > 100 and contact_month like "a%";

-- 16. ROLLUP 
-- ROLLUP generates multiple grouping sets based on columns or expression specified in GROUPBY clause.
-- ROLLUP clause generates not only the subtotal but along with the grand total of columns order clause.
-- ROLLUP assumes that there is following hierarchy : C1>C2>C3
-- It generates the following grouping sets : (C1,C2,C3) , (C1,C2) , (C1) , ()

select job, sum(y) as success_count from banking 
group by job WITH ROLLUP ORDER BY success_count;

select job,day_of_week, sum(y) as success_count from banking 
group by job, day_of_week WITH ROLLUP ORDER BY job;

select job,day_of_week, sum(y) as success_count from banking group by job, day_of_week 
 WITH ROLLUP having job='management' and day_of_week is NULL;
 
 select job,marital,day_of_week, sum(y) as success_count from banking where y > 0
 group by job, marital, day_of_week WITH ROLLUP 
 ORDER BY job DESC;
 -- 1. Each set of day_if_week rows for a given job and marital status generates an extra aggregated summary.
 -- 2. Each set of marital, day_if_week rows for a given job generates an extra aggregated summary.
 -- 3. Grand total of all the rows.
 
 -- 17. SUBQUERY
 -- A Mysql query is query nested within a query.
 -- Such as SELECT, INSERT< UPDATE< DELETE. 
 -- Subquery can be nested within another subquery. 
 
 -- Write a query to show all success count where call duration was greater than average duration
select sum(y) as success_count from banking where duration > (select avg(duration)from banking);
select contact_month,sum(y) as success_count from banking where duration > (select avg(duration)from banking) group by contact_month;

-- FROM Clause in a Subquery
-- Select * from (subquery)
-- When you use subquery in the FROM Clause, the result set returned from a subquery will be used as temporary table.

-- Write a query to show Week wise MAX, MIN, MEAN Success Status
select max(success) as max, min(success) as min, avg(success) as avg 
from
(select day_of_week,sum(y) as success from banking group by day_of_week) as output; 

-- 18. UPDATE
select age, sum(y) as success_count from banking
group by age order by success_count DESC;

ALTER TABLE banking ADD COLUMN age_group varchar(30);

SET SQL_SAFE_UPDATES = 0;
update banking
set age_group = if (age <=25, '<25', if (age > 40, "40+", "25 - 40"));

select age_group, count(*) as emp_num from banking group by age_group;
select age_group, sum(y) as emp_num from banking group by age_group;

select age_group, (sum(y)/count(y))*100 as success_per from banking group by age_group order by success_per desc;


