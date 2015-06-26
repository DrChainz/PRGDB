
-- select * from tmp_SalesLog;

/*
select purchDate, count(*)
from tmp_SalesLog
group by purchDate
order by purchDate desc
*/

/*
select * from Acct.Acct

select SaleDt, count(*)f 
*/

-- CREATE UNIQUE INDEX PK_Acct_Acct ON [Acct].[Acct](AppNum);

IF OBJECT_ID(N'up_AddUpdate_Sales') IS NOT NULL
	DROP PROC up_AddUpdate_Sales;
GO


CREATE PROC up_AddUpdate_Sales
AS
------------------------------------------------------------------------
-- This proc is interup step till write loader app for data extracted.
------------------------------------------------------------------------
INSERT [Acct].[Acct] (AppNum)
SELECT DISTINCT AppNumber
FROM tmp_SalesLog
WHERE AppNumber NOT IN (SELECT AppNum FROM [Acct].[Acct]);

DECLARE @AppNum			[char](10),
		@AcctNum		[char](15),
		@ContractNum	[varchar](10),
		@SaleDt			[smalldatetime],
		@RateDt			[smalldatetime],
		@Vin			[char](17),
		@Make			[varchar](20),
		@Model			[varchar](30),
		@Year			[char](4),
		@NewOrUsed		[char](1),
		@FirstName		[varchar](20),
		@LastName		[varchar](30),
		@InsuredName	[varchar](50),
		@Address		[varchar](50),
		@City			[varchar](30) NULL,
	[State] [char](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone] [varchar](10) NULL,
	[Phone2] [varchar](10) NULL,
	[Email] [varchar](50) NULL,
	[Salesman] [varchar](10) NULL,
	[Admin] [varchar](10) NULL,
	[CoverageType] [varchar](10) NULL,
	[Coverage] [varchar](10) NULL,
	[TermMonth] [smallint] NULL,
	[TermMiles] [int] NULL,
	[Deduct] [money] NULL,
	[Class] [varchar](10) NULL,
	[PurchOdom] [int] NULL,
	[ExpOdom] [int] NULL,
	[TotalPremiumAmt] [money] NULL,
	[SalesTaxAmt] [money] NULL,
	[PayPlan] [varchar](10) NULL,
	[FinanceFeeAmt] [money] NULL,
	[PaymentAmt] [money] NULL,
	[NumPayments] [smallint] NULL,
	[DownPaymentAmt] [money] NULL,
	[FinanceCompany] [varchar](10) NULL,
	[FinanceNum] [varchar](10) NULL,
	[FinancedAmt] [money] NULL,
	[FirstBillDt] [smalldatetime] NULL,
	[GrossProfitAmt] [money] NULL,
	[NetProfitAmt] [money] NULL,
	[ReleaseDt] [smalldatetime] NULL,
	[ContractCostAmt] [money] NULL,
	[DiscountAmt] [money] NULL,
	[DisbursementAmt] [money] NULL,
	[FundingToEntityAmt] [money] NULL,
	[ReserveAmt] [money] NULL,
	[EffectiveDt] [smalldatetime] NULL,
	[ExpireDt] [smalldatetime] NULL,
	[Cancelled] [char](1) NULL,
	[CancelDt] [smalldatetime] NULL,
	[InstallmentsMade] [smallint] NULL,
	[LastPaymentRcvdDt] [smalldatetime] NULL




