-- TRANSACTIONS
-- Transcation processing comes to the rescue
-- Mysql transactions you to excute a set of Mysql operations
-- To ensure that the database never contains the result of partial operations.
-- In a set of operations,if one of them fails ,
-- If no error occurs ,the entire set of statements is commited to the database.

-- Steps to be followed :
-- 1. use the START TRANSACTION statement. The BEGIN or BEGIN WORK are the aliases of the  START TRANSACTION.
-- 2. Insert new data into table. 
-- 3. To commit the current transaction and make changes permanent, you can use COMMIT statement.
-- 4. To rollback the current transaction and cancel its changes, you can use ROLLBACK statement.
-- 5. To disable/enable auto-commit mode for current transaction , you can use 'SET autocommit'.
-- MySQL automatically commits the changes permanently to your DB .
-- Disable it using set autocommit=0;

create database if not exists transactions;
use transactions;
drop table if exists orders;
create table orders( 
ordernum int not null,
order_date date not null,
required_date date not null,
shipped_date date default null,
status varchar(30) not null,
comments text,
customernum int(11) not null,
primary key (ordernum)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- InnoDB is storage engine in mysql8.0 (by default)
describe orders;

insert  into orders(ordernum,order_date,required_date,shipped_date,
`status`,comments,customernum) values
(10100,'2003-01-06','2003-01-13','2003-01-10','Shipped',NULL,363),
(10101,'2003-01-09','2003-01-18','2003-01-11','Shipped',
'Check on availability.',128),
(10102,'2003-01-10','2003-01-18','2003-01-14','Shipped',NULL,181),
(10103,'2003-01-29','2003-02-07','2003-02-02','Shipped',NULL,121),
(10104,'2003-01-31','2003-02-09','2003-02-01','Shipped',NULL,141),
(10105,'2003-02-11','2003-02-21','2003-02-12','Shipped',NULL,145),
(10106,'2003-02-17','2003-02-24','2003-02-21','Shipped',NULL,278),
(10107,'2003-02-24','2003-03-03','2003-02-26','Shipped',
'Customer requested to deliver in office address between 9:30 to 18:30
for this shipping',131),
(10108,'2003-03-03','2003-03-12','2003-03-08','Shipped',NULL,385),
(10109,'2003-03-10','2003-03-19','2003-03-11','Shipped',
'Customer requested for early delivery using Amazon Prime',486);

select * from orders;

drop table if exists orderdetails;
create table orderdetails (
ordernum int(11) not null,
productCode varchar(15) not null,
quantityOrdered int(11) not null,
priceEach decimal(10,2) not null,
orderLineNumber smallint(6) not null,  -- bigint, smallint for space optimization
primary key (ordernum,productCode),
key productCode (productCode),
constraint `orderdetails_1`
foreign key (ordernum) references orders (ordernum)
)  ENGINE = InnoDB DEFAULT CHARSET = latin1;

describe orderdetails;

insert  into orderdetails (ordernum,productCode,
quantityOrdered,priceEach,orderLineNumber) values
(10100,'S18_1749',30,'136.00',3),
(10100,'S18_2248',50,'55.09',2),
(10100,'S18_4409',22,'75.46',4),
(10101,'S18_2325',25,'108.06',4),
(10101,'S18_2795',26,'167.06',1),
(10101,'S24_1937',45,'32.53',3),
(10102,'S18_1342',39,'95.55',2),
(10102,'S18_1367',41,'43.13',1),
(10104,'S12_3148',34,'131.44',1),
(10104,'S12_4473',41,'111.39',9),
(10105,'S10_4757',50,'127.84',2),
(10105,'S12_1108',41,'205.72',15),
(10106,'S18_1662',36,'134.04',12),
(10106,'S18_2581',34,'81.10',2);
select * from orderdetails;

select column_name, constraint_name, referenced_column_name, referenced_table_name
from information_schema.KEY_COLUMN_USAGE
where table_name = 'orderdetails';

set autocommit = 0;

-- 1. start a new transaction
start transaction;

-- 2. Get the latest order number
select @ordernum:= MAX(ordernum)+1 From orders;
    
-- 3. Insert a new order for customer
insert into orders(ordernum,order_date,required_Date,shipped_date,
status, customernum)
values (@ordernum,'2023-03-01','2023-03-05','2023-03-08', 'In Process', 1234);

-- 4. Imsert a new order line items
insert into orderdetails
(ordernum,productCode, quantityOrdered, priceEach, orderlineNumber)
values (@ordernum, 'S18_1749', 30, '136', 1),
	   (@ordernum, 'S18_2248', 50, '55.09', 2);
       
-- 5. commit changes
COMMIT;

start transaction;
set sql_safe_updates = 0;
delete from orderdetails;
delete from orders;
select count(*) from orders;

-- 6. Rollback to reverse the changes;
ROLLBACK;

select count(*) from orders;