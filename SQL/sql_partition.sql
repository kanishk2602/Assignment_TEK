use joinDB;
-- UNION and PARTITIONING

select * from employee;
select * from expense;

-- SQL Union Clause
-- The Union Clause is used to combine two seperate select statement and produce the result
-- as a union of both the select statements. 
-- Note : The schema field to be used in both select statement must be in same order, same number and data type. 
select id from employee union select id from expense;

-- select multiple fields from both tables
select id, emp_name from employee union all
select id, expanse from expense;

-- Partition in MYSQL
-- SYNTAX :
-- create table table_name partition by range columns(column_list)
-- partition part_name1 values less than (val_list),
-- partition part_name2 values less than (val_list);
 
 -- Partition mysql table by range()
 create table part_employee (empid int, ename varchar(50), age int, address text, salary int)
 partition by range columns(salary)
 (partition p0 values less than (30000),
 partition p1 values less than (50000),
 partition p2 values less than (70000),
 partition p3 values less than (maxvalue));
 
 desc part_employee;
 
insert into part_employee values ( 101,"Test1",20,"Hyderabad",40000);
insert into part_employee values ( 102,"Test2",20,"Hyderabad",10000);
insert into part_employee values ( 103,"Test3",20,"Hyderabad",60000);
insert into part_employee values ( 104,"Test4",20,"Hyderabad",90000);
insert into part_employee values ( 105,"Test5",20,"Hyderabad",100000);
insert into part_employee values ( 106,"Test6",20,"Hyderabad",100);
 
 select * from part_employee;
 
 select partition_name,table_rows from 
 information_schema.PARTITIONS
 where table_schema = 'joinDB' and
 table_name = 'part_employee';
 
 -- Drop a specific partition from table
 alter table part_employee truncate partition p2;
 
-- Partition by List
-- product id (101,102,106)
-- product id (103,105,108)
-- product id (104,107,109)
 create table part_product (product_id int, product_name varchar(50), store_name varchar(50),product_price int)
 partition by list (product_id)
 (partition p0 values in (101,102,106),
 partition p1 values in (103,105,108),
 partition p2 values in (104,107,109));

-- Partition by HASH values
-- Parttioning table is used to distribute according to some predefined number of partitions.
-- Distribute data into table evenly.
-- HASH(columns) partition 4;

-- syntax :
-- create table partition_table
-- (schema of table)
-- partition by hash value(column_name)
-- partition 4;

create table partition_table (empid  int, first_name varchar(50), last_name varchar(50),
gender varchar(50), city varchar(50), country varchar(50))
partition by hash (empid)
partitions 4;
select * from partition_table;

select partition_name, table_rows from information_schema.partitions
where table_schema = 'joindb' and table_name = 'partition_table';

select * from partition_table PARTITION(p1);

drop table if exists partition_table_key;
create table partition_table_key (empid  int, first_name varchar(50), last_name varchar(50),
gender varchar(50), city varchar(50), country varchar(50))
partition by key (first_name)
partitions 5;
-- Use Partition by Key with table having primary key, unique key
-- While creating table dont mention key name in partition by key ()
select partition_name, table_rows from information_schema.partitions
where table_schema = 'joindb' and table_name = 'partition_table_key';

select * from partition_table_key PARTITION(p1);



