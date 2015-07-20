USE PRG;
GO

	DECLARE @AppNum				varchar(10),
			@AcctNum			varchar(15),
			@ContractNum		varchar(10),
			@SaleDt				smalldatetime,
			@RateDt				smalldatetime,
			@Vin				varchar(17),
			@Make				varchar(20),
			@Model				varchar(30),
			@Year				char(4),
			@NewOrUsed			char(1),
			@FirstName			varchar(20),
			@LastName			varchar(30),
			@InsuredName		varchar(50),
			@Address			varchar(50),
			@City				varchar(30),
			@State				char(2),
			@Zip				varchar(10),
			@Phone				char(10),
			@Phone2				char(10),
			@Email				varchar(50),
			@Salesman			varchar(10),
			@Admin				varchar(10),
			@CoverageType		varchar(10),
			@Coverage			varchar(10),
			@TermMonth			smallint,
			@TermMiles			int,
			@DeductAmt			money,
			@Class				varchar(10),
			@PurchOdom			int,
			@ExpOdom			int,
			@ExpireDt			smalldatetime,
			@TotalPremiumAmt	money,
			@SalesTaxAmt		money,
			@PayPlan			varchar(10),
			@FinanceFeeAmt		money,
			@PaymentAmt			money,
			@NumPayments		smallint,
			@DownPaymentAmt		money,
			@FinanceCompany		varchar(10),
			@FinanceNum			varchar(10),
			@FinancedAmt		money,
			@FirstBillDt		smalldatetime,
			@GrossProfitAmt		money,
			@NetProfitAmt		money,
			@ReleaseDt			smalldatetime,
			@ContractCostAmt	money,
			@DiscountAmt		money,
			@DisbursementAmt	money,
			@FundingToEntityAmt	money,
			@ReserveAmt			money,
			@EffectiveDt		smalldatetime,
			@Cancelled			char(1),
			@CancelDt			smalldatetime,
			@InstallmentsMade	smallint,
			@LastPaymentRcvdDt	smalldatetime;

----------------------------
-- variables nto defined 
DECLARE @VolunteerId_Open	int = 1,
		@VolunteerId_Sale	int = 1,
		@VolunteerId_TO		int = 1,
		@VolunteerId_TA		int = 1,
		@FinanceId			int	= 1;

	DECLARE Contract_cursor CURSOR FOR
	
	SELECT 	AppNum, AcctNum, ContractNum, SaleDt, RateDt, Vin, Make, Model, Year,
	NewOrUsed, FirstName, LastName, InsuredName, Address, City, State, Zip, Phone,
	Phone2, Email, Salesman, Admin, CoverageType, Coverage, TermMonth, TermMiles,
	Deduct, Class, PurchOdom, ExpOdom, TotalPremiumAmt, SalesTaxAmt, PayPlan,
	FinanceFeeAmt,	PaymentAmt, NumPayments, DownPaymentAmt, FinanceCompany, FinanceNum, FinancedAmt,
	FirstBillDt, GrossProfitAmt, NetProfitAmt, ReleaseDt, ContractCostAmt, DiscountAmt, DisbursementAmt,
	FundingToEntityAmt, ReserveAmt, EffectiveDt, ExpireDt, Cancelled, CancelDt, InstallmentsMade,
	LastPaymentRcvdDt
	FROM [PrivateReserve].[Acct].[Acct];

	OPEN Contract_cursor
	
	FETCH NEXT FROM Contract_cursor INTO
	@AppNum, @AcctNum, @ContractNum, @SaleDt, @RateDt, @Vin, @Make, @Model, @Year,
	@NewOrUsed, @FirstName, @LastName, @InsuredName, @Address, @City, @State, @Zip, @Phone,
	@Phone2, @Email, @Salesman,	@Admin, @CoverageType, @Coverage, @TermMonth, @TermMiles,
	@DeductAmt, @Class,	@PurchOdom,	@ExpOdom, @TotalPremiumAmt,	@SalesTaxAmt, @PayPlan,
	@FinanceFeeAmt,	@PaymentAmt, @NumPayments, @DownPaymentAmt,	@FinanceCompany, @FinanceNum, @FinancedAmt,
	@FirstBillDt, @GrossProfitAmt, @NetProfitAmt, @ReleaseDt, @ContractCostAmt, @DiscountAmt, @DisbursementAmt,
	@FundingToEntityAmt, @ReserveAmt, @EffectiveDt,	@ExpireDt, @Cancelled, @CancelDt, @InstallmentsMade,
	@LastPaymentRcvdDt;

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
		-- ContractId,

	Print @TermMonth;

	INSERT [Car].[Contract] (
	AppNum, ContractNum, VolunteerId_Open, VolunteerId_Sale, VolunteerId_TO, VolunteerId_TA, InsuredName, FirstName, LastName,
	Address, City, State, Zip, Phone, Phone2, Email, SaleDt, RateDt, Vin, Make, Model, Year, NewOrUsed,
	Coverage, Term, TermMonth, TermMiles, DeductAmt, Class, Admin, CoverageType, FinanceId, PurchOdom, ExpOdom,
	ExpireDt, TotalPremiumAmt, SalesTaxAmt,	PayPlan, FinanceFeeAmt,
	PaymentAmt, NumPayments, DownPaymentAmt,
	FinanceCompany, FinanceNum, FinancedAmt, FirstBillDt, ContractCostAmt,
	DiscountAmt, DisbursementAmt, FundingToEntityAmt, ReserveAmt, EffectiveDt,
	InstallmentsMade, LastPaymentRcvdDt, 
	IsCancelled, CancelDt )

-- RetailPlusPlusAmt,RetailAmt, CustomerCostAmt,
	 
--	  PaidInFull, PayPlanType, GrossProfitAmt, NetProfitAmt, ReleaseDt,  CancelReturnAmt)

-- @AcctNum
	VALUES ( @AppNum, @ContractNum, @VolunteerId_Open, @VolunteerId_Sale, @VolunteerId_TO, @VolunteerId_TA, @InsuredName, @FirstName, @LastName,
			@Address, @City, @State, @Zip, @Phone, @Phone2, @Email,	@SaleDt, @RateDt, @Vin, @Make, @Model, @Year, @NewOrUsed,
			@Coverage, 'Term', @TermMonth, @TermMiles, @DeductAmt, @Class, @Admin, @CoverageType, @FinanceId, @PurchOdom, @ExpOdom,
			@ExpireDt, @TotalPremiumAmt, @SalesTaxAmt, @PayPlan, @FinanceFeeAmt,
			@PaymentAmt, @NumPayments, @DownPaymentAmt,
			@FinanceCompany, @FinanceNum, @FinancedAmt, @FirstBillDt, @ContractCostAmt,
			@DiscountAmt, @DisbursementAmt, @FundingToEntityAmt, @ReserveAmt, @EffectiveDt,
			@InstallmentsMade, @LastPaymentRcvdDt, 
			@Cancelled, @CancelDt );

			
/*
			 @DeductAmt,

			@Salesman,
		     	  
		 @GrossProfitAmt, @NetProfitAmt, @ReleaseDt,   
		  	 
		)
*/

	FETCH NEXT FROM Contract_cursor INTO
	@AppNum, @AcctNum, @ContractNum, @SaleDt, @RateDt, @Vin, @Make, @Model, @Year,
	@NewOrUsed, @FirstName, @LastName, @InsuredName, @Address, @City, @State, @Zip, @Phone,
	@Phone2, @Email, @Salesman,	@Admin, @CoverageType, @Coverage, @TermMonth, @TermMiles,
	@DeductAmt, @Class,	@PurchOdom,	@ExpOdom, @TotalPremiumAmt,	@SalesTaxAmt, @PayPlan,
	@FinanceFeeAmt,	@PaymentAmt, @NumPayments, @DownPaymentAmt,	@FinanceCompany, @FinanceNum, @FinancedAmt,
	@FirstBillDt, @GrossProfitAmt, @NetProfitAmt, @ReleaseDt, @ContractCostAmt, @DiscountAmt, @DisbursementAmt,
	@FundingToEntityAmt, @ReserveAmt, @EffectiveDt,	@ExpireDt, @Cancelled, @CancelDt, @InstallmentsMade,
	@LastPaymentRcvdDt;

	END   

	CLOSE Contract_cursor;
	DEALLOCATE Contract_cursor;

-- END
