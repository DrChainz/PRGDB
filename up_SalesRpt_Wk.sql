USE PrivateReserve;
GO

IF OBJECT_ID(N'up_SalesRpt_Wk') IS NOT NULL
	DROP PROC up_SalesRpt_Wk;
GO

CREATE PROC up_SalesRpt_Wk
-- 	@Sales_WkNum	int = 20,
	@BeginDt		smalldatetime = '7/17/2015',
	@EndDt			smalldatetime = '7/23/2015'
AS

DECLARE @r TABLE
(
	AppNum	varchar(20),
	SaleDt	smalldatetime,
	Salesman	varchar(30),
	DownPaymentAmt	money,
	DownPaymentBonus	money,
	DiscountAmt	money,
	DiscountBonus money,
	NumPayments	smallint,
	NumPaymentBonus money,
	PIF	char(1), -- PayPlan	varchar(10)
	PIFBonus money,
	TotalBonus money
);

-- select * from [dbo].[tmp_SalesLog]
-- select NumPayments from Acct.Acct
-- select * from Acct.Acct

update Acct.Acct set DiscountAmt = (RetailAmt - CustCostAmt);

insert @r (AppNum, SaleDt, Salesman, DownPaymentAmt, DownPaymentBonus, DiscountAmt, DiscountBonus, NumPayments, NumPaymentBonus, PIF, PIFBonus, TotalBonus)
select AppNum, SaleDt, Salesman, DownPaymentAmt, 0, DiscountAmt, 0, NumPayments, 0, 'N', 0, 0
from Acct.Acct
where SaleDt between @BeginDt and @EndDt
  and Cancelled = 'N'
order by SaleDt, SalesMan

update @r set PIF = 'Y' from @r r, Acct.Acct a where r.AppNum = a.AppNum and PayPlan IS NULL;

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

update @r set PIFBonus = 50 where PIF = 'Y';

update @r set TotalBonus = (DownPaymentBonus + DiscountBonus + NumPaymentBonus + PIFBonus);

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


/*
 SaleDt, Salesman, AppNum, DownPaymentAmt, DiscountAmt, NumPayments, RetailAmt, CustCostAmt
from Acct.Acct
where SaleDt between @BeginDt and @EndDt
order by SaleDt, SalesMan

select SaleDt, Salesman, count(*)
from Acct.Acct
where SaleDt between @BeginDt and @EndDt
  and Cancelled = 'N'
group by SaleDt, Salesman;


*/

GO

EXEC up_SalesRpt_Wk '7/17/2015', '7/23/2015'
