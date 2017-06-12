-- SQL commands

-- Q1

-- Total securities traded at start of 2016
select COUNT(Ticker) as NumSecurities
from AdjustedPrices
where Day = '2016-01-04';

-- Total securities traded at end of 2016
select COUNT(Ticker) as NumSecurities
from AdjustedPrices
where Day = '2016-12-30';

-- 2015 - 2016 Increases
select COUNT(*) as NumIncreases
from (select IF(SixClose > FifClose,"Increase", "Decrease") as IncDec
from (select Ticker, AP1.Close as FifClose
from AdjustedPrices AP1
where Day = '2015-12-31'
group by Ticker
) Fifteen NATURAL JOIN
(select Ticker, AP2.Close as SixClose
from AdjustedPrices AP2
where Day = '2016-12-30'
group by Ticker
) Sixteen
) Changes
where IncDec = "Increase";

-- 2015 - 2016 Decreases
select COUNT(*) as NumDecreases
from (select IF(SixClose < FifClose,"Decrease", "Increase") as IncDec
from (select Ticker, AP1.Close as FifClose
from AdjustedPrices AP1
where Day = '2015-12-31'
group by Ticker
) Fifteen NATURAL JOIN
(select Ticker, AP2.Close as SixClose
from AdjustedPrices AP2
where Day = '2016-12-30'
group by Ticker
) Sixteen
) Changes
where IncDec = "Decrease";

-- Q2 - Report top 10 stocks most heavily traded in 2016.
select distinct S.Name, AP.Ticker
from AdjustedPrices AP, Securities S
where AP.Ticker = S.Ticker 
and YEAR(AP.Day) = 2016
order by AP.Volume desc
limit 10;

-- Q3 - For each year, report the top 5 highest performing stocks in terms
-- of the absolute price increase and top 5 higheest performing stocks in
-- terms of relative price increase.





-- Q4 - Select 10 stocks to watch in 2017 based on stock market performance
-- in 2016. Get top 10 highest average closes of distinct stocks in 2016.
select Averages.Name, Averages.Ticker, Averages.Avg
from (select S.Name, AP.Ticker, AVG(AP.Close) as Avg
from AdjustedPrices AP, Securities S
where AP.Ticker = S.Ticker
and YEAR(AP.Day) = 2016
group by AP.Ticker) Averages
order by Averages.Avg desc
limit 10;


-- Q5 - 

