######################### Questions On Electoral Bonds ############################
use electoralbonddata;
select *
from donordata;
select *
from bonddata;
select *
from bankdata;
select *
from receiverdata;
 -- 1. Find out how much donors spent on bonds
 SELECT sum(denomination) 
 FROM bonddata b 
 JOIN donordata d 
 ON b.Unique_key=d.Unique_key;

 -- 2. Find out total fund politicians got
 select sum(denomination)
 from bonddata b
 join receiverdata r
 on b.Unique_key=r.Unique_key;
 
 -- 3. Find out the total amount of unaccounted money received by parties
 select sum(denomination)
 from donordata d
 right join receiverdata r ON d.Unique_key=r.Unique_key
 join bonddata b ON b.Unique_key=r.Unique_key
 where PurchaseDate is null;
 
 --  4. Find year wise how much money is spend on bonds
 select year(PurchaseDate),sum(denomination)
 from bonddata b
join donordata d 
 ON b.Unique_key=d.Unique_key
 group by 1;

 -- 5. In which month most amount is spent on bonds
 select month(PurchaseDate),sum(denomination)
 from bonddata b
join donordata d 
on b.Unique_key=d.Unique_key
group by 1; 
 --  6. Find out which company bought the highest number of bonds.
 with highest_bonds as (
 select d.Purchaser,count(purchaser) as counts
 from bonddata b
 join donordata d 
 on b.Unique_key=d.Unique_key
 group by 1
 order by 2 desc)
 select purchaser from highest_bonds
 where counts=(select max(counts) from highest_bonds);
 --  7. Find out which company spent the most on electoral bonds.
 with most_on_bonds as(
 select purchaser, sum(denomination) as sum_
 from donordata as d
 join bonddata b on d.unique_key=b.unique_key
 group by 1
 order by 2 desc)
 select purchaser,sum_ from most_on_bonds
 where sum_=(select max(sum_)from most_on_bonds);
 
-- 8. List companies which paid the least to political parties.
with least_paid as (
select purchaser,sum(denomination) as least_amount from donordata d join bonddata b on d.unique_key = b.unique_key 
group by 1 )
select purchaser,least_amount from least_paid where least_amount=(select min(least_amount) from least_paid);

 -- 9. Which political party received the highest cash?
 with highest_cash as (
 select partyname,sum(denomination) as max_cash from bonddata as b
 join receiverdata r on b.unique_key = r.unique_key
 group by 1)
 select partyname,max_cash from highest_cash
 where max_cash =(select max(max_cash) from highest_cash);
 
 -- 10. Which political party received the highest number of electoral bonds?
 select partyname,count(b.unique_key) as highest
 from receiverdata as r
 join bonddata as b on r.unique_key = b.unique_key
 group by 1
 order by 2 desc
 limit 1;
 -- USEING THE CTE 
 with highest_bonds as (
 select partyname,count(b.unique_key) as highest_
 from receiverdata as r
 join bonddata as b on r.unique_key = b.unique_key
 group by 1
 )
 select partyname ,highest_ from highest_bonds
 order by 2 desc
 limit 1;
 -- 11. Which political party received the least cash?
 with leastcash as (
 select partyname,min(denomination) as least_
 from receiverdata as r join bonddata as b
 on r.unique_key = b.unique_key
 group by 1
 )
 select partyname, least_ from leastcash
 order by 2 
 limit 1
 offset 0;
 
 -- 12. Which political party received the least number of electoral bonds?
 with leastbonds as(
 select partyname, count(b.unique_key) as count_
 from receiverdata as r 
 join bonddata as b on r.unique_key = b.unique_key
 group by 1
 )
 select partyname,count_
 from leastbonds 
 order by 2
 limit 1;
 -- with out using CTE and bonddata 
 select partyname, count(unique_key) as count_
 from receiverdata
 group by 1
 order by 2;
 
 -- 13. Find the 2nd highest donor in terms of amount he paid?
 with 2nd_highest as (
 select purchaser,sum(denomination) as count_
 from donordata as d
 join bonddata as b on d.unique_key = b.unique_key
 group by 1
 )
 select purchaser,count_
 from 2nd_highest
 order by 2 desc
