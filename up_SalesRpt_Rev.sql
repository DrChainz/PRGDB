USE [PrivateReserve]
GO
/****** Object:  StoredProcedure [dbo].[up_SalesRpt_Rev]    Script Date: 9/16/2015 1:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
alter table Acct.Acct
	add SaleCostBaseAmt	money,
		DownPaymentBonusAmt	money,
		DiscountBonusAmt	money,
		NumPaymentBonusAmt	money,
		TotalBonusAmt	money,
		PIF_SaleCostAmt	money,
		SalesCostAmt money;
*/

-- select * from acct.acct


ALTER PROC [dbo].[up_SalesRpt_Rev]
AS

DECLARE @FridayPayday table
(
	Dt		smalldatetime	NOT NULL UNIQUE
);

insert @FridayPayday (Dt)
select Dt from PRG.Legend.Day where WeekDay = 'Friday' and Year = '2015';

DECLARE @Day table
(
	Dt		smalldatetime	NOT NULL UNIQUE,
	Payday	smalldatetime
);

insert @Day (Dt)
select distinct cast(floor(cast(SaleDt as float)) as smalldatetime) from acct.acct;

declare @foo table ( Dt smalldatetime, Payday smalldatetime);
insert @foo
select d.Dt, min(p.Dt)
from @FridayPayday p, @Day d
where p.Dt > d.Dt
group by d.Dt;

update @Day set Payday = f.Payday
from @foo f, @Day d
where f.Dt = d.Dt;

select * from @Day;

DECLARE @Salesman table
(
	Salesman	varchar(50)	NOT NULL UNIQUE
);

insert @Salesman (Salesman)
select distinct Salesman from acct.acct;

DECLARE @SalesmanDay table
(
	SaleDt				smalldatetime	NOT NULL,
	Salesman			varchar(50)		NOT NULL,
	SaleCnt				smallint		NOT NULL,
	AmtPerSale			money			NOT NULL,
	SaleBaseAmt			money			NOT NULL,
	SumSaleTotalBonus	money			NOT NULL,
	SumPIFBonus			money			NOT NULL
);

insert @SalesmanDay (SaleDt, Salesman, SaleCnt, AmtPerSale, SaleBaseAmt, SumSaleTotalBonus, SumPIFBonus)
select Dt, Salesman, 0, 0, 0, 0, 0
from @Day, @Salesman;

select * from @SalesmanDay;


DECLARE @r TABLE
(
	AppNum	varchar(20),
	SaleDt	smalldatetime,
	CancelDt smalldatetime,
	Canceled char(1),
	Salesman	varchar(30),
	DownPaymentAmt	money,
	DownPaymentBonus	money,
	DiscountAmt	money,
	DiscountBonus money,
	NumPayments	smallint,
	NumPaymentBonus money,
	TotalBonus money,
	CancelBeforePayday char(1),
	PIF char(1),
	NetProfitAmt money,
	SaleCostAmt money
);

insert @r (AppNum, SaleDt, CancelDt, Salesman, DownPaymentAmt, DownPaymentBonus, DiscountAmt, DiscountBonus, NumPayments, NumPaymentBonus, TotalBonus, CancelBeforePayday, PIF, NetProfitAmt, SaleCostAmt)
select AppNum, SaleDt, CancelDt, Salesman, DownPaymentAmt, 0, DiscountAmt, 0, NumPayments, 0, 0, 'N', 'N', NetProfitAmt, 0
from Acct.Acct
where PayPlan IS NOT NULL
order by SaleDt, SalesMan;

select 'fuck';
select * from @r;

update @r set CancelBeforePayday = 'Y'
from @r r, @Day d
where r.SaleDt = d.Dt
  and r.CancelDt <= d.Payday;

declare @x table
(
	SaleDt			smalldatetime,
	Salesman	varchar(50),
	SaleCnt		smallint
);

insert @x
select SaleDt, Salesman, count(*)
from @r
where CancelBeforePayday = 'N'
group by SaleDt, Salesman

update @SalesmanDay set SaleCnt = x.SaleCnt
from @SalesmanDay t, @x x
where t.SaleDt = x.SaleDt
  and t.Salesman = x.Salesman;


update @SalesmanDay set AmtPerSale = 90 where SaleCnt = 1;
update @SalesmanDay set AmtPerSale = 110 where SaleCnt = 2;
update @SalesmanDay set AmtPerSale = 125 where SaleCnt = 3;
update @SalesmanDay set AmtPerSale = 137.5 where SaleCnt = 4;
update @SalesmanDay set AmtPerSale = 150 where SaleCnt >= 5;

update @SalesmanDay set SaleBaseAmt = (SaleCnt * AmtPerSale);

