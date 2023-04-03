create database if  not exists stocksDB;
use stocksDB;

 select * from stocks;
 describe stocks;
 alter table stocks modify tradedate date;
 -- SET GLOBAL sql_safe_updates = 0;
 -- set sql_safe_udates = 0;
 -- update stocks SET tradedate = str_to_date(tradedate, "%y%m%d");
 
 ALTER TABLE stocks ADD COLUMN spytrends varchar(30);
SET GLOBAL sql_safe_updates = 0;
set sql_safe_updates = 0;

update stocks
set spytrends = if (SPY > 0, 'UP' , 'DOWN');

select avg(amzn), if(amzn >=0, 'UPTREND','DOWNTREND') as direction from stocks group by direction;

-- 19. CASE WHEN THEN
select *, weekday(TradeDate) from stocks;

select *,
	case
		when weekday(TradeDate) = 0 THEN "Monday"
        when weekday(TradeDate) = 1 THEN "Tuesday"
        when weekday(TradeDate) = 2 THEN "Wednesday"
        when weekday(TradeDate) = 3 THEN "Thursday"
        when weekday(TradeDate) = 4 THEN "Friday"
END AS Weekday
	FROM stocks;
    
ALTER TABLE stocks ADD COLUMN weekdays varchar(30);
SET GLOBAL sql_safe_updates = 0;
set sql_safe_updates = 0;

update stocks
set weekdays = 
	(case
		when weekday(TradeDate) = 0 THEN "Monday"
        when weekday(TradeDate) = 1 THEN "Tuesday"
        when weekday(TradeDate) = 2 THEN "Wednesday"
        when weekday(TradeDate) = 3 THEN "Thursday"
        when weekday(TradeDate) = 4 THEN "Friday"
        end);
        
select * from stocks; 

ALTER TABLE stocks ADD COLUMN overall varchar(30);
SET GLOBAL sql_safe_updates = 0;
set sql_safe_updates = 0;

update stocks
set overall = if( (spy+gld+amzn+goog+kpti+gild+mpc)  > 0, "UP","DOWN");

select overall,count(*) from stocks group by overall;

select
	case
		when weekday(TradeDate) = 0 THEN "Monday"
        when weekday(TradeDate) = 1 THEN "Tuesday"
        when weekday(TradeDate) = 2 THEN "Wednesday"
        when weekday(TradeDate) = 3 THEN "Thursday"
        when weekday(TradeDate) = 4 THEN "Friday"
END AS Week_day, round(avg(spy),4), round(avg(gld),4), round(avg(amzn),4), round(avg(goog),4),
round(avg(kpti),4),round(avg(gild),4),round(avg(mpc),4)
FROM stocks group by week_day order by week_day ;


