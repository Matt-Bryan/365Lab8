-- Avinash Sharma
-- avsharma
-- CPE 365 Lab 8

-- FSLR and XOM

-- Q1 - Range of dates for which the pricing data is available.
select *
from (select AP.Ticker, MIN(AP.Day) as FirstDay, MAX(AP.Day) as LastDay
from AdjustedPrices AP
where AP.Ticker = 'FSLR') Solar
UNION
select *
from (select AP.Ticker, MIN(AP.Day) as FirstDay, MAX(AP.Day) as LastDay
from AdjustedPrices AP
where AP.Ticker = 'XOM') Exxon;

-- Q2 - Increase/decrease in prices year-over-year (FSLR and XOM)
select YEAR(EndCloses.Day) as Year, EndCloses.Ticker, (EndCloses.Close - StartCloses.Close) as IncDecPrices
from (select AP.Ticker, AP.Day, AP.Close
from AdjustedPrices AP,
(select AP.Ticker, MIN(AP.Day) as Min
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
group by YEAR(AP.Day)) FirstDaysSolar
where AP.Ticker = FirstDaysSolar.Ticker
and AP.Day = FirstDaysSolar.Min) StartCloses,
(select AP.Ticker, AP.Day, AP.Close
from AdjustedPrices AP,
(select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
group by YEAR(AP.Day)) LastDaysSolar
where AP.Ticker = LastDaysSolar.Ticker
and AP.Day = LastDaysSolar.Max) EndCloses
where EndCloses.Ticker = StartCloses.Ticker
group by YEAR(EndCloses.Day);

select YEAR(EndCloses.Day) as Year, EndCloses.Ticker, (EndCloses.Close - StartCloses.Close) as IncDecPrices
from (select AP.Ticker, AP.Day, AP.Close
from AdjustedPrices AP,
(select AP.Ticker, MIN(AP.Day) as Min
from AdjustedPrices AP
where AP.Ticker = 'XOM'
group by YEAR(AP.Day)) FirstDaysSolar
where AP.Ticker = FirstDaysSolar.Ticker
and AP.Day = FirstDaysSolar.Min) StartCloses,
(select AP.Ticker, AP.Day, AP.Close
from AdjustedPrices AP,
(select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where AP.Ticker = 'XOM'
group by YEAR(AP.Day)) FirstDaysSolar
where AP.Ticker = FirstDaysSolar.Ticker
and AP.Day = FirstDaysSolar.Max) EndCloses
where EndCloses.Ticker = StartCloses.Ticker
group by YEAR(EndCloses.Day);

-- Volume of trading each year (FSLR and XOM)
select YEAR(AP.Day) as Year, AP.Ticker, SUM(AP.Volume)
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
group by YEAR(AP.Day);

select YEAR(AP.Day) as Year, AP.Ticker, SUM(AP.Volume)
from AdjustedPrices AP
where AP.Ticker = 'XOM'
group by YEAR(AP.Day);

-- Average closing price in a given year (FSLR and XOM)
select YEAR(AP.Day) as Year, AP.Ticker, ROUND(AVG(AP.Close), 2) as AvgClose
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
group by YEAR(AP.Day);

select YEAR(AP.Day) as Year, AP.Ticker, ROUND(AVG(AP.Close), 2) as AvgClose
from AdjustedPrices AP
where AP.Ticker = 'XOM'
group by YEAR(AP.Day);

-- Average trade volume per day
select YEAR(AP.Day) as Year, AP.Ticker, ROUND(AVG(AP.Volume), 2) as AvgVolume
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
group by YEAR(AP.Day);

select YEAR(AP.Day) as Year, AP.Ticker, ROUND(AVG(AP.Volume), 2) as AvgVolume
from AdjustedPrices AP
where AP.Ticker = 'XOM'
group by YEAR(AP.Day);

-- Q7 - Compare your stock with the top performing stocks (up to five) in 2016.
-- Compare the change in prices month-to-month and the volume of trading.
-- (PCLN, CHTR, AMZN, ISRG, MLM)
select PricelineChanges.Month, PricelineChanges.AbsoluteChange as PCLN, SolarChanges.AbsoluteChange FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as PCLNvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'PCLN'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'PCLN'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month;


select FSLR.Year, FSLR.AvgVolumeFSLR, PCLN.AvgVolumePCLN, FSLR.AvgVolumeFSLR - PCLN.AvgVolumePCLN as FSLRvsPCLNVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumePCLN
from AdjustedPrices AP
where AP.Ticker = 'PCLN'
and YEAR(AP.Day) = 2016) PCLN
where FSLR.Year = PCLN.Year;



select PricelineChanges.Month, PricelineChanges.AbsoluteChange as CHTR, SolarChanges.AbsoluteChange FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as CHTRvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'CHTR'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'CHTR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month;


select FSLR.Year, FSLR.AvgVolumeFSLR, CHTR.AvgVolumeCHTR, FSLR.AvgVolumeFSLR - CHTR.AvgVolumeCHTR as FSLRvsCHTRVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeCHTR
from AdjustedPrices AP
where AP.Ticker = 'CHTR'
and YEAR(AP.Day) = 2016) CHTR
where FSLR.Year = CHTR.Year;


select PricelineChanges.Month, PricelineChanges.AbsoluteChange as AMZN, SolarChanges.AbsoluteChange FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as AMZNvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'AMZN'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'AMZN'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month;

