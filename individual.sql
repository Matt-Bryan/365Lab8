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