limit 1
offset 2;
 
 
 -- 14. Find the party which received the second highest donations?
 with second_highest as (
 select partyname ,sum(denomination) as recived_
 from receiverdata as r
 join bonddata as b on r.unique_key = b.unique_key
 group by 1
 )
 select partyname, recived_
 from second_highest
 order by 2 desc
 limit 1
 offset 1;
 
 -- 15. Find the party which received the second highest number of bonds?
 with party_bonds as (
 select partyname, count(unique_key) as sum_bonds
 from receiverdata 
 group by 1
 order by 2 desc
 )
 select partyname,sum_bonds
 from party_bonds
 where sum_bonds < (select max(sum_bonds) from party_bonds)
 limit 1;
 
 -- 16. In which city were the most number of bonds purchased?
 with most_bonds as (
 select state,count(unique_key) as most_number
 from bankdata as b
 join donordata as d on b.branchCodeNo = d.payBranchCode
 group by 1
 )
 select state,most_number
 from most_bonds
 order by 2 desc;
 
 
 -- 17. In which city was the highest amount spent on electoral bonds?
 with spent_amount as (
 select state,sum(denomination) as max_bonds
 from bankdata as b
 join receiverdata as r on b.branchCodeNo = r.payBranchCode
 join bonddata as bo  on r.unique_key = bo.unique_key
 group by 1
 )
 select state,max_bonds
 from spent_amount
 order by 2 desc;
 
 
 -- 18. In which city were the least number of bonds purchased?
 with least_bonds as(
 select state,count(purchaser) as least_number
 from bankdata as b
 join donordata as d on b.branchCodeNo = d.payBranchCode
 group by 1
 )
 select state,least_number
 from least_bonds
 order by 2 asc;
 
 
 -- 19. In which city were the most number of bonds enchased?
 with most_bonds as (
 select state,count(unique_key) as count_
 from bankdata as b
 join donordata as d
 on b.branchCodeNo = d.payBranchCode
 group by 1
 )
 select state,count_
 from most_bonds
 order by 2 desc;
 
 -- 20. In which city were the least number of bonds enchased?
 with least_number as (
 select state,count(unique_key) as count_
 from bankdata as b
 join donordata as d on  b.branchCodeNo = d.payBranchCode
 group by 1
 )
 select state,count_
 from least_number
 order by 2
 limit 1;
 
 -- 21. List the branches where no electoral bonds were bought; if none, mention it as null.
 with bonds_bought as (
 select branchCodeNo,purchaser
 from bankdata as b
 left join donordata as d on d.payBranchCode = b.branchCodeNo
 where Unique_key is null
 )
 select branchCodeNo,purchaser
 from bonds_bought;
 
 -- 22. Break down how much money is spent on electoral bonds for each year.
with each_year_money as (  select year(purchasedate) as year,sum(denomination) as count_
  from donordata as d
  join bonddata as b  on d.unique_key = b.unique_key
  group by 1
  )
  select year,count_
  from each_year_money
  order by 2;
  
-- ####### with ouight cte ##########

select year(PurchaseDate) as year_data,sum(b.Denomination) as amount
from  donordata as d
 join bonddata as b
 on d.unique_key = b.unique_key
 group by year(PurchaseDate)
 limit 5;
 
 
 /* 23. Break down how much money is spent on electoral bonds for each year and provide the year and the amount. Provide values
 for the highest and least year and amount.*/
 with each_year_money as (  select year(purchasedate) as year,sum(denomination) as count_
  from donordata as d
  join bonddata as b  on d.unique_key = b.unique_key
  group by 1
  )
  select year,count_
  from each_year_money
  where count_ = (select max(count_) from  each_year_money)
  or count_ = (select min(count_) from  each_year_money)
  order by 2;
  
-- 24. Find out how many donors bought the bonds but did not donate to any political party?
with donors_bought as (
select partyname,count(r.unique_key) as bought_
from receiverdata as r
left join donordata as d 
on r.unique_key = d.unique_key
group by 1
)
select partyname,bought_
 from donors_bought
 order by 2;

-- 25. Find out the money that could have gone to the PM Office, assuming the above question assumption (Domain Knowledge)
with money_pm as (
select partyname , sum(Denomination) as money_
from receiverdata as r
left join bonddata as b on r.unique_key = b.unique_key
group by 1 )
select  partyname , money_
from money_pm
order by 2;

-- ######### with out cte ############ 
 
 select partyname , sum(Denomination)
 from receiverdata r
 left join bonddata b
 on r.Unique_key = b.Unique_key
 group by partyname
 order by partyname desc;
 
 
  with pm as (select partyname , sum(Denomination) 
 from receiverdata r
 left join bonddata b
 on r.Unique_key = b.Unique_key
 group by partyname)
 select * from pm
 order by partyname desc;
 
