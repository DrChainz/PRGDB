-- CREATE SCHEMA [Acct]

-- select * from [Acct].[Dispburse_tmp] order by AcctNum

/*
CREATE TABLE [Acct].[Dispburse_tmp]
(
	AcctNum						varchar(15)		NOT NULL,	-- think the format is 12 chars
	InsuredName					varchar(100)	NOT NULL,
	DisbursementAmt				money			NOT NULL,
	ReserveAmt					money			NOT NULL,
	CreateDt					smalldatetime	NOT NULL,
	DaysSinceCreateDt			smallint		NOT NULL,
	EffectiveDt					smalldatetime	NOT NULL,
	DaysSinceEffectiveDt		smallint		NOT NULL,
	FirstDueDt					smalldatetime	NOT NULL,
	ReleaseDt					smalldatetime	NOT NULL,
	DaysSinceReleaseDt			smallint		NOT NULL,
	CurrentHoldsOnDisbursement	varchar(100)	NULL,		-- some string value that looks like a increment of the count
	PolicyNum					varchar(15)		NOT NULL	-- also looks to be less than 15
);
*/
-- select * from [Acct].[Dispburse_tmp];
/*
drop table [Acct].[Acct];

create table [Acct].[Acct]
(
	AcctNum					[varchar](12)		NOT NULL	UNIQUE,
	PolicyNum				[varchar](9)		NOT NULL,
	SerialNum				[varchar](20)		NULL,
	InsuredName				[varchar](50)		NOT NULL,

	Vin						[char](17)			NULL,
	AdminName				[varchar](30)		NULL,
	PaymentAmt				[money]				NULL,
	NumPayments				[smallint]			NULL,					-- could be a tinyint if we wanted
	PolicyTerm				[smallint]			NULL,
	Coverage				[varchar](20)		NULL,
	
	TotalPremiumAmt			[money]				NULL,
	DownPaymentAmt			[money]				NULL,
	FinancedAmt				[money]				NULL,
	SellerCostAmt			[money]				NULL,
	DiscountAmt				[money]				NULL,
	DisbursementAmt			[money]				NULL,
	FundingToEntityAmt		[money]				NULL,
	ReserveAmt				[money]				NULL,

	CreateDt				[smalldatetime]		NULL,
	EffectiveDt				[smalldatetime]		NULL,
	FirstDueDt				[smalldatetime]		NULL,
	ReleaseDt				[smalldatetime]		NULL,
	ExpireDt				[smalldatetime]		NULL,
	Salesman				[varchar](20)		NULL
);

CREATE UNIQUE INDEX PK_Acct_PolicyNum ON [Acct].[Acct] (PolicyNum);

-- alter table acct.acct add ExpireDt				[smalldatetime]		NULL

-- alter table acct.acct add Salesman varchar(20) NULL

*/

/*
CREATE TABLE [Acct].[AcctNew]
(
	AcctNum					[varchar](12),
	InsuredName				[varchar](50),
	CreateDt				[smalldatetime],
	AgentName				[varchar](100),
	AdminName				[varchar](100),
	Coverage				[varchar](20),
	VIN						[char](17),
	Make					[varchar](20),
	Model					[varchar](30),
	Year					[char](4),
	TotalPremiumAmt			[money],
	DownPaymentAmt			[money],
	FinancedAmt				[money],
	SellerCostAmt			[money],
	DisbursementAmt			[money],
	DiscountAmt				[money],
	NumPayments				[smallint],
	PaymentAmt				[money],
	FundingToEntityAmt		[money],
	PolicyTerm				[smallint],
	PolicyNum				[varchar](15).
	Cancelled				[char](1),
	CancelDt				[smalldatetime]
);

-- alter table Acct.Acct add 	Cancelled [char](1), CancelDt	[smalldatetime]

alter table Acct.Acct add Make	[varchar](20),
						  Model	[varchar](30),
						  Year	[char](4)


-- update Acct.Acct set Cancelled = 'N'

-- GO
*/

