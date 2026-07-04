Create Database Bank;

Use bank;

Create Table bank_raw (
	age int,
	job varchar(60),
	marital varchar(50),
	education varchar(50),
	`default` varchar(50),
	balance int,
	housing varchar(50),
	loan varchar(50),
	contact varchar(50),
	day int,
	month varchar(50), 
	duration int,
	campaign int,
    pdays int,
    previous int,
    poutcome varchar(50),
    deposit varchar(40)
    );

Show variables like 'secure_file_priv';

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank.csv'
into table bank_raw
Fields Terminated by ','
Enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(age, job, marital, education, `default`, balance, housing, loan, contact, day, month, duration, campaign, pdays,	previous, poutcome,	deposit);

Select 
count(*) from bank_raw;

SELECT * FROM bank.bank_raw;


------------------------------ Data Cleaning Section----------------------------------

---------- Duplicating the dataset from the raw dataset for the purpose of analysis.

SELECT * FROM bank.bank_raw; 

create table bank_2
like bank.bank_raw;

Select * from bank_2;


insert bank_2
select *
from  bank.bank_raw;

Select * from bank_2;

 --------- 1. Checking for null values per columns
 
 SELECT 
    SUM(CASE WHEN age IS NULL OR age = '' THEN 1 ELSE 0 END) AS age_missing,
    SUM(CASE WHEN job IS NULL OR job = '' THEN 1 ELSE 0 END) as job_missing,
    SUM(CASE WHEN marital IS NULL OR marital = '' THEN 1 ELSE 0 END) as marital_missing,
    SUM(CASE WHEN education IS NULL OR education = '' THEN 1 ELSE 0 END) as education_missing,
    SUM(CASE WHEN `default` IS NULL OR `default` = '' THEN 1 ELSE 0 END) as default_missing,
    SUM(CASE WHEN balance IS NULL OR balance = '' THEN 1 ELSE 0 END) as balance_missing,
    SUM(CASE WHEN housing IS NULL OR housing = '' THEN 1 ELSE 0 END) as housing_missing,
    SUM(CASE WHEN loan IS NULL OR loan = '' THEN 1 ELSE 0 END) as loan_missing,
    SUM(CASE WHEN contact IS NULL OR contact = '' THEN 1 ELSE 0 END) as contact_missing,
    SUM(CASE WHEN day IS NULL OR day = '' THEN 1 ELSE 0 END) as day_missing,
    SUM(CASE WHEN month IS NULL OR month = '' THEN 1 ELSE 0 END) as month__missing,
    SUM(CASE WHEN duration IS NULL OR duration = '' THEN 1 ELSE 0 END) as duration_missing,
    SUM(CASE WHEN campaign IS NULL OR campaign = '' THEN 1 ELSE 0 END) as campiagn_missing,
    SUM(CASE WHEN pdays IS NULL OR pdays = '' THEN 1 ELSE 0 END) as pdays_missing,
    SUM(CASE WHEN previous IS NULL OR previous = '' THEN 1 ELSE 0 END) as previous_missing,
    SUM(CASE WHEN poutcome IS NULL OR poutcome = '' THEN 1 ELSE 0 END) as poutcome_missing,
    SUM(CASE WHEN deposit IS NULL OR deposit = '' THEN 1 ELSE 0 END) as deposit_missing
FROM bank_2;


---------  Perform Data Exploration and Analysis

---- Rows Count
Select count(*) as total_row from bank_2;

--- Data type/Description
Desc  bank_2;

----- Summary statistics (Numeric Columns)
Select 
	Min(age) as Min_age, Max(age) as Max_age, Round(avg(age), 1) as avg_age,
    Min(balance) as Min_balance, Max(age) as Max_balance, Round(avg(balance), 1) as avg_balance,
    Min(duration) as Min_duration, Max(duration) as Max_duration, Round(avg(duration), 1) as avg_duration,
	Min(campaign) as Min_compaign, Max(campaign) as Max_compaign, Round(avg(campaign), 1) as avg_compaign
    from bank_2;
    
 ------ Distribution of important variables (Deposit)
 Select 
	deposit, count(*) as total_count, round(count(*) * 100 / (select count(*) from bank_2), 1) as percentage
    from bank_2
    group by deposit;
    
-------- Subscription Rate by Job Type
Select
	job, count(*) as total,
    sum(case when deposit = 'yes' then 1 else 0 end) as subscribed,
    round(sum(case when deposit = 'yes' then 1 else 0 end) * 100/ count(*), 1) as subscription_rate
    from bank_2
    group by job
    order by subscription_rate desc;
    
 --------  Subscription Rate by Education Level
Select
		education, count(*) as total,
    sum(case when deposit = 'yes' then 1 else 0 end) as subscribed,
    round(sum(case when deposit = 'yes' then 1 else 0 end) * 100/ count(*), 1) as subscription_rate
    from bank_2
    group by education
    order by subscription_rate desc;
    
---------- Subscription Rate by Contact
select
	contact, count(*) as total,
    sum(case when deposit = 'yes' then 1 else 0 end) as subscribed,
    round(sum(case when deposit = 'yes' then 1 else 0 end) * 100/ count(*), 1) as subscription_rate
    from bank_2
    group by contact
    order by subscription_rate desc;
    
------ Subscription Rate by Age Group
select
	Case 
		when age < 30 then 'Under 30'
        when age between 31 and 39 then '31-39'
        when age between 41 and 49 then '41-49'
        when age between 51 and 50 then 51-59
        else '60 and above'
        end as age_group,
		count(*) as total,
		sum(case when deposit = 'yes' then 1 else 0 end) as subscribed,
		round(sum(case when deposit = 'yes' then 1 else 0 end) * 100/ count(*), 1) as subscription_rate
		from bank_2
		group by age_group
		order by subscription_rate desc;
        
--------- Subscription Rate by Marital Status
select
	marital, count(*) as total,
    sum(case when deposit = 'yes' then 1 else 0 end) as subscribed,
    round(sum(case when deposit = 'yes' then 1 else 0 end) * 100/ count(*), 1) as subscription_rate
    from bank_2
    group by marital
    order by subscription_rate desc;
    
    
    Alter Table bank_2 Add column Contracted_before varchar(10);
    
    
    Set Sql_safe_updates = 0;
    
    Update bank_2
    Set Contracted_before = CASE
		When pdays = -1 Then 'No'
        Else 'Yes'
        End;
        
	Select Contracted_before, count(*) AS Total from bank_2
    Group by  Contracted_before;
    
    Select * from bank_2;
    

 
 
 




 