select FSLR.Year, FSLR.AvgVolumeFSLR, AMZN.AvgVolumeAMZN, FSLR.AvgVolumeFSLR - AMZN.AvgVolumeAMZN as FSLRvsAMZNVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeAMZN
from AdjustedPrices AP
where AP.Ticker = 'AMZN'
and YEAR(AP.Day) = 2016) AMZN
where FSLR.Year = AMZN.Year;


select PricelineChanges.Month, PricelineChanges.AbsoluteChange as ISRG, SolarChanges.AbsoluteChange FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as ISRGvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'ISRG'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'ISRG'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month;


select FSLR.Year, FSLR.AvgVolumeFSLR, ISRG.AvgVolumeISRG, FSLR.AvgVolumeFSLR - ISRG.AvgVolumeISRG as FSLRvsISRGVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeISRG
from AdjustedPrices AP
where AP.Ticker = 'ISRG'
and YEAR(AP.Day) = 2016) ISRG
where FSLR.Year = ISRG.Year;


select PricelineChanges.Month, PricelineChanges.AbsoluteChange as MLM, SolarChanges.AbsoluteChange FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as MLMvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'MLM'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'MLM'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month;

select FSLR.Year, FSLR.AvgVolumeFSLR, MLM.AvgVolumeMLM, FSLR.AvgVolumeFSLR - MLM.AvgVolumeMLM as FSLRvsMLMVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeMLM
from AdjustedPrices AP
where AP.Ticker = 'MLM'
and YEAR(AP.Day) = 2016) MLM
where FSLR.Year = MLM.Year;


-- Q8 - Compare your stock with another stock (other stocks) assigned to
-- your team. Determine which stocks is performing better throughout 2016.
select IF (AVG(Vals.CB) > AVG(Vals.FSLR), 'CB > FSLR', 'FSLR > CB') as Results
from (select PricelineChanges.Month, PricelineChanges.AbsoluteChange as CB, SolarChanges.AbsoluteChange as FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as CBvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'CB'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'CB'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month) Vals;

select FSLR.Year, FSLR.AvgVolumeFSLR, CB.AvgVolumeCB, FSLR.AvgVolumeFSLR - CB.AvgVolumeCB as FSLRvsCBVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeCB
from AdjustedPrices AP
where AP.Ticker = 'CB'
and YEAR(AP.Day) = 2016) CB
where FSLR.Year = CB.Year;


select IF (AVG(Vals.WAT) > AVG(Vals.FSLR), 'WAT > FSLR', 'FSLR > WAT') as Results
from (select PricelineChanges.Month, PricelineChanges.AbsoluteChange as WAT, SolarChanges.AbsoluteChange as FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as WATvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'WAT'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'WAT'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month) Vals;

select FSLR.Year, FSLR.AvgVolumeFSLR, WAT.AvgVolumeWAT, FSLR.AvgVolumeFSLR - WAT.AvgVolumeWAT as FSLRvsWATVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeWAT
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and YEAR(AP.Day) = 2016) WAT
where FSLR.Year = WAT.Year;

select IF (AVG(Vals.XOM) > AVG(Vals.FSLR), 'XOM > FSLR', 'FSLR > XOM') as Results
from (select PricelineChanges.Month, PricelineChanges.AbsoluteChange as XOM, SolarChanges.AbsoluteChange as FSLR,
PricelineChanges.AbsoluteChange - SolarChanges.AbsoluteChange as XOMvsFSLRPriceChange
from (select MONTHNAME(SolarMaxCloses.Day) as Month, SolarMaxCloses.Ticker, SolarMaxCloses.Close - SolarMinCloses.Close as AbsoluteChange
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) SolarMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'FSLR'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) SolarMaxCloses
where SolarMaxCloses.Ticker = SolarMinCloses.Ticker
and MONTH(SolarMaxCloses.Day) = MONTH(SolarMinCloses.Min)
group by MONTH(SolarMaxCloses.Day)) SolarChanges, 
(select MONTHNAME(PricelineMaxCloses.Day) as Month, PricelineMaxCloses.Ticker, PricelineMaxCloses.Close - PricelineMinCloses.Close as AbsoluteChange 
from (select AP.Ticker, MIN(AP.Day) as Min, AP.Close
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'XOM'
group by MONTH(AP.Day)) PricelineMinCloses,
(select AP.Ticker, AP.Day, AP.Close
from (select AP.Ticker, MAX(AP.Day) as Max
from AdjustedPrices AP
where YEAR(AP.Day) = 2016
and AP.Ticker = 'XOM'
group by MONTH(AP.Day)) MaxDates, AdjustedPrices AP
where AP.Ticker = MaxDates.Ticker
and MaxDates.Max = AP.Day
group by MONTH(AP.Day)) PricelineMaxCloses
where PricelineMaxCloses.Ticker = PricelineMinCloses.Ticker
and MONTH(PricelineMaxCloses.Day) = MONTH(PricelineMinCloses.Min)
group by MONTH(PricelineMaxCloses.Day)) PricelineChanges
where PricelineChanges.Month = SolarChanges.Month) Vals;

select FSLR.Year, FSLR.AvgVolumeFSLR, XOM.AvgVolumeXOM, FSLR.AvgVolumeFSLR - XOM.AvgVolumeXOM as FSLRvsXOMVolumes
from (select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeFSLR
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and YEAR(AP.Day) = 2016) FSLR,
(select YEAR(AP.Day) as Year, AVG(AP.Volume) as AvgVolumeXOM
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and YEAR(AP.Day) = 2016) XOM
where FSLR.Year = XOM.Year;


