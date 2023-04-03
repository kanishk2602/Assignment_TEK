-- 1.
create database if not exists hremployeeDB;
show databases;
use hremployeeDB;
 create table if not exists HR_Empoyee (
 EmployeeID int, Department varchar(50), JobRole varchar(50), Attrition varchar(50),
 Gender varchar(50),Age int, MaritalStatus varchar(50),	Education varchar(50),
 EducationField varchar(50), BusinessTravel varchar(50), JobInvolvement varchar(50),
 JobLevel int,	JobSatisfaction varchar(50), Hourlyrate int, Income varchar(50),
 Salaryhike int, OverTime int, Workex int, YearsSinceLastPromotion int,	EmpSatisfaction varchar(50),
 TrainingTimesLastYear int,	WorkLifeBalance varchar(50), Performance_Rating varchar(50)
 );
 SET GLOBAL local_infile = TRUE;

LOAD  DATA LOCAL INFILE 'D:/SQL data/HR_Employee.csv'
into table HR_Employee
fields terminated by ','  -- delimiter of columns
lines terminated by '\n'
ignore 1 lines;  -- lines seperated by '\n' or '\r\n'

 desc HR_Employee;
 select * from HR_Employee;
 
 -- 2.
 select count(column_name) as shape
 from information_schema.columns where 
 table_name = 'HR_Employee' 
 union
 select count(*) as rownum from HR_Employee;
 
 -- 3.
 select department, count(*) as dept from HR_Employee group by department order by dept;
 
 -- 4.
 select count(*),gender,department from  HR_Employee group by department,gender order by department;
 -- 5. 
 select jobrole, count(*) as jr from HR_Employee group by jobrole;
 
 -- 6. 
 select age, count(age) as age_group from HR_Employee group by age order by age;
 
 -- 7. 
 select maritalstatus, COUNT(maritalstatus) AS MOST_FREQUENT from HR_Employee GROUP BY maritalstatus;
 
 -- 8.
  select JobSatisfaction, COUNT(JobSatisfaction) AS job_sats from HR_Employee GROUP BY JobSatisfaction ;
  
  -- 9. 
   select BusinessTravel, COUNT(BusinessTravel) AS travel from HR_Employee GROUP BY BusinessTravel 
  order by BusinessTravel;
  
  -- 10.
select department,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by department order by percentage desc;

  -- 11. 
  select jobrole,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by jobrole order by percentage desc;

-- 12.
SELECT CASE WHEN YearsSinceLastPromotion >= 2 AND joblevel <= 2 THEN 'high chances'
WHEN YearsSinceLastPromotion >= 5 AND joblevel <= 5 THEN 'medium chances'
ELSE 'low chances'
END AS promotion_chances,
COUNT(*) AS num_employees,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM hr_employee) * 100, 2) AS promotion_rate
FROM hr_employee
GROUP BY promotion_chances
ORDER BY num_employees DESC;

-- 13. 
 select maritalstatus,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by maritalstatus order by percentage desc;

-- 14. 
 select education,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by education order by percentage desc;

-- 15. 
 select BusinessTravel,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by BusinessTravel order by percentage desc;

-- 16.  
 select JobInvolvement,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by JobInvolvement order by percentage desc;

-- 17. 
 select JobSatisfaction,count(attrition),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as count_attrition,
(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100
 as percentage from hr_employee group by JobSatisfaction order by percentage desc;
 
 -- 18.
 select employeeid,department, jobrole 
 from hr_employee where attrition = 'yes' and BusinessTravel = 'Travel_Frequently'and JobInvolvement = 'medium'
 and JobSatisfaction = 'Low' and  WorkLifeBalance ='better' ;
 
 -- 19. 
select * from hr_employee where workex > 10 and BusinessTravel = 'Travel_Frequently' and
WorkLifeBalance ="Good" and jobsatisfaction="Very High";

-- 20.  
select worklifebalance, MaritalStatus, Performance_Rating, count(*) as result from hr_employee
where Performance_Rating = 'outstanding' group by worklifebalance,maritalstatus,performance_rating;