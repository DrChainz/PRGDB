IF OBJECT_ID(N'up_SaleCnt') IS NOT NULL
	DROP PROC up_SaleCnt;
GO

CREATE PROC up_SaleCnt
AS

DECLARE @r TABLE
(
	CallDt				smalldatetime,
	CallCnt				int,
	WirelessCnt			int,
	WirelessRatio		numeric(3,2),
	SaleCnt				int,
	WirelessSaleCnt		int,
	WirelessSaleRatio	numeric(3,2)
);

insert @r (CallDt, CallCnt)
select CallDt, count(*)
FROM [CarData].[CarData_2015_05_May_19]
group by CallDt
order by CallDt;

update @r set WirelessCnt = 0, WirelessRatio = 0, SaleCnt = 0, WirelessSaleCnt = 0, WirelessSaleRatio = 0;

SELECT CallDt, count(*) as WirelessCnt
INTO #wirelessCnt
FROM [CarData].[CarData_2015_05_May_19]
WHERE Wireless = 'Y'
GROUP BY CallDt;

UPDATE @r SET WirelessCnt = w.WirelessCnt
FROM @r r, #wirelessCnt w
WHERE r.CallDt = w.CallDt;

update @r set WirelessRatio = cast((cast(WirelessCnt as float) / cast(CallCnt as float)) as numeric(3,2));

DECLARE @vin_sale table
(
	Vin			varchar(50),
	Wireless	char(1),
	Make		varchar(30),
	Model		varchar(30),
	CallDt		smalldatetime
);

INSERT @vin_sale (Vin, Wireless, CallDt)
SELECT Vin, 'N', MAX(CallDt)
FROM [CarData].[CarData_2015_05_May_19]
WHERE status = 'SALE'
GROUP BY Vin;

UPDATE @vin_sale set Wireless = c.Wireless
FROM @vin_sale v, [CarData].[CarData_2015_05_May_19] c
WHERE v.Vin = c.Vin;

/*
update @vin_sale set Make = c.Make, Model = c.Model
FROM @vin_sale v, CarData.Car c
WHERE v.Vin = c.Vin;
*/

-- select * from @vin_sale;



select CallDt, count(*) as SaleCnt
into #sale_cnt
FROM @vin_sale
GROUP BY CallDt;

update @r set SaleCnt = s.SaleCnt
FROM @r r, #sale_cnt s
where r.CallDt = s.CallDt
;

/*
select CallDt, count(*) as WirelessSaleCnt
into #wireless_sale_cnt
FROM @vin_sale
WHERE Wireless = 'Y'
GROUP BY CallDt;


update @r set WirelessSaleCnt = c.WirelessSaleCnt
FROM @r r, #wireless_sale_cnt c
where r.CallDt = c.CallDt;

update @r set WirelessSaleRatio = cast((cast(WirelessSaleCnt as float) / cast(SaleCnt as float)) as numeric(3,2));
*/


------------------------
-- show the results
------------------------
select *
from @r
order by CallDt
;

-- select sum(CallCnt) as SumCallCnt from @r;

GO
-- select status, count(*) from [CarData].[CarData_2015_05_May_19] group by status;


exec up_SaleCnt;


--  set CallDt = cast(floor(cast(cast([last_local_call_time] as smalldatetime) as float)) as smalldatetime)