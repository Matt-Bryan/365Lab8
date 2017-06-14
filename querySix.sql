-- Q6

-- WAT

-- Jan 1, 2015

select CASE
WHEN Close < (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2015-01-01'
) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-06-01'
and AP.Ticker = 'WAT';

-- Jun 1, 2015

select CASE
WHEN Close < (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2015-06-01'
) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-10-02'
and AP.Ticker = 'WAT';

-- Oct 1, 2015

select CASE
WHEN Close > (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2015-10-02'
) THEN 'Buy was correct'
ELSE 'Buy was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-01-04'
and AP.Ticker = 'WAT';

-- Jan 1, 2016

select CASE
WHEN Close < (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2016-01-04'
) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-05-02'
and AP.Ticker = 'WAT';

-- May 1, 2016

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2016-05-02'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2016-05-02'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-10-03'
and AP.Ticker = 'WAT';

-- Oct 1, 2016

select CASE
WHEN Close < (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'WAT'
and AP.Day = '2016-10-03'
) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-12-30'
and AP.Ticker = 'WAT';

-- FSLR

-- Jan 1, 2015

select CASE
WHEN Close > (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2015-01-01'
) THEN 'Buy was correct'
ELSE 'Buy was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-06-01'
and AP.Ticker = 'FSLR';

-- Jun 1, 2015

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2015-06-01'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2015-06-01'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-10-02'
and AP.Ticker = 'FSLR';

-- Oct 1, 2015

select CASE
WHEN Close > (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2015-10-02'
) THEN 'Buy was correct'
ELSE 'Buy was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-01-04'
and AP.Ticker = 'FSLR';

-- Jan 1, 2016

select CASE
WHEN Close < (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2016-01-04'
) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-05-02'
and AP.Ticker = 'FSLR';

-- May 1, 2016

select CASE
WHEN Close > (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2016-05-02'
) THEN 'Buy was correct'
ELSE 'Buy was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-10-03'
and AP.Ticker = 'FSLR';

-- Oct 1, 2016

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2016-10-03'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'FSLR'
and AP.Day = '2016-10-03'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-12-30'
and AP.Ticker = 'FSLR';

-- XOM

-- Jan 1, 2015

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2015-01-01'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2015-01-01'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-06-01'
and AP.Ticker = 'XOM';

-- Jun 1, 2015

select CASE
WHEN Close > (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2015-06-01'
) THEN 'Buy was correct'
ELSE 'Buy was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2015-10-02'
and AP.Ticker = 'XOM';

-- Oct 1, 2015

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2015-10-02'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2015-10-02'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-01-04'
and AP.Ticker = 'XOM';

-- Jan 1, 2016

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2016-01-04'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2016-01-04'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-05-02'
and AP.Ticker = 'XOM';

-- May 1, 2016

select CASE
WHEN Close < (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2016-05-02'
) THEN 'Sell was correct'
ELSE 'Sell was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-10-03'
and AP.Ticker = 'XOM';

-- Oct 1, 2016

select CASE
WHEN Close < (
select Open + Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2016-10-03'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'XOM'
and AP.Day = '2016-10-03'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-12-30'
and AP.Ticker = 'XOM';

-- CB

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
and AP.Day = '2016-05-02'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'CB'
and AP.Day = '2016-05-02'
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
and AP.Day = '2016-10-03'
)
AND
Close > (
select Open - Open * 0.15
from AdjustedPrices AP
where AP.Ticker = 'CB'
and AP.Day = '2016-10-03'
)
THEN 'Hold was correct'
ELSE 'Hold was incorrect'
END as Judgement
from AdjustedPrices AP
where AP.Day = '2016-12-30'
and AP.Ticker = 'CB';
