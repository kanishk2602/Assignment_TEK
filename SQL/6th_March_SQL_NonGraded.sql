-- 1. Give the maximum, mean, minimum age of the  targeted customer
-- 2. Check the quality of customers bt checking average balance, median balance of customers
-- 3. Check if age matters in marketing subscription for deposit
-- 4. Check if age and martial status mattered for  subscription to deposit
-- 5. Check if age and martial status together mattered for a subscription to deposit scheme

create database if not exists Bank;
show databases;
use Bank;

create table if not exists bank_table(
age int, job varchar(50), marital varchar(50), education varchar(50), default_value varchar(50),
balance varchar(50),housing varchar(50),loan varchar(50),contact varchar(50),
day_week varchar(50),month_year varchar(50),duration varchar(50),campaign varchar(50),
pdays varchar(50),previous varchar(50),poutcome varchar(50), y varchar(50));

describe bank_table;

select * from bank_table;

-- 1.
select max(age), min(age) from bank_table;

-- 2.
-- select avg(balance) as average,(MIN(balance)+MAX(balance))/2 as median from bank_table;

SET @rowindex := -1;
SELECT AVG(BALANCE), 
( SELECT AVG(d.BALANCE) as Median FROM (SELECT @rowindex:=@rowindex + 1 AS rowindex, bank_table.BALANCE AS BALANCE
FROM bank_table ORDER BY bank_table.BALANCE) AS d WHERE d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
) AS MEDIAN FROM bank_table;

-- 3.
select age, y from bank_table;
select age, count(y) as age_sub from bank_table where y ='yes' group by age order by age;

 -- 4.
 select marital, count(y) as marital_sub from bank_table where y = 'yes' group by marital order by marital;
 
 -- 5.
 select age,marital, count(y) as age_mari_sub from bank_table where y = 'yes' group by age, marital order by age;
 
 -- 6.
ALTER TABLE bank_table ADD COLUMN age_group varchar(30);
SET SQL_SAFE_UPDATES = 0;
update bank_table
set age_group = if (age <=25, '<25', if (age > 40, "40+", "25 - 40"));

select * from bank_table  limit 10;
select age_group, sum(campaign) as camp from bank_table group by age_group;
 