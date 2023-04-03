-- create database 
create database if not exists employeeDB;

-- database changed
use employeeDB;

-- to show list of databases
show databases;
-- to show list of tables
show tables;
-- to show list of table present in sys database
show tables in sys;
show tables in employeeDB; 

-- Create a table with given schema
create table if not exists Employee(
empid varchar(20) NOT NULL,
empname varchar(50), age int, gender varchar(10),
department varchar(40), salary int,
primary key(empid));

show tables;

-- insert into <tablename> values();
insert into Employee values('TEK1001','Kanishk',22,'Male','DI',10000);
select * from Employee;