/*
declare @a table
(
	AcctNum					[varchar](12),
	PolicyNum				[varchar](9),
	InsuredName				[varchar](50),
	CreateDt				[smalldatetime],
	EffectiveDt				[smalldatetime],
	FirstDueDt				[smalldatetime],
	ReleaseDt				[smalldatetime],
	DisbursementAmt			[money],
	ReserveAmt				[money]
);

insert @a (AcctNum)
select distinct AcctNum from [Acct].[Dispburse_tmp];

update @a set PolicyNum = t.PolicyNum,
			  InsuredName = t.InsuredName,
			  CreateDt = t.CreateDt,
			  EffectiveDt = t.EffectiveDt,
			  FirstDueDt = t.FirstDueDt,
			  ReleaseDt = t.ReleaseDt
from @a a, [Acct].[Dispburse_tmp] t
where a.AcctNum = t.AcctNum;

update @a set DisbursementAmt = t.DisbursementAmt
from @a a, [Acct].[Dispburse_tmp] t
where a.AcctNum = t.AcctNum
  and t.DisbursementAmt > 0;

update @a set ReserveAmt = t.ReserveAmt
from @a a, [Acct].[Dispburse_tmp] t
where a.AcctNum = t.AcctNum
  and t.ReserveAmt > 0;

-- select * from @a;

delete @a
where AcctNum in (select AcctNum from [Acct].[Acct]);

insert [Acct].[Acct] (AcctNum, PolicyNum, InsuredName, CreateDt, EffectiveDt, FirstDueDt, ReleaseDt, DisbursementAmt, ReserveAmt)
select AcctNum, PolicyNum, InsuredName, CreateDt, EffectiveDt, FirstDueDt, ReleaseDt, DisbursementAmt, ReserveAmt
from @a;

--  select sum(DisbursementAmt) as SUM_DisbursementAmt, sum(ReserveAmt) as SUM_ReserveAmt from @a;

-----------------------------------------------------------------------------------------------------
update [Acct].[Acct]
	set SerialNum = '412517',
		TotalPremiumAmt = 1945,
		DownPaymentAmt = 195,
		FinancedAmt = 1750,
		SellerCostAmt = 700,
		DiscountAmt = 200
where AcctNum = '1043-4725099'

-----------------------------------------------------------------------------------------------------
declare @d table (AcctNum varchar(15), DiscountAmt money);
insert @d
select '1043-4735544',221.22 union
select '1043-4735551',200.00 union
select '1043-4735569',225.45 union
select '1043-4735577',225.90 union
select '1043-4735585',242.34 union
select '1043-4735593',279.18 union
select '1043-4735601',247.86 union
select '1043-4758017',200.00 union
select '1043-4758025',200.00 union
select '1043-4758033',200.00 union
select '1043-4758041',233.82 union
select '1043-4758058',200.00 union
select '1043-4758066',209.72 union
select '1043-4758074',241.20 union
select '1043-4803789',257.94 union
select '1043-4803797',272.25 union
select '1043-4803805',281.25 union
select '1043-4803813',227.97 union
select '1043-4803821',240.30 union
select '1043-4803839',241.65 union
select '1043-4803847',190.00 union
select '1043-4821260',209.72 union
select '1043-4821278',209.93 union
select '1043-4821286',271.89 union
select '1043-4821294',257.94 union
select '1043-4821302',190.00;

update [Acct].[Acct] set DiscountAmt = d.DiscountAmt
from [Acct].[Acct] a, @d d
where a.AcctNum = d.AcctNum;
*/


/*
-- select * from Acct.Acct
select * from [Acct].[Acct]
select * from [Acct].[AcctNew]
*/

-------------------------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------------------------
declare @b table
(
	AcctNum					[varchar](12),
	PolicyNum				[varchar](15),
	InsuredName				[varchar](50),
	CreateDt				[smalldatetime],
	AgentName				[varchar](100),
	AdminName				[varchar](100),
	Coverage				[varchar](20),
	Vin						[char](17),
	TotalPremiumAmt			[money],
	DownPaymentAmt			[money],
	FinancedAmt				[money],
	SellerCostAmt			[money],
	DisbursementAmt			[money],
	DiscountAmt				[money],
	NumPayments				[smallint],
	PaymentAmt				[money],
	FundingToEntityAmt		[money],
	PolicyTerm				[smallint]
);

insert @b (AcctNum)
select distinct AcctNum
from Acct.AcctNew where AcctNum not in (select AcctNum from Acct.Acct);

update @b set	PolicyNum = n.PolicyNum,
				InsuredName = n.InsuredName,
				CreateDt = n.CreateDt,
				AgentName = n.AgentName,
				AdminName = n.AdminName,
				Coverage = n.Coverage,
				Vin = n.Vin,
				TotalPremiumAmt = n.TotalPremiumAmt,
				DownPaymentAmt = n.DownPaymentAmt,
				FinancedAmt = n.FinancedAmt,
				SellerCostAmt = n.SellerCostAmt,
				DisbursementAmt = n.DisbursementAmt,
				DiscountAmt = n.DiscountAmt,
				NumPayments = n.NumPayments,
				PaymentAmt = n.PaymentAmt,
				FundingToEntityAmt = n.FundingToEntityAmt,
				PolicyTerm = n.PolicyTerm
from @b b, [Acct].[AcctNew] n
where b.AcctNum = n.AcctNum;

--select * from @b;

-- select max(len(AdminName)) from @b;

-- select * from Acct.Acct

insert [Acct].[Acct] (	AcctNum, PolicyNum, InsuredName, Vin, AdminName, PaymentAmt, NumPayments, PolicyTerm,
						Coverage, TotalPremiumAmt, DownPaymentAmt, FinancedAmt, SellerCostAmt, DiscountAmt,
						DisbursementAmt, FundingToEntityAmt, ReserveAmt, CreateDt, EffectiveDt, FirstDueDt,
						ReleaseDt )
select AcctNum, PolicyNum, InsuredName, Vin, AdminName, PaymentAmt, NumPayments, PolicyTerm,
						Coverage, TotalPremiumAmt, DownPaymentAmt, FinancedAmt, SellerCostAmt, DiscountAmt,
						DisbursementAmt, FundingToEntityAmt,  NULL ReserveAmt, CreateDt, NULL EffectiveDt, NULL FirstDueDt,
						NULL ReleaseDt
from @b;

--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
update Acct.Acct set Vin = n.Vin
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.Vin is NULL;

update Acct.Acct set AdminName = n.AdminName
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.AdminName is NULL;

update Acct.Acct set AdminName = n.AdminName
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.AdminName is NULL;

update Acct.Acct set PaymentAmt = n.PaymentAmt
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.PaymentAmt is NULL;

update Acct.Acct set NumPayments = n.NumPayments
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.NumPayments is NULL;

update Acct.Acct set PolicyTerm = n.PolicyTerm
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.PolicyTerm is NULL;

update Acct.Acct set Coverage = n.Coverage
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.Coverage is NULL;

update Acct.Acct set TotalPremiumAmt = n.TotalPremiumAmt
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.TotalPremiumAmt is NULL;

update Acct.Acct set DownPaymentAmt = n.DownPaymentAmt
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.DownPaymentAmt is NULL;

update Acct.Acct set FinancedAmt = n.FinancedAmt
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.FinancedAmt is NULL;

update Acct.Acct set SellerCostAmt = n.SellerCostAmt
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.SellerCostAmt is NULL;

update Acct.Acct set FundingToEntityAmt = n.FundingToEntityAmt
from Acct.Acct a, Acct.AcctNew n
where a.AcctNum = n.AcctNum
  and a.FundingToEntityAmt is NULL;

-- select * from QSM.CarData.Car where Vin = 'W04GP5EC6B1027334'

/*
update Acct.Acct
set Vin = 'W04GP5EC6B1027334',
	Make = 
	Model = 
	Year = 
	AdminName = 'Royal Administration Services',
	PaymentAmt = 97.22,
	NumPayments = 18,
	PolicyTerm = 72,
	Coverage = 'EXCLUSION',
	Cancelled = 'Y'
where AcctNum = '1043-4725099'
-- NANCY GUENTHER
*/

/*
update Acct.Acct
	AdminName = 'Omega',
	PaymentAmt = 136.55,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'NAMED',
	Cancelled = 'Y'

-- select * from qsm.cardata.car where Vin = '1D4GP45R66B609571'

update Acct.Acct
set Vin = '1D4GP45R66B609571',
	Make = 'DODGE',
	Model = 'CARAVAN',
	Year = 2006,
	AdminName = 'Omega',
	TotalPremiumAmt = 2653,
	DownPaymentAmt = 195,
	FinancedAmt = 2458,
	PaymentAmt = 136.55,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'NAMED',
	ExpireDt = '5/20/2020',
	Cancelled = 'Y',
	CancelDt = NULL,
	Salesman = 'dans'
where AcctNum = '1043-4735544'
-- TANGELA POLLARD


*/

