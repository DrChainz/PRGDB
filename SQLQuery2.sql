USE [PrivateReserve]
GO

CREATE TABLE [Acct].[Acct]
(
	[AppNum] [char](10) NOT NULL,
	[AcctNum] [char](15) NULL,
	[ContractNum] [varchar](10) NULL,
	[SaleDt] [smalldatetime] NULL,
	[RateDt] [smalldatetime] NULL,
	[Vin] [char](17) NULL,
	[Make] [varchar](20) NULL,
	[Model] [varchar](30) NULL,
	[Year] [char](4) NULL,
	[NewOrUsed] [char](1) NULL,
	[FirstName] [varchar](20) NULL,
	[LastName] [varchar](30) NULL,
	[InsuredName] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](30) NULL,
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
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