update @r set DownPaymentBonus = 10 where DownPaymentAmt = 395;
update @r set DownPaymentBonus = 20 where DownPaymentAmt = 495;
update @r set DownPaymentBonus = 30 where DownPaymentAmt = 595;
update @r set DownPaymentBonus = 40 where DownPaymentAmt = 695;
update @r set DownPaymentBonus = 50 where DownPaymentAmt = 795;
update @r set DownPaymentBonus = 60 where DownPaymentAmt = 895;
update @r set DownPaymentBonus = 75 where DownPaymentAmt = 995;

update @r set DiscountBonus = 50 where DiscountAmt = 0;
update @r set DiscountBonus = 35 where DiscountAmt between 1 and 100;
update @r set DiscountBonus = 30 where DiscountAmt between 101 and 200;
update @r set DiscountBonus = 25 where DiscountAmt between 201 and 300;
update @r set DiscountBonus = 20 where DiscountAmt between 301 and 400;
update @r set DiscountBonus = 15 where DiscountAmt between 401 and 500;
update @r set DiscountBonus = 10 where DiscountAmt between 501 and 600;

update @r set NumPaymentBonus = 10 where NumPayments = 15;
update @r set NumPaymentBonus = 15 where NumPayments = 12;
update @r set NumPaymentBonus = 20 where NumPayments = 9;
update @r set NumPaymentBonus = 25 where NumPayments = 6;
update @r set NumPaymentBonus = 50 where NumPayments = 3;

update @r set TotalBonus = (DownPaymentBonus + DiscountBonus + NumPaymentBonus);

update @r set SaleCostAmt = d.AmtPerSale + r.TotalBonus
from @SalesmanDay d, @r r
where d.SaleDt = r.SaleDt
  and d.Salesman = r.Salesman
  and CancelBeforePayday = 'N';
 
select 'boo';
select * from @r;


declare @b table
(
	SaleDt				smalldatetime,
	Salesman			varchar(50),
	SumSaleTotalBonus	money
);

insert @b
select SaleDt, Salesman, sum(TotalBonus)
from @r
where CancelBeforePayday = 'N'
group by SaleDt, Salesman;

update @SalesmanDay set SumSaleTotalBonus = b.SumSaleTotalBonus
from @SalesmanDay d, @b b
where d.SaleDt = b.SaleDt
  and d.Salesman = b.Salesman;

select 'Matt';
select * from @SalesmanDay;

select 'after Matt';
select * from @r;


DECLARE @g TABLE
(
	SaleDt		smalldatetime,
	Salesman	varchar(30),
	Cnt			int,
	Amt			money
);

insert @g (SaleDt, Salesman, Cnt, Amt)
select SaleDt, Salesman, count(*) Cnt, 0
from @r
group by SaleDt, Salesman
order by Salesman, SaleDt;

update @g set Amt = (90 * Cnt) where Cnt = 1;
update @g set Amt = (110 * Cnt) where Cnt = 2;
update @g set Amt = (125 * Cnt) where Cnt = 3;
update @g set Amt = (137.50 * Cnt) where Cnt = 4;
update @g set Amt = (150 * Cnt) where Cnt >= 5;

select * from @g;

select * from @r;

select SaleDt, Salesman, sum(TotalBonus) as TotalBonus
from @r
group by SaleDt, Salesman;

select Salesman, sum(TotalBonus) as TotalBonus
from @r
group by Salesman;



-----------------------------------------------
-- PIF
-----------------------------------------------
DECLARE @pif TABLE
(
	AppNum			varchar(20),
	SaleDt			smalldatetime,
	CancelDt		smalldatetime,
	Salesman		varchar(30),
	DownPaymentAmt	money,
	DownPaymentBonus	money,
	DiscountAmt		money,
	DiscountBonus	money,
	NumPayments		smallint,
	NumPaymentBonus money,
	TotalBonus		money,
	CancelBeforePayday char(1),
	NetProfitAmt	money
);

insert @pif (AppNum, SaleDt, CancelDt, Salesman, DownPaymentAmt, DownPaymentBonus, DiscountAmt, DiscountBonus, NumPayments, NumPaymentBonus, TotalBonus, CancelBeforePayday, NetProfitAmt)
select AppNum, SaleDt, CancelDt, Salesman, DownPaymentAmt, 0, DiscountAmt, 0, NumPayments, 0, 0, 'N', NetProfitAmt
from Acct.Acct
where PayPlan IS NULL
order by SaleDt, SalesMan;

update @pif set CancelBeforePayday = 'Y'
from @pif p, @Day d
where p.SaleDt = d.Dt
  and p.CancelDt <= d.Payday;

insert @r (AppNum, SaleDt, CancelDt, Salesman, DownPaymentAmt, DiscountAmt, CancelBeforePayday, PIF, NetProfitAmt, SaleCostAmt)
select AppNum, SaleDt, CancelDt, Salesman, DownPaymentAmt, DiscountAmt, CancelBeforePayday, 'Y', NetProfitAmt, TotalBonus
from @pif
where CancelBeforePayday = 'N';

-------------------------------------------
-- PIF Bonuses
-------------------------------------------
update @pif set TotalBonus = 450 where DiscountAmt <= 0;
update @pif set TotalBonus = 350 where DiscountAmt between 1 and 200;
update @pif set TotalBonus = 300 where DiscountAmt between 201 and 400;
update @pif set TotalBonus = 250 where DiscountAmt between 401 and 600;
update @pif set TotalBonus = 200 where DiscountAmt between 601 and 799;
update @pif set TotalBonus = 150 where DiscountAmt >= 800;

update @r set SaleCostAmt = p.TotalBonus -- , PIF = 'Y'
from @r r, @pif p
where r.AppNum = p.AppNum;

-- select SaleDt from @r group by SaleDt order by SaleDt;
-- declare @men table (Salesman varchar(50));
-- insert @men select distinct Salesman from @r;
-- insert @men select distinct Salesman from @pif where Salesman not in (select Salesman from @men);
-- select * from @men order by Salesman;

select 'PIF';
select * from @pif;
-- 2539705316

declare @p table
(
	SaleDt			smalldatetime,
	Salesman		varchar(50),
	SumPIFBonus		money
);

insert @p
select SaleDt, Salesman, sum(TotalBonus) SumPIFBonus
from @pif
group by Salesman, SaleDt
order by Salesman, SaleDt;

update @SalesmanDay set SumPIFBonus = p.SumPIFBonus
from @SalesmanDay d, @p p
where d.SaleDt = p.SaleDt
  and d.Salesman = p.Salesman;

select * from @SalesmanDay;

update @r set Canceled = 'N';
update @r set Canceled = 'Y' where CancelDt IS NOT NULL;


declare @rpt table
(
	Salesman				varchar(50),
	TotalSales_Cnt			smallint,
	TotalNetProfitAmt		money,
	TotalSaleCostAmt		money,
	PIF_Cnt					smallint,
	Cancel_Cnt				smallint,
	CancelBeforePayday_Cnt	smallint,
	CancelAfterPayday_Cnt	smallint,
	SalesCostAmt_Canceled	money
);

insert @rpt (Salesman, TotalSales_Cnt, TotalNetProfitAmt, TotalSaleCostAmt, PIF_Cnt, Cancel_Cnt, CancelBeforePayday_Cnt, CancelAfterPayday_Cnt, SalesCostAmt_Canceled)
select Salesman, count(*) as TotalSales, sum(NetProfitAmt), sum(SaleCostAmt), 0, 0,0,0, 0
from @r group by Salesman;

declare @pif_cnt table (Salesman varchar(50), PIF_Cnt smallint);
insert @pif_cnt
select Salesman, count(*) from @r where PIF = 'Y' group by salesman;

update @rpt set PIF_Cnt = t.PIF_Cnt
from @rpt r, @pif_cnt t
where r.Salesman = t.Salesman;

declare @cancel table (Salesman varchar(50), Cnt smallint);
insert @cancel
select Salesman, count(*) from @r where Canceled = 'Y' group by salesman;

update @rpt set Cancel_Cnt = c.Cnt
from @rpt r, @cancel c
where r.Salesman = c.Salesman;

delete @cancel;
insert @cancel
select Salesman, count(*) from @r where CancelBeforePayday = 'Y' group by salesman;

update @rpt set CancelBeforePayday_Cnt = c.Cnt
from @rpt r, @cancel c
where r.Salesman = c.Salesman;

delete @cancel;
insert @cancel
select Salesman, count(*) from @r where Canceled = 'Y' and CancelBeforePayday = 'N' group by salesman;


update @rpt set CancelAfterPayday_Cnt = c.Cnt
from @rpt r, @cancel c
where r.Salesman = c.Salesman;

declare @money table  (Salesman varchar(50), SalesCostAmt_Canceled money);
insert @money
select Salesman, sum(SaleCostAmt) as SalesCostAmt_Cancled from @r where Canceled = 'Y' and CancelBeforePayday = 'N' group by salesman;

update @rpt set SalesCostAmt_Canceled = m.SalesCostAmt_Canceled
from @rpt r, @money m
where r.Salesman = m.Salesman;

select 'SalesmanDay';
select * from @SalesmanDay;

update acct.acct set SaleCostBaseAmt = sd.AmtPerSale
from acct.acct a, @SalesmanDay sd
where a.SaleDt = sd.SaleDt
  and a.Salesman = sd.Salesman;

select * from acct.acct

select 'rpt';
select * from @rpt;

select 'ALL';
select * from @r;

select * from acct.acct
where appnum not in (select appnum from @r);

---  select * from @r where PIF = 'Y';

-- **** update @r set PIF = 'Y' from @r r, Acct.Acct a where r.AppNum = a.AppNum and PayPlan IS NULL;


--update @r set PIFBonus = 50 where PIF = 'Y';
