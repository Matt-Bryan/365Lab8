-- Queries for individual securities

-- Q3
select MONTH(Day) as Month, AVG(Close) as AvgClose, MAX(High) as HighestPrice, MIN(Low) as LowestPrice, AVG(Volume) as AvgVolume
from AdjustedPrices AP
where YEAR(Day) = 2016
and Ticker = 'CB'
group by MONTH(Day);

-- Q4
select Year, Month
from (
select T3.Year as Year, MONTHNAME(STR_TO_DATE(T3.Month, '%m')) as Month, MaxChange
from (select Year, MAX(AvgChange) as MaxChange
		from (
				select YEAR(Day) as Year, MONTH(Day) as Month, (MAX(High) - MIN(Low)) as AvgChange
				from AdjustedPrices AP
				where Ticker = 'CB'
				group by Year, Month
				) T1
		group by Year) T2,
		(select YEAR(Day) as Year, MONTH(Day) as Month, (MAX(High) - MIN(Low)) as AvgChange
		from AdjustedPrices AP
		where Ticker = 'CB'
		group by Year, Month) T3
where T2.Year = T3.Year
and T2.MaxChange = T3.AvgChange
group by T3.Year, T3.Month
		) T4
;

-- Q5

-- Decisions made based on current price's proximity to lowest and highest prices of that stock in recent trading

-- Jan 1, 2015

select CASE
WHEN Open >= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.75
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2015-01-02')
				 ) THEN 'Sell'
WHEN Open <= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.25
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2015-01-02')
				 ) THEN 'Buy'
ELSE 'Hold'
END as Decision
from AdjustedPrices AP
where AP.Day = '2015-01-02'
and AP.Ticker = 'CB';

-- June 1, 2015

select CASE
WHEN Open >= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.75
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2015-06-01'
				and AP.Day > '2015-01-02')
				 ) THEN 'Sell'
WHEN Open <= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.25
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2015-06-01'
				and AP.Day > '2015-01-02')
				 ) THEN 'Buy'
ELSE 'Hold'
END as Decision
from AdjustedPrices AP
where AP.Day = '2015-06-01'
and AP.Ticker = 'CB';

-- Oct 1, 2015

select CASE
WHEN Open >= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.75
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2015-10-01'
				and AP.Day > '2015-06-01')
				 ) THEN 'Sell'
WHEN Open <= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.25
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2015-10-01'
				and AP.Day > '2015-06-01')
				 ) THEN 'Buy'
ELSE 'Hold'
END as Decision
from AdjustedPrices AP
where AP.Day = '2015-10-01'
and AP.Ticker = 'CB';

-- Jan 1, 2016

select CASE
WHEN Open >= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.75
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2016-01-04'
				and AP.Day > '2015-10-01')
				 ) THEN 'Sell'
WHEN Open <= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.25
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2016-01-04'
				and AP.Day > '2015-10-01')
				 ) THEN 'Buy'
ELSE 'Hold'
END as Decision
from AdjustedPrices AP
where AP.Day = '2016-01-04'
and AP.Ticker = 'CB';

-- May 1, 2016

select CASE
WHEN Open >= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.75
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2016-05-02'
				and AP.Day > '2016-01-04')
				 ) THEN 'Sell'
WHEN Open <= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.25
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2016-05-02'
				and AP.Day > '2016-01-04')
				) THEN 'Buy'
ELSE 'Hold'
END as Decision
from AdjustedPrices AP
where AP.Day = '2016-05-02'
and AP.Ticker = 'CB';

-- Oct 1, 2016

select CASE
WHEN Open >= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.75
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2016-10-03'
				and AP.Day > '2016-05-02')
				 ) THEN 'Sell'
WHEN Open <= (
				(select MIN(Low) + (MAX(High) - MIN(Low)) * 0.25
				from AdjustedPrices AP
				where AP.Ticker = 'CB'
				and AP.Day < '2016-10-03'
				and AP.Day > '2016-05-02')
				) THEN 'Buy'
ELSE 'Hold'
END as Decision
from AdjustedPrices AP
where AP.Day = '2016-10-03'
and AP.Ticker = 'CB';

-- Q6

-- Jan 1, 2015

select CASE
WHEN Close < (
					select Open - Open * 0.15
					from AdjustedPrices AP
					where AP.Ticker = 'CB'
					and AP.Day = '2015-01-01'
				 ) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-06-01'
and AP.Ticker = 'CB';

-- Jun 1, 2015

select CASE
WHEN Close > (
					select Open + Open * 0.15
					from AdjustedPrices AP
					where AP.Ticker = 'CB'
					and AP.Day = '2015-06-01'
				 ) THEN 'Buy was correct'
ELSE 'Buy was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-10-02'
and AP.Ticker = 'CB';

-- Oct 1, 2015

select CASE
WHEN Close < (
					select Open + Open * 0.15
					from AdjustedPrices AP
					where AP.Ticker = 'CB'
					and AP.Day = '2015-10-02'
				 )
				 AND
				 Close > (
							select Open - Open * 0.15
							from AdjustedPrices AP
							where AP.Ticker = 'CB'
							and AP.Day = '2015-10-02'
							)
				THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-01-04'
and AP.Ticker = 'CB';

-- Jan 1, 2016

select CASE
WHEN Close < (
					select Open - Open * 0.15
					from AdjustedPrices AP
					where AP.Ticker = 'CB'
					and AP.Day = '2016-01-04'
				 ) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-05-02'
and AP.Ticker = 'CB';

-- May 1, 2016

select CASE
WHEN Close < (
					select Open + Open * 0.15
					from AdjustedPrices AP
					where AP.Ticker = 'CB'
					and AP.Day = '2015-05-02'
				 )
				 AND
				 Close > (
							select Open - Open * 0.15
							from AdjustedPrices AP
							where AP.Ticker = 'CB'
							and AP.Day = '2015-05-02'
							)
				THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-10-03'
and AP.Ticker = 'CB';

-- Oct 1, 2016

select CASE
WHEN Close < (
					select Open + Open * 0.15
					from AdjustedPrices AP
					where AP.Ticker = 'CB'
					and AP.Day = '2015-10-03'
				 )
				 AND
				 Close > (
							select Open - Open * 0.15
							from AdjustedPrices AP
							where AP.Ticker = 'CB'
							and AP.Day = '2015-10-03'
							)
				THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-12-30'
and AP.Ticker = 'CB';
