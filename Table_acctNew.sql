USE [PrivateReserve]
GO

-- select len(Class), count(*) from acct.acct group by len(Class)

IF OBJECT_ID(N'[Acct].[acctNew]') IS NOT NULL
	DROP TABLE [Acct].[acctNew];
GO

CREATE TABLE [Acct].[acctNew]
(
	[AppNum]			[char](10)		NOT NULL UNIQUE,		-- primary key
	[AcctNum]			[char](10)		NULL,		-- don't have for all rows
	[ContractNum]		[varchar](10)	NULL,
	[SaleDt]			[smalldatetime]	NULL,
	[RateDt]			[smalldatetime]	NULL,
	
	[Vin]				[char](17)		NULL,
	[Make]				[varchar](20)	NULL,
	[Model]				[varchar](30)	NULL,
	[Year]				[char](4)		NULL,
	[NewUsed]			[char](1)		NULL,

	[FirstName]			[varchar](20)	NULL,
	[LastName]			[varchar](30)	NULL,
	[InsuredName]		[varchar](50)	NULL,
	[Address]			[varchar](50)	NULL,
	[City]				[varchar](30)	NULL,
	[State]				[char](2)		NULL,
	[Zip]				[varchar](10)	NULL,
	[Phone]				[varchar](10)	NULL,
	[Phone2]			[varchar](10)	NULL,
	[Email]				[varchar](50)	NULL,

	[Salesman]			[varchar](20)	NULL,
	[Admin]				[varchar](10)	NULL,		-- use short name and link to longer name
	[CoverageType]		[varchar](10)	NULL,
	[Coverage]			[varchar](10)	NULL,
	[PolicyTerm]		[varchar](10)	NULL,
	[TermMonth]			[smallint]		NULL,
	[TermMiles]			[smallint]		NULL,
	[Deduct]			[money]			NULL,
	[Class]				[varchar](10)	NULL,
	[PurchOdom]			[int]			NULL,
	[ExpOdom]			[int]			NULL,
	[TotalPremiumAmt]	[money]			NULL,		-- Customer Cost
	[SalesTaxAmt]		[money]			NULL,		-- likely always zero
	[PayPlan]			[varchar](10)	NULL,		-- likely aways Fin unless the PIF shows
	[PaymentAmt]		[money]			NULL,
	[NumPayments]		[smallint]		NULL,
	[DownPaymentAmt]	[money]			NULL,
	[FinancedAmt]		[money]			NULL,	
	[FirstDueDt]		[smalldatetime] NULL,
	[ReleaseDt]			[smalldatetime] NULL,

	-- Think some of these are going to get renamed
	[SellerCostAmt]		[money] NULL,
	[DiscountAmt]		[money] NULL,
	[DisbursementAmt]	[money] NULL,
	[FundingToEntityAmt] [money] NULL,
	[ReserveAmt]		[money] NULL,
	[ProfitAmt]			[money] NULL,

	[EffectiveDt]		[smalldatetime] NULL,
	[ExpireDt]			[smalldatetime] NULL,
	[Cancelled]			[char](1) NULL,
	[CancelDt]			[smalldatetime] NULL,

-- 	[SerialNum] [varchar](20) NULL,
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