-- 26. Find out how many bonds don't have donors associated with them.
with bonds_donors as (
select  count(*) as bonds_
from bonddata as b
left join donordata as d on b.unique_key = d.unique_key
where d.unique_key IS NULL 
)
select bonds_
from bonds_donors;

--######### with ouight cte ###########

SELECT COUNT(*) AS bonds_
FROM bonddata AS b
LEFT JOIN donordata AS d ON b.unique_key = d.unique_key
WHERE d.unique_key IS NULL;
/* 27. Pay Teller is the employee ID who either created the bond or redeemed it. So find the employee ID who issued the highest
 number of bonds.*/
 select payTeller,count(denomination) as bonds_
 from receiverdata as r
 join bonddata b on r.unique_key = b.unique_key
 group by 1
 order by 2 desc
 limit 1;
 
 -- 28. Find the employee ID who issued the least number of bonds.
 select payTeller,count(denomination) as bonds_
 from receiverdata as r
 join bonddata b on r.unique_key = b.unique_key
 group by 1
 order by 2 asc
 limit 1;
 -- 29. Find the employee ID who assisted in redeeming or enchasing bonds the most.
 select payteller, count(unique_key) as enchasing from receiverdata
group by payteller
order by enchasing desc;
 
 
-- 30. Find the employee ID who assisted in redeeming or enchasing bonds the least

select payteller, count(unique_key) as enchasing from receiverdata
group by payteller
order by enchasing asc;

/* ########Some more Questions you can try answering Once you are done with
 above questions.################*/
 
  -- 1. Tell me total how many bonds are created?
  select  sum(Denomination) as total
  from bonddata as b;

-- 2. Find the count of Unique Denominations provided by SBI?

select count(distinct(denomination)) as provided
from bonddata;


-- 3. List all the unique denominations that are available?

select distinct(denomination) as provided
from bonddata;

-- 4. Total money received by the bank for selling bonds

select sum(denomination) as received
from bonddata;


 -- 5. Find the count of bonds for each denominations that are created.
 select denomination , count(*) as count
 from bonddata
 group by 1;
 
 -- 6. Find the count and Amount or Valuation of electoral bonds for each denominations.
 
 select count(denomination) 
 from bonddata;
 
 
 -- 7. Number of unique bank branches where we can buy electoral bond?
 
 select count(distinct (branchCodeNo)) as uniqu
 from bankdata;
 

-- 8. How many companies bought electoral bonds
select count(distinct(purchaser)) as bought
from donordata;

-- 9. How many companies made political donations

select count(purchaser) as companies
from donordata;

-- 10. How many number of parties received donations
select purchaser,count(partyName) as received
from donordata as d
group by 1
order by 2;

-- 11. List all the political parties that received donations
select distinct partyName
from receiverdata;

 -- 12. What is the average amount that each political party received
 select partyName,avg(denomination) as avg_amount
 from receiverdata as r
 join bonddata as b on r.unique_key = b.unique_key
 group by 1
 order by 2 desc;
 
 
-- 13. What is the average bond value produced by bank
select state , avg(denomination) as average_value
from bankdata as b
join donordata  as d on b. branchCodeNo = d.payBranchCode 
join bonddata as bo on d.unique_key = bo.unique_key
group by 1
order by 2 desc;

 -- 14. List the political parties which have enchased bonds in different cities?
 select partyName , count(city) as cities_name
 from receiverdata as r
 join bankdata as b on r.payBranchCode = b.branchCodeNo
 group by 1
 order by 2;
 
 /*15. List the political parties which have enchased bonds in different cities and list the cities in which the bonds have enchased
 as well?*/
  select partyName , count(city) as cities_name
 from receiverdata as r
 join bankdata as b on r.payBranchCode = b.branchCodeNo
 group by 1
 order by 2 desc
 limit 1;
 
  /* Multiple Articles about the project are written in the following git pages 
website . They may come in handy */



/*
##################The summary of project on electoral bonds the mentioned SQL ################################

1.Investigated electoral bonds, pivotal in political financing, using advanced SQL techniques.
2.Employed Common Table Expressions (CTEs) for creating temporary result sets, enhancing query readability.
3.Leveraged subqueries to nest queries, enabling dynamic data retrieval based on prior results.
4.Utilized right joins to combine data from two tables, ensuring inclusion of all records from the right table.
5.Applied left joins to merge records from two tables, including all records from the left table.
6.Conducted multi-table joins to integrate data from multiple sources, facilitating comprehensive analysis of electoral bond trends and patterns.
*/