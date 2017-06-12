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
from (
		select IF(SixClose > FifClose,"Increase", "Decrease") as IncDec
		from (
				select Ticker, AP1.Close as FifClose
				from AdjustedPrices AP1
				where Day = '2015-12-30'
				group by Ticker
	  		  ) Fifteen NATURAL JOIN
	  		  (
				select Ticker, AP2.Close as SixClose
				from AdjustedPrices AP2
				where Day = '2016-12-30'
				group by Ticker
			  ) Sixteen
	  ) Changes
where IncDec = "Increase";

-- 2015 - 2016 Decreases
select COUNT(*) as NumDecreases
from (
		select IF(SixClose < FifClose,"Increase", "Decrease") as IncDec
		from (
				select Ticker, AP1.Close as FifClose
				from AdjustedPrices AP1
				where Day = '2015-12-30'
				group by Ticker
	  		  ) Fifteen NATURAL JOIN
	  		  (
				select Ticker, AP2.Close as SixClose
				from AdjustedPrices AP2
				where Day = '2016-12-30'
				group by Ticker
			  ) Sixteen
	  ) Changes
where IncDec = "Increase";

-- Q2

