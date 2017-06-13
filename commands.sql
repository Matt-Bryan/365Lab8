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
from (select Sixteen.Ticker, IF(Sixteen.SixClose > Fifteen.FifClose, 'Increase', 'Decrease') as IncDec
from (select AP.Ticker, AP.Close as FifClose
from AdjustedPrices AP
where AP.Day = (select MAX(AP.Day) AS Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2015)) Fifteen, 
(select AP.Ticker, AP.Close as SixClose
from AdjustedPrices AP
where AP.Day = (select MAX(AP.Day) AS Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016)) Sixteen
where Fifteen.Ticker = Sixteen.Ticker) Changes
where Changes.IncDec = 'Increase';

-- 2015 - 2016 Decreases
select COUNT(*) as NumDecreases
from (select Sixteen.Ticker, IF(Sixteen.SixClose < Fifteen.FifClose, 'Decrease', 'Increase') as IncDec
from (select AP.Ticker, AP.Close as FifClose
from AdjustedPrices AP
where AP.Day = (select MAX(AP.Day) AS Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2015)) Fifteen, 
(select AP.Ticker, AP.Close as SixClose
from AdjustedPrices AP
where AP.Day = (select MAX(AP.Day) AS Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016)) Sixteen
where Fifteen.Ticker = Sixteen.Ticker) Changes
where Changes.IncDec = 'Decrease';

-- Q2 - Report top 10 stocks most heavily traded in 2016.
select distinct S.Name, AP.Ticker
from AdjustedPrices AP, Securities S
where AP.Ticker = S.Ticker 
and YEAR(AP.Day) = 2016
order by AP.Volume desc
limit 10;

-- Q3 - For each year, report the top 5 highest performing stocks in terms
-- of the absolute price increase and top 5 highest performing stocks in
-- terms of relative price increase.
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2010-01-04') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2010-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y1
UNION
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2011-01-03') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2011-12-30') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y2
UNION
select * 
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2012-01-03') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2012-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y3
UNION
select * 
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2013-01-02') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2013-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y4
UNION
select * 
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2014-01-02') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2014-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y5
UNION
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2015-01-02') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2015-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y6
UNION
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2016-01-04') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2016-12-30') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by AbsolutePrice desc
limit 5) as Y7;

-- Relative price increases 
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2010-01-04') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2010-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y1
UNION
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2011-01-03') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2011-12-30') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y2
UNION
select * 
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2012-01-03') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2012-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y3
UNION
select * 
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2013-01-02') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2013-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y4
UNION
select * 
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2014-01-02') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2014-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y5
UNION
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2015-01-02') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2015-12-31') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y6
UNION
select *
from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice
from (select AP.Day, AP.Ticker, AP.Open
from AdjustedPrices AP
where AP.Day = '2016-01-04') FirstDay,
(select AP.Day, AP.Ticker, AP.Close
from AdjustedPrices AP
where AP.Day = '2016-12-30') LastDay
where FirstDay.Ticker = LastDay.Ticker
order by RelativePrice desc
limit 5) as Y7;

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

-- Q5 - Provide general assessment of performance of different sectors of
-- stock market (11 sectors total), you can ignore Telecommunications
-- Services) in 2016. Tanking (negative), Average (0-0.1), Above Average (0.1-0.2), Significantly Outperforming (> 0.2)
select Percentages.Sector, CASE WHEN Percentages.Percentage < 0.0 THEN 'Tanking'
WHEN Percentages.Percentage >= 0.0 and Percentages.Percentage < 0.1 THEN 'Average'
WHEN Percentages.Percentage >= 0.1 and Percentages.Percentage < 0.2 THEN 'Above Average'
ELSE  'Significantly Outperforming' END AS Performance
from (select LastAvgs.Sector, (LastAvgs.AvgLastDayClose - FirstAvgs.AvgFirstDayClose) / FirstAvgs.AvgFirstDayClose as Percentage
from (select S.Sector, AVG(AP.Close) as AvgFirstDayClose
from AdjustedPrices AP, Securities S
where AP.Ticker = S.Ticker
and AP.Day = (select MIN(AP.Day) as FirstDay
from AdjustedPrices AP
where YEAR(AP.Day) = 2016)
and S.Sector <> 'Telecommunications Services'
group by S.Sector) FirstAvgs,
(select S.Sector, AVG(AP.Close) as AvgLastDayClose
from AdjustedPrices AP, Securities S
where AP.Ticker = S.Ticker
and AP.Day = (select MAX(AP.Day) as LastDay
from AdjustedPrices AP
where YEAR(AP.Day) = 2016)
and S.Sector <> 'Telecommunications Services'
group by S.Sector) LastAvgs
where FirstAvgs.Sector = LastAvgs.Sector) Percentages;


-- Queries for individual securities

-- Q3
select MONTH(Day) as Month, AVG(Close) as AvgClose, MAX(High) as HighestPrice, MIN(Low) as LowestPrice, AVG(Volume) as AvgVolume
from AdjustedPrices AP
where YEAR(Day) = 2016
and Ticker = 'CB'
group by MONTH(Day);

-- Q4
select Month
from (
		select MONTH(Day) as Month, SOMETHING HERE
		from AdjustedPrices AP
		where Ticker = 'CB'
		group by MONTH(Day)
	  ) MonthPerformances
group by Month
having SOMETHING HERE = MAX(SOMETHING HERE);
