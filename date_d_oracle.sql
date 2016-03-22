----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Created on          : 14 -11-2013
    -- Development  by     : Hussain Refaa
    -- Email               : hus244@gmail.com
    -- Phone               : +4915775148443
    -- Description         : For Oracle
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
-- ------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
-- There are two temporary tables created for key/id sequencing used in this.
------------------------------------------------------------------------------------------------------------------------
-- OLAP USEFUL SCRIPTS This Script Use To Build Relational Databases Multi-Dimensional Databases(MDB) 
-- data warehouse online analytical processing (OLAP) Star Schema
--  this script wiil generete all days from 2013- 2022
-- include weekend, work day, next day, previous day, day_of_week,
-- day_of_month ,day_of_yea, previous_day,next_day, weekend,
-- week_of_yea, month, month_of_year,quarter_of_year,year
-- The will inhance performance of your imensional Databases
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Date Dimension table
CREATE TABLE Date_D(
DateKey Integer NOT NULL,
DateValue Date NOT NULL,
Day Char(10 ),
DayOfWeek Integer,
DayOfMonth Integer,
DayOfYear Integer,
PreviousDay date,
NextDay date,
WeekOfYear Integer,
Month Char(10 ),
MonthOfYear Integer,
QuarterOfYear Integer,
Year Integer
)

-- SQL To populate the table:
-- To change the date range, change the date in sub-select and Connect by Level value.
INSERT INTO Date_D
SELECT
to_number(to_char(CurrDate, 'YYYYMMDD')) as DateKey,
CurrDate AS DateValue,
TO_CHAR(CurrDate,'Day') as Day,
to_number(TO_CHAR(CurrDate,'D')) AS DayOfWeek,
to_number(TO_CHAR(CurrDate,'DD')) AS DayOfMonth,
to_number(TO_CHAR(CurrDate,'DDD')) AS DayOfYear,
CurrDate - 1 as PreviousDay,
CurrDate + 1 as NextDay,
to_number(TO_CHAR(CurrDate+1,'IW')) AS WeekOfYear,
TO_CHAR(CurrDate,'Month') AS Month,
to_number(TO_CHAR(CurrDate,'MM')) AS MonthofYear,
to_number((TO_CHAR(CurrDate,'Q'))) AS QuarterOfYear,
to_number(TO_CHAR(CurrDate,'YYYY')) AS Year
FROM (
select level n, TO_DATE('31/12/2009','DD/MM/YYYY') + NUMTODSINTERVAL(level,'day') CurrDate
from dual
connect by level <= 1000)
order by 1
