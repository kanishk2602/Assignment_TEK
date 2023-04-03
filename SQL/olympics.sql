-- 1.
create database if not exists olympics_db;
use olympics_db;
-- 2 , 3, 4 

-- 5. 
select * from olympics;

-- 6. 
select team,count(team) as participation from olympics where season = 'summer' or season = 'winter' group by team;

-- 7. 
select distinct sport from olympics;

-- 8. 
select distinct count(id)  as part from olympics where season = 'summer';

-- 9.
select year, event, count(event), season from olympics group by year,event, season order by year;

-- 10.
select distinct count(me),count(sport) from olympics;

-- 11.
select distinct me, age from olympics order by age desc limit 10;

-- 12. 
select distinct me, weight from olympics order by weight desc limit 10;

-- 13.
select distinct me, age from olympics where medal = 'gold' order by age asc limit 10;

-- 14.
select distinct me, weight from olympics where medal = 'gold' order by weight desc limit 10;

-- 15.
select distinct me, weight from olympics where medal = 'gold' order by weight asc limit 10;

-- 16. 
select name, count(*) as total_medals,
sum(case when medal = 'Gold' then 1 else 0 end) AS gold_medals,
sum(case when medal= 'Silver' then 1 else 0 end) AS silver_medals,
sum(CASE when medal= 'Bronze' then 1 else 0 end) AS bronze_medals
from olympics
where medal !="NA"
group by name
order by gold_medals desc, silver_medals desc, bronze_medals desc
limit 10;

-- 17.
select team, count(*) as total_medals,sum(case when medal = 'Gold' then 1 else 0 end) AS gold_medals, sum(case when medal= 'Silver' then 1 else 0 end) AS silver_medals,
sum(CASE when medal= 'Bronze' then 1 else 0 end) AS bronze_medals from olympics where medal !="NA" group by team
order by gold_medals desc, silver_medals desc, bronze_medals desc
limit 10;

-- 18 Find the Top 5 Country Names by their winning % for each year.
SELECT Year, team, ROUND(COUNT(CASE WHEN Medal = 'Gold'or Medal ="Silver" or Medal="Bronze" THEN 1 ELSE 0 END) * 100.0 / COUNT(*) , 2) AS WinningPercentage
FROM olympics GROUP BY Year, team ORDER BY Year, WinningPercentage DESC;