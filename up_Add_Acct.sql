USE [QSM]
GO


-- select * into Acct.Acct_backup3 from Acct.Acct





ALTER PROC [dbo].[up_Add_Acct]
	@AppNum				[char](10)		= NULL, -- '2814797336',
	@FirstName			[varchar](20)	= NULL,
	@LastName			[varchar](30)	= NULL,
	@AcctNum			[varchar](12)	= NULL,
	@PolicyNum	 		[varchar](9)	= NULL,
	@SerialNum			[varchar](20)	= NULL,
	@InsuredName		[varchar](50)	= NULL,
	@Vin				[char](17)		= NULL,
	@AdminName			[varchar](30)	= NULL,
	@PaymentAmt			[money]			= NULL,
	@NumPayments		[smallint]		= NULL,
	@PolicyTerm			[varchar](10)	= NULL,
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
	@Admin				[char](7)		= NULL,

	@Address			[varchar](50)	= NULL,
	@City				[varchar](30)	= NULL,
	@State				[char](2)		= NULL,
	@Zip				[varchar](10)	= NULL,
	@Phone				[varchar](10)	= NULL,
	@Phone2				[varchar](10)	= NULL,
	@Email				[varchar](50)	= NULL,
	@Odom				int				= NULL

AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM [Acct].[Acct] WHERE AppNum = @AppNum)
BEGIN

	IF (@FirstName is NULL)
		SET @FirstName = (SELECT FirstName FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@LastName is NULL)
		SET @LastName = (SELECT LastName FROM [Acct].[Acct] where AppNum = @AppNum);

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
		SET @TotalPremiumAmt = (SELECT TotalPremiumAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@DownPaymentAmt is NULL)
		SET @DownPaymentAmt = (SELECT DownPaymentAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@FinancedAmt is NULL)
		SET @FinancedAmt = (SELECT FinancedAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@SellerCostAmt is NULL)
		SET @SellerCostAmt = (SELECT SellerCostAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@DiscountAmt is NULL)
		SET @DiscountAmt = (SELECT DiscountAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@DisbursementAmt is NULL)
		SET @DisbursementAmt = (SELECT DisbursementAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@FundingToEntityAmt is NULL)
		SET @FundingToEntityAmt = (SELECT FundingToEntityAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@ReserveAmt is NULL)
		SET @ReserveAmt = (SELECT ReserveAmt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@CreateDt is NULL)
		SET @CreateDt = (SELECT CreateDt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@EffectiveDt is NULL)
		SET @EffectiveDt = (SELECT EffectiveDt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@FirstDueDt is NULL)
		SET @FirstDueDt = (SELECT FirstDueDt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@ReleaseDt is NULL)
		SET @ReleaseDt = (SELECT ReleaseDt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Cancelled is NULL)
		SET @Cancelled = (SELECT Cancelled FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@CancelDt is NULL)
		SET @CancelDt = (SELECT CancelDt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Make is NULL)
		SET @Make = (SELECT Make FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Model is NULL)
		SET @Model = (SELECT Model FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Year is NULL)
		SET @Year = (SELECT Year FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@ExpireDt is NULL)
		SET @ExpireDt = (SELECT ExpireDt FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Salesman is NULL)
		SET @Salesman = (SELECT Salesman FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Admin is NULL)
		SET @Admin = (SELECT Admin FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Address is NULL)
		SET @Address = (SELECT Address FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@City is NULL)
		SET @City = (SELECT City FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@State is NULL)
		SET @State = (SELECT State FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Zip is NULL)
		SET @Zip = (SELECT Zip FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Phone is NULL)
		SET @Phone = (SELECT Phone FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Phone2 is NULL)
		SET @Phone2 = (SELECT Phone2 FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Email is NULL)
		SET @Email = (SELECT Email FROM [Acct].[Acct] where AppNum = @AppNum);

	IF (@Odom is NULL)
		SET @Odom = (SELECT Odom FROM [Acct].[Acct] where AppNum = @AppNum);

/* -- don't seem to work
	IF @Phone like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
		SET @Phone = substring(@Phone,1,3) + substring(@Phone,5,3) + substring(@Phone, 9,4);

	IF @Phone2 like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
		SET @Phone2 = substring(@Phone2,1,3) + substring(@Phone2,5,3) + substring(@Phone2, 9,4);
*/

	UPDATE [Acct].[Acct]
		SET AcctNum			= @AcctNum,
			FirstName		= @FirstName,
			LastName		= @LastName,
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
			Admin			= @Admin,
			Address			= @Address,
			City			= @City,
			State			= @State,
			Zip				= @Zip,
			Phone			= @Phone,
			Phone2			= @Phone2,
			Email			= @Email,
			Odom			= @Odom
		WHERE AppNum = @AppNum
END
ELSE
BEGIN
INSERT [Acct].[Acct] (AcctNum, PolicyNum, SerialNum, InsuredName, Vin, AdminName, PaymentAmt, NumPayments, PolicyTerm, CoverageType, Coverage,
					  TotalPremiumAmt, DownPaymentAmt, FinancedAmt, SellerCostAmt, DiscountAmt, DisbursementAmt, FundingToEntityAmt,
					  ReserveAmt, CreateDt, EffectiveDt, FirstDueDt, ReleaseDt, Cancelled, CancelDt, Make, Model, Year, ExpireDt,
					  Salesman, AppNum, Admin, Address, City, State, Zip, Phone, Phone2, Email, FirstName, LastName, Odom)

SELECT @AcctNum, @PolicyNum, @SerialNum, @InsuredName, @Vin, @AdminName, @PaymentAmt, @NumPayments, @PolicyTerm, @CoverageType, @Coverage,
	   @TotalPremiumAmt, @DownPaymentAmt, @FinancedAmt, @SellerCostAmt, @DiscountAmt, @DisbursementAmt, @FundingToEntityAmt,
	   @ReserveAmt, @CreateDt, @EffectiveDt, @FirstDueDt, @ReleaseDt, @Cancelled, @CancelDt, @Make, @Model, @Year, @ExpireDt,
	   @Salesman, @AppNum, @Admin, @Address, @City, @State, @Zip, @Phone, @Phone2, @Email, @FirstName, @LastName, @Odom;
END

GO

