-- VIEWS/MATERIALIZED VIEW
-- Views are database objects.
-- Views is created over a SQL Query.
-- Views are like virtual table and doesnot store ant data.

create database if not exists views;
use views;

drop table customer_data;

create table if not exists customer_data(customer_id varchar(20), customer_name varchar(60), phone bigint,
email varchar(50), city_name varchar(50));

create table if not exists product(product_id varchar(20), product_name varchar(50),
 `brand-company` varchar(60), price int);
 
 create table if not exists order_details (order_id int, product_id varchar(20), quantity int,
 customer_id varchar(20), discount float, date_of_order date);
 
INSERT INTO customer_data
VALUES
('C1', 'Divya Parasher', 123456789321, 'parasherdivya@example.com', 'Mathura'),
('C2', 'Mahad Ulah', 456544831568, 'ullahmahad@example.com', 'Bhopal'),
('C3', 'Arya Pratap Singh', 93543168435, 'aryasingh@example.com', 'lucknow'),
('C3', 'Atreya Bag', 7896516832, 'bagatreya@example.com', 'Vizag'),
('C4', 'Mukund Sahu', 673218987351, 'mukund@example.com', 'Mumbai'),
('C5', 'Parth Tyagi', 8989989899, 'parth@example.com', 'Kota');
 
INSERT INTO product
VALUES
    ('DF12321', 'Mouse', 'Dell', 19.37),
    ('AM12322', 'Laptop', 'Apple Inc.', 999.41),
	('MP12333', 'Books', 'Pustak Mahal', 5.19),
    ('12335M', 'Bottle', 'Milton', 29.35),
    ('SB12387I', 'Backpack', 'Sky Bags', 89.75),
    ('PT12389TS', 'Tshirt', 'Polo', 3.53);
 
 INSERT INTO order_details
(order_id, product_id, quantity, customer_id, discount, date_of_order)
VALUES
    (1111, 'DF12321', 3, 'C2', 0.05, '2022-02-01'),
    (2122, 'AM12322', 2, 'C1', 0.25, '2022-02-02'),
    (3323, 'MP12333', 5, 'C1', 0.15, '2022-02-03'),
    (4447, '12335M', 2, 'C3', 0.10, '2022-02-04'),
    (5655, 'SB12387I', 3, 'C2', 0.10, '2022-02-05'),
    (6686, 'PT12389TS', 1, 'C4', 0.15, '2022-02-06');
 
 -- Create a query to show order summary to be delivered to client
 
select o.order_id, o.date_of_order, p.product_name, c.customer_name,
round((p.price * o.quantity) - ((p.price * o.quantity) * discount),3) as cost
from customer_data c
join order_details o on o.customer_id = c.customer_id
join product p on p.product_id = o.product_id;

-- Create VIEW 
create view product_order_summary
as
select o.order_id, o.date_of_order, p.product_name, c.customer_name,
round((p.price * o.quantity) - ((p.price * o.quantity) * discount),3) as cost
from customer_data c
join order_details o on o.customer_id = c.customer_id
join product p on p.product_id = o.product_id;

-- Display output of view
select * from product_order_summary;

-- show view summary
show create view product_order_summary;

-- Security in View is by grant
-- create role username loginaccess and password 'login password'
-- syntax : grant select on 'view name' to 'username'
grant select on product_order_summary to root;

-- Security in view : 
-- Hiding entire query/ table name / used to generate the view

-- CREATE OR REPLACE VIEW
-- Cannot change column name, or column sequence or order
-- But can add a new column in the end
create or replace view product_order_summary
as
select o.order_id, o.date_of_order, p.product_name, c.customer_name,
round((p.price * o.quantity) - ((p.price * o.quantity) * discount),3) as cost
from customer_data c
join order_details o on o.customer_id = c.customer_id
join product p on p.product_id = o.product_id;

-- ALTER VIEW
ALTER
	ALGORITHM = MERGE
VIEW product_order_summary AS
	select o.order_id, o.date_of_order, p.product_name, c.customer_name,
	round((p.price * o.quantity) - ((p.price * o.quantity) * discount),3) as cost
	from customer_data c
	join order_details o on o.customer_id = c.customer_id
	join product p on p.product_id = o.product_id;
    
Drop view product_order_summary;

-- UPDATE 
create or replace view expensive_products
as
select * from product where price > 80;

select * from expensive_products;

set sql_safe_updates = 0;

update expensive_products
set product_name = 'Air Jordan', `brand-company` = 'NIKE',
price = 1000
where product_id = 'AM12322';

select * from expensive_products;