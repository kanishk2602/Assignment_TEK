-- My SQL Case Study on Flights
-- GRADED ASSIGNMENT - II

-- a. Create external table “flights” using Database “airline_delayDB”
create database if not exists airline_delayDB;
use airline_delayDB;

create table if not exists flight_clean (ID int,	YEAR_d int, MONTH_d int, DAY_d int, DAY_OF_WEEK int,
AIRLINE text, FLIGHT_NUMBER int, TAIL_NUMBER text,ORIGIN_AIRPORT text, DESTINATION_AIRPORT text,	
SCHEDULED_DEPARTURE int, DEPARTURE_TIME double, DEPARTURE_DELAY double,	TAXI_OUT double, WHEELS_OFF double,
SCHEDULED_TIME int,	ELAPSED_TIME double, AIR_TIME double, DISTANCE int,	WHEELS_ON double,	
TAXI_IN double,	SCHEDULED_ARRIVAL int,	ARRIVAL_TIME double, ARRIVAL_DELAY double, DIVERTED int, CANCELLED int
);

-- b. Describe the table schema & show top 10 rows of Dataset
describe flight_clean;
select * from flight_clean limit 10;

-- c. Find duplicates rows present in dataset.
SELECT
ID,	YEAR,	MONTH,	DAY	, DAY_OF_WEEK, AIRLINE, FLIGHT_NUMBER, TAIL_NUMBER, ORIGIN_AIRPORT,
DESTINATION_AIRPORT, SCHEDULED_DEPARTURE, DEPARTURE_TIME, DEPARTURE_DELAY, TAXI_OUT, WHEELS_OFF,
SCHEDULED_TIME,	ELAPSED_TIME, AIR_TIME,	DISTANCE, WHEELS_ON, TAXI_IN , SCHEDULED_ARRIVAL, ARRIVAL_TIME,
ARRIVAL_DELAY,	DIVERTED, CANCELLED,
COUNT(*) occurrences 
FROM flight_clean GROUP BY
ID,	YEAR,	MONTH,	DAY	,DAY_OF_WEEK,	AIRLINE	,FLIGHT_NUMBER	, TAIL_NUMBER, ORIGIN_AIRPORT,
DESTINATION_AIRPORT	, SCHEDULED_DEPARTURE,	DEPARTURE_TIME,	DEPARTURE_DELAY	, TAXI_OUT,	WHEELS_OFF,
SCHEDULED_TIME,	ELAPSED_TIME,	AIR_TIME,	DISTANCE,	WHEELS_ON,	TAXI_IN	, SCHEDULED_ARRIVAL,	ARRIVAL_TIME,
ARRIVAL_DELAY,	DIVERTED, CANCELLED	
HAVING COUNT(*) > 1;

-- d. Average arrival delay caused by airlines
select AIRLINE, avg(ARRIVAL_DELAY) from flight_clean where ARRIVAL_DELAY >0 group by AIRLINE;

-- e. Days of months with respected to average of arrival delays
select AIRLINE, day, avg(ARRIVAL_DELAY) as avg_arrival from flight_clean where ARRIVAL_DELAY >0 group by AIRLINE,day;

-- f. Arrange weekdays with respect to the average arrival delays caused
select AIRLINE, DAY_OF_WEEK, avg(ARRIVAL_DELAY) as avg_arrival from flight_clean where ARRIVAL_DELAY >0 group by AIRLINE,DAY_OF_WEEK order by DAY_OF_WEEK;

-- g. Arrange Days of month as per cancellations done in Descending
select day, sum(CANCELLED) as cancellation from flight_clean group by day order by day desc;

-- h. Finding busiest airports with respect to day of week
select ORIGIN_AIRPORT,count(ORIGIN_AIRPORT) as airport, day_of_week as weekday from flight_clean 
group by ORIGIN_AIRPORT, day_of_week order by day_of_week;

-- i. Finding airlines that make the maximum number of cancellations
select airline, sum(CANCELLED) from flight_clean where CANCELLED = 1 group by airline order by sum(CANCELLED) desc limit 1 ;

-- j. Find and order airlines in descending that make the most number of diversions
select airline, sum(DIVERTED) as diversions from flight_clean where DIVERTED = 1 group by airline order by airline desc;

-- k. Finding days of month that see the most number of diversion
select day, sum(DIVERTED) as diversions from flight_clean where DIVERTED = 1 group by day order by day desc;

-- l. Calculating mean and standard deviation of departure delay for all flights in minutes
select airline, avg(DEPARTURE_DELAY) as mean,std(DEPARTURE_DELAY) as std_dev from flight_clean group by airline;

-- m.Calculating mean and standard deviation of arrival delay for all flights in minutes
select airline, avg(ARRIVAL_TIME) as mean,std(ARRIVAL_TIME) as std_dev from flight_clean group by airline;

-- n.

-- o. Create a partitioning table “flights_partition” using suitable partitioned by schema.

select count(distinct(airline)) from flight_clean;
select distinct(airline) from flight_clean;

create table flights_partition(ID int,	YEAR_d int, MONTH_d int, DAY_d int, DAY_OF_WEEK int,
AIRLINE text, FLIGHT_NUMBER int, TAIL_NUMBER text,ORIGIN_AIRPORT text, DESTINATION_AIRPORT text,	
SCHEDULED_DEPARTURE int, DEPARTURE_TIME double, DEPARTURE_DELAY double,	TAXI_OUT double, WHEELS_OFF double,
SCHEDULED_TIME int,	ELAPSED_TIME double, AIR_TIME double, DISTANCE int,	WHEELS_ON double,	
TAXI_IN double,	SCHEDULED_ARRIVAL int,	ARRIVAL_TIME double, ARRIVAL_DELAY double, DIVERTED int, CANCELLED int)
partition by KEY (airline)
PARTITIONS 7;

select * from flights_partition;

select partition_name, table_rows from information_schema.partitions
where table_schema = 'airline_delaydb' and table_name = 'flights_partition';

select * from flights_partition PARTITION(p1);

-- p. Finding all diverted Route from a source to destination Airport & which route is the most diverted
select ORIGIN_AIRPORT, DESTINATION_AIRPORT, count(*) as DIVERTED from flight_clean  group by ORIGIN_AIRPORT, DESTINATION_AIRPORT order by diverted asc;

-- q. Write a query to show Top 3 airlines from each airport making most Delays.(Use Dense Rank/ Rank)
select airline, ORIGIN_AIRPORT, DESTINATION_AIRPORT, DEPARTURE_DELAY+ARRIVAL_DELAY as delay,
dense_rank() over(partition by DEPARTURE_DELAY+ARRIVAL_DELAY order by airline desc) as rank_val from flight_clean order by rank_val limit 3;

-- r. Write a query to show Top 10 airlines from each week making most Delays. Find its Ranking.
select airline,ORIGIN_AIRPORT, DESTINATION_AIRPORT, DEPARTURE_DELAY+ARRIVAL_DELAY as delay,
dense_rank() over(partition by DEPARTURE_DELAY+ARRIVAL_DELAY order by airline desc) as rank_val
from flight_clean where DEPARTURE_DELAY!=99999 and ARRIVAL_DELAY!=99999 and DEPARTURE_DELAY>0 and ARRIVAL_DELAY>0 order by rank_val;

-- s. 



-- t. Create a new column named ‘Delay_Comaprison’ showing if flights making higher or lower than average flight delay.
alter table flight_clean add Delay_Comparison varchar(50);
set sql_safe_updates = 0;
SET @avg_delay := (SELECT AVG(Departure_Delay + Arrival_Delay) FROM flight_clean);
UPDATE flight_clean
SET Delay_Comparison = IF((Departure_Delay + Arrival_Delay) > @avg_delay, 'Higher', 'Lower');
select * from flight_clean;

-- u. Finding AIRLINES with its total flight count, total number of flights arrival delayed by more than 30 Minutes,
 --  % of such flights delayed by more than 30 minutes when it is not Weekends with minimum count of flights from
 --  Airlines by more than 10. Also Exclude some of Airlines 'AK', 'HI', 'PR', 'VI' and arrange output in descending
 --  order by % of such count of flights. 
SELECT
    airline,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN arrival_delay > 30 THEN 1 ELSE 0 END) AS delayed_flights,
    SUM(CASE WHEN arrival_delay > 30 AND day_of_week NOT IN (1,7) THEN 1 ELSE 0 END) AS delayed_not_weekend_flights,
    100 * SUM(CASE WHEN arrival_delay > 30 AND day_of_week NOT IN (1,7) THEN 1 ELSE 0 END) / NULLIF(COUNT(CASE WHEN day_of_week NOT IN (1,7) THEN 1 END), 0) AS percentage_delayed_not_weekend_flights
FROM flight_clean
WHERE airline NOT IN ('AK', 'HI', 'PR', 'VI') and
ARRIVAL_DELAY!=99999 and ARRIVAL_DELAY>0
GROUP BY airline
HAVING COUNT(*) > 10
ORDER BY percentage_delayed_not_weekend_flights DESC;

-- v. Finding AIRLINES with its total flight count with total number of flights departure delayed by less than
--    30 Minutes, % of such flights delayed by less than 30 minutes when it is Weekends with minimum count of flights
--    from Airlines by more than 10. Also Exclude some of Airlines 'AK', 'HI', 'PR', 'VI' and arrange output in 
--    descending order by % of such count of flights. 
SELECT
    airline,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN arrival_delay < 30 THEN 1 ELSE 0 END) AS delayed_flights,
    SUM(CASE WHEN arrival_delay < 30 AND day_of_week NOT IN (1,7) THEN 1 ELSE 0 END) AS delayed_not_weekend_flights,
    100 * SUM(CASE WHEN arrival_delay > 30 AND day_of_week NOT IN (1,7) THEN 1 ELSE 0 END) / NULLIF(COUNT(CASE WHEN day_of_week NOT IN (1,7) THEN 1 END), 0) AS percentage_delayed_not_weekend_flights
FROM flight_clean
WHERE airline NOT IN ('AK', 'HI', 'PR', 'VI') and
ARRIVAL_DELAY!=99999 and ARRIVAL_DELAY>0
GROUP BY airline
HAVING COUNT(*) > 10
ORDER BY percentage_delayed_not_weekend_flights DESC;

-- w) When is the best time of day/day of week/time of a year to fly with minimum delays?
SELECT day_of_week, month, year, MIN(arrival_delay + departure_delay) AS min_delay
FROM flight_clean
where DEPARTURE_DELAY!=99999 and ARRIVAL_DELAY!=99999 and DEPARTURE_DELAY>0 and ARRIVAL_DELAY>0
GROUP BY day_of_week, month, year;
    
-- x) Suggest reasons of airlines delays and suggest, build solutions for it.
SELECT DEPARTURE_DELAY, COUNT(*) AS NUM_DELAYS, ROUND(AVG(ELAPSED_TIME), 2) AS Avg_elpased_time,
ROUND(AVG(DISTANCE), 2) AS Avg_distance, sum(DIVERTED) as diverted_flights, avg(TAXI_IN+TAXI_OUT) as taxi_time
FROM flight_clean WHERE DEPARTURE_DELAY>0 and DEPARTURE_DELAY!=99999
GROUP BY DEPARTURE_DELAY ORDER BY NUM_DELAYS DESC LIMIT 10;

-- y)	Create a stored procedure to find weeks with maximum flights delays count.
DELIMITER //
CREATE PROCEDURE FindWeeksWithMaxDelayCount()
BEGIN
  SELECT day_of_week, COUNT(*) as DelayCount
  FROM flight_clean
  WHERE arrival_delay > 0 AND departure_delay > 0 AND totalDelay = arrival_delay + departure_delay
  GROUP BY day_of_week
  HAVING COUNT(*) = (SELECT TOP 1 COUNT(*) FROM flights_delay_claeaned
  WHERE arrival_delay > 0 AND departure_delay > 0 AND totalDelay = arrival_delay + departure_delay GROUP BY day_of_week ORDER BY COUNT(*) DESC)
END
DELIMITER ;