/*
update Acct.Acct
set Vin = '1FMHK7F88BGA87297',
	Make = 'FORD',
	Model = 'EXPLORER',
	Year = 2011,
	AdminName = 'SunPath Ltd.',
	TotalPremiumAmt = 2285,
	DownPaymentAmt = 195,
	FinancedAmt = 2090,
	PaymentAmt = 116.11,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'NAMED',
	ExpireDt = '5/20/2020',
	Cancelled = 'Y'
where AcctNum = '1043-4735551'
-- GREGORY MANION
*/

/*
update Acct.Acct
set Vin = 'JM1BK343551319971',
	Make = 'MAZDA',
	Model = 'MAZDA3',
	Year = 2005,
	AdminName = 'SunPath Ltd.',
	TotalPremiumAmt = 2700,
	DownPaymentAmt = 195,
	FinancedAmt = 2505,
	PaymentAmt = 139.16,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'NAMED',
	ExpireDt = '5/21/2020',
	Cancelled = 'Y'
where AcctNum = '1043-4735569'
-- MIKE HYDELL
*/

/*
update Acct.Acct
set Vin = '1G4HP57236U228669',
	Make = 'BUICK',
	Model = 'LUCERNE',
	Year = 2006,
	AdminName = 'Royal Administration Services',
	TotalPremiumAmt = 2705,
	DownPaymentAmt = 195,
	FinancedAmt = 2510,
	PaymentAmt = 139.44,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'NAMED',
	ExpireDt = '5/22/2020',
	Cancelled = 'Y',
	CancelDt = '5/20/2015',
	Salesman = 'dans'
where AcctNum = '1043-4735577'
-- BILLIE IVES
*/

/*
update Acct.Acct
set Vin = '4JGDA5HB1CA079450',
	Make = 'MERCEDES-BENZ',
	Model = 'M-CLASS',
	Year = 2012,
	AdminName = 'Omega',
	TotalPremiumAmt = 3957,
	DownPaymentAmt = 495,
	FinancedAmt = 3462,
	PaymentAmt = 230.80,
	NumPayments = 15,
	PolicyTerm = 60,
	Coverage = 'EXCLUSION',
	ExpireDt = '5/22/2020',
	Cancelled = 'N',
	CancelDt = NULL,
	Salesman = 'dans'
where AcctNum = '1043-4735585'
-- NIRMALA MUSIPATLA
*/

/*
update Acct.Acct
set Vin = '1GKFC03279R292662',
	Make = 'GMC',
	Model = 'YUKON',
	Year = 2009,
	AdminName = 'Omega',
	TotalPremiumAmt = 3297,
	DownPaymentAmt = 195,
	FinancedAmt = 3102,
	PaymentAmt = 172.33,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'EXCLUSION',
	ExpireDt = '5/22/2020',
	Cancelled = 'N',	
	CancelDt = NULL,
	Salesman = 'dans'
where AcctNum = '1043-4735593'
-- CARLENE AND TOM ECONOMY
*/

/*
update Acct.Acct
set Vin = '5NPEB4AC6BH143511',
	Make = 'HYUNDAI',
	Model = 'SONATA',
	Year = 2011,
	AdminName = 'Omega',
	TotalPremiumAmt = 2949,
	DownPaymentAmt = 195,
	FinancedAmt = 2754,
	PaymentAmt = 153,
	NumPayments = 18,
	PolicyTerm = 60,
	Coverage = 'EXCLUSION',
	ExpireDt = '5/23/2020',
	Cancelled = 'Y',	
	CancelDt = NULL,
	Salesman = 'dans'
where AcctNum = '1043-4735601'
-- CARLENE AND TOM ECONOMY
*/

select * from acct.acct where AcctNum = '1043-4735593'

select * from qsm.cardata.car where vin = '1G4HP57236U228669'
select * from qsm.cardata.car where vin = '4JGDA5HB1CA079450'
select * from qsm.cardata.car where lastname = 'lyons' and Make = 'HYUNDAI' and year = '2011' and firstname = 'chad'

select * from qsm.CarData.make

/*
update acct.acct set Make = c.Make, Model = c.Model, Year = c.Year
from acct.acct a, qsm.CarData.Car c
where a.vin = c.vin;
*/

select * from acct.acct;

select * from qsm.cardata.car where vin = '1FMHK7F88BGA872297'

--   select Coverage, count(*) from acct.acct group by coverage

select * from acct.acct