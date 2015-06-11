USE [QSM]
GO
/****** Object:  StoredProcedure [dbo].[up_Add_Acct]    Script Date: 6/10/2015 11:17:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[up_Add_Acct]
	@AppNum				[char](10)		= NULL, -- '2814797336',
	@AcctNum			[varchar](12)	= NULL,
	@PolicyNum	 		[varchar](9)	= NULL,
	@SerialNum			[varchar](20)	= NULL,
	@InsuredName		[varchar](50)	= NULL,
	@Vin				[char](17)		= NULL,
	@AdminName			[varchar](30)	= NULL,
	@PaymentAmt			[money]			= NULL,
	@NumPayments		[smallint]		= NULL,
	@PolicyTerm			[smallint]		= NULL,
	@CoverageType		[varchar](10)	= NULL,
	@Coverage			[varchar](20)	= NULL,
	@TotalPremiumAmt	[money]			= NULL,
	@DownPaymentAmt		[money]			= NULL,
	@FinancedAmt		[money]			= NULL,
	@SellerCostAmt		[money]			= NULL,
	@DiscountAmt		[money]			= NULL,
	@DisbursementAmt	[money]			= NULL,
	@FundingToEntityAmt	[money]			= NULL,
	@ReserveAmt			[money]			= NULL,
	@CreateDt			[smalldatetime]	= NULL,
	@EffectiveDt		[smalldatetime]	= NULL,
	@FirstDueDt			[smalldatetime]	= NULL,
	@ReleaseDt			[smalldatetime]	= NULL,
	@Cancelled			[char](1)		= NULL,
	@CancelDt			[smalldatetime]	= NULL,
	@Make				[varchar](20)	= NULL,
	@Model				[varchar](30)	= NULL,
	@Year				[char](4)		= NULL,
	@ExpireDt			[smalldatetime]	= NULL,
	@Salesman			[varchar](20)	= NULL,
	@Admin				[char](7)		= NULL
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM [Acct].[Acct] WHERE AppNum = @AppNum)
BEGIN

	IF (@AcctNum is NULL)
		SET @AcctNum = (SELECT AcctNum FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@PolicyNum is NULL)
		SET @PolicyNum = (SELECT PolicyNum FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@SerialNum is NULL)
		SET @SerialNum = (SELECT SerialNum FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@InsuredName is NULL)
		SET @InsuredName = (select InsuredName FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Vin is NULL)
		SET @Vin = (SELECT Vin FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@AdminName is NULL)
		SET @AdminName = (SELECT AdminName FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@PaymentAmt is NULL)
		SET @PaymentAmt = (SELECT PaymentAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@NumPayments is NULL)
		SET @NumPayments = (SELECT NumPayments FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@PolicyTerm is NULL)
		SET @PolicyTerm = (SELECT PolicyTerm FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@CoverageType is NULL)
		SET @CoverageType = (SELECT CoverageType FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Coverage is NULL)
		SET @Coverage = (SELECT Coverage FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@TotalPremiumAmt is NULL)
		select @TotalPremiumAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@DownPaymentAmt is NULL)
		select @DownPaymentAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@FinancedAmt is NULL)
		select @FinancedAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@SellerCostAmt is NULL)
		select @SellerCostAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@DiscountAmt is NULL)
		select @DiscountAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@DisbursementAmt is NULL)
		select @DisbursementAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@FundingToEntityAmt is NULL)
		select @FundingToEntityAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@ReserveAmt is NULL)
		select @ReserveAmt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@CreateDt is NULL)
		select @CreateDt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@EffectiveDt is NULL)
		select @EffectiveDt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@FirstDueDt is NULL)
		select @FirstDueDt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@ReleaseDt is NULL)
		select @ReleaseDt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@Cancelled is NULL)
		select @Cancelled FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@CancelDt is NULL)
		select @CancelDt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@Make is NULL)
		select @Make FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@Model is NULL)
		select @Model FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@Year is NULL)
		select @Year FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@ExpireDt is NULL)
		select @ExpireDt FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@Salesman is NULL)
		select @Salesman FROM [Acct].[Acct] where AppNum = @AppNum;

	IF (@Admin is NULL)
		select @Admin FROM [Acct].[Acct] where AppNum = @AppNum;

	UPDATE [Acct].[Acct]
		SET AcctNum			= @AcctNum,
			PolicyNum		= @PolicyNum,
			SerialNum		= @SerialNum,
			InsuredName		= @InsuredName,
			Vin				= @Vin,
			AdminName		= @AdminName,
			PaymentAmt		= @PaymentAmt,
			NumPayments		= @NumPayments,
			PolicyTerm		= @PolicyTerm,
			CoverageType	= @CoverageType,
			Coverage		= @Coverage,
		    TotalPremiumAmt	= @TotalPremiumAmt,
			DownPaymentAmt	= @DownPaymentAmt,
			FinancedAmt		= @FinancedAmt,
			SellerCostAmt	= @SellerCostAmt,
			DiscountAmt		= @DiscountAmt,
			DisbursementAmt	= @DisbursementAmt,
			FundingToEntityAmt	= @FundingToEntityAmt,
			ReserveAmt		= @ReserveAmt,
			CreateDt		= @CreateDt,
			EffectiveDt		= @EffectiveDt,
			FirstDueDt		= @FirstDueDt,
			ReleaseDt		= @ReleaseDt,
			Cancelled		= @Cancelled,
			CancelDt		= @CancelDt,
			Make			= @Make,
			Model			= @Model,
			Year			= @Year,
			ExpireDt		= @ExpireDt,
			Salesman		= @Salesman,
			Admin			= @Admin						
			WHERE AppNum = @AppNum
END
ELSE
BEGIN
INSERT [Acct].[Acct] (AcctNum, PolicyNum, SerialNum, InsuredName, Vin, AdminName, PaymentAmt, NumPayments, PolicyTerm, CoverageType, Coverage,
					  TotalPremiumAmt, DownPaymentAmt, FinancedAmt, SellerCostAmt, DiscountAmt, DisbursementAmt, FundingToEntityAmt,
					  ReserveAmt, CreateDt, EffectiveDt, FirstDueDt, ReleaseDt, Cancelled, CancelDt, Make, Model, Year, ExpireDt,
					  Salesman, AppNum, Admin)

SELECT @AcctNum, @PolicyNum, @SerialNum, @InsuredName, @Vin, @AdminName, @PaymentAmt, @NumPayments, @PolicyTerm, @CoverageType, @Coverage,
	   @TotalPremiumAmt, @DownPaymentAmt, @FinancedAmt, @SellerCostAmt, @DiscountAmt, @DisbursementAmt, @FundingToEntityAmt,
	   @ReserveAmt, @CreateDt, @EffectiveDt, @FirstDueDt, @ReleaseDt, @Cancelled, @CancelDt, @Make, @Model, @Year, @ExpireDt,
	   @Salesman, @AppNum, @Admin;
END
