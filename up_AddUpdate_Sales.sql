
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

DECLARE @AppNum				[char](10),
		@AcctNum			[char](15),
		@ContractNum		[varchar](10),
		@SaleDt				[smalldatetime],
		@RateDt				[smalldatetime],
		@Vin				[char](17),
		@Make				[varchar](20),
		@Model				[varchar](30),
		@Year				[char](4),
		@NewOrUsed			[char](1),
		@FirstName			[varchar](20),
		@LastName			[varchar](30),
		@InsuredName		[varchar](50),
		@Address			[varchar](50),
		@City				[varchar](30),
		@State				[char](2),
		@Zip				[varchar](10),
		@Phone				[varchar](10),
		@Phone2				[varchar](10),
		@Email				[varchar](50),
		@Salesman			[varchar](10),
		@Admin				[varchar](10),
		@CoverageType		[varchar](10),
		@Coverage			[varchar](10),
		@TermMonth			[smallint],
		@TermMiles			[int],
		@Deduct				[money],
		@Class				[varchar](10),
		@PurchOdom			[int],
		@ExpOdom			[int],
		@TotalPremiumAmt	[money],
		@SalesTaxAmt		[money],
		@PayPlan			[varchar](10),
		@FinanceFeeAmt		[money],
		@PaymentAmt			[money],
		@NumPayments		[smallint],
		@DownPaymentAmt		[money],
		@FinanceCompany		[varchar](10),
		@FinanceNum			[varchar](10),
		@FinancedAmt		[money],
		@FirstBillDt		[smalldatetime],
		@GrossProfitAmt		[money],
		@NetProfitAmt		[money],
		@ReleaseDt			[smalldatetime],
		@ContractCostAmt	[money],
		@DiscountAmt		[money],
		@DisbursementAmt	[money],
		@FundingToEntityAmt	[money],
		@ReserveAmt			[money],
		@EffectiveDt		[smalldatetime],
		@ExpireDt			[smalldatetime],
		@Cancelled			[char](1),
		@CancelDt			[smalldatetime],
		@InstallmentsMade	[smallint],
		@LastPaymentRcvdDt	[smalldatetime];

DECLARE @log_appNumber		[varchar](30),
		@log_conNumber		[varchar](20),
		@log_custLastName	[varchar](30),
		@log_custFirstName	[varchar](20),
		@log_vin			[varchar](20),
		@log_year			[char](4),
		@log_make			[varchar](20),
		@log_model			[varchar](30),
		@log_rateDate		[smalldatetime],
		@log_neworused		[char](1),
		@log_coverage		[varchar](20),
		@log_termmonth		[smallint],
		@log_termmiles		[int],
		@log_deduct			[money],
		@log_class			[varchar](10),
		@log_purchdate		[smalldatetime],
		@log_expdate		[smalldatetime],
		@log_purchodom		[int],
		@log_expodom		[int],
		@log_retail			[money],
		@log_cuscost		[money],
		@log_dlrcost		[money],
		@log_salesman		[varchar](30),
		@log_usr			[varchar](20),
		@log_sur4wd			[char](1),
		@log_surTurbo		[char](1),
		@log_surDiesel		[char](1),
		@log_surOneTon		[char](1),
		@log_surTenCyl		[char](1),
		@log_surDRW			[char](1),
		@log_surBus			[char](1),
		@log_surCom			[char](1),
		@log_surConVan		[char](1),
		@log_surMBG			[char](1),
		@log_finflag		[varchar](10),
		@log_finfee			[varchar](20),
		@log_finterm		[varchar](20),
		@log_fincomp		[varchar](10),
		@log_downpay		[varchar](20),
		@log_listcode		[varchar](30),
		@log_promocode		[varchar](20),
		@log_paymeth1		[varchar](20),
		@log_paymeth2		[varchar](20),
		@log_grossprofit	[varchar](20),
		@log_netprofit		[varchar](30),
		@log_admincode		[varchar](20),
		@log_emailaddress	[varchar](60),
		@log_commission		[varchar](30),
		@log_FirstBillDate	[varchar](30),
		@log_paymentAmt		[varchar](30),
		@log_billday		[varchar](30),
		@log_CancelDate		[varchar](30),
		@log_CancelPostDate	[varchar](30),
		@log_admrefamt		[varchar](30),
		@log_SalesTax		[varchar](20),
		@log_AdmTransDt		[varchar](30),
		@log_FinTransDt		[varchar](30),
		@log_Fronter		[varchar](30),
		@log_xTime			[varchar](20),
		@log_xTO			[varchar](30),
		@log_Verifier		[varchar](30),
		@log_FinNumber		[varchar](10),
		@log_Phone2			[varchar](20),
		@log_surGPS			[varchar](10),
		@log_surEMI			[varchar](10),
		@log_surAV			[varchar](10),
		@log_surWT			[varchar](10),
		@log_surSG			[varchar](10),
		@log_idays			[varchar](10),
		@log_iodom			[varchar](20),
		@log_canrefpct		[varchar](20);

DECLARE @IsUpdate bit = 0;
DECLARE @UpdateCnt int = 0;

DECLARE acct_cursor CURSOR FOR  
SELECT	AppNum, AcctNum, ContractNum, SaleDt, RateDt, Vin, Make, Model, Year, NewOrUsed,
		FirstName,	LastName, InsuredName, Address, City, State, Zip, Phone, Phone2, Email,
		Salesman, Admin, CoverageType, Coverage, TermMonth, TermMiles, Deduct, Class, PurchOdom,
		ExpOdom, TotalPremiumAmt, SalesTaxAmt, PayPlan,	FinanceFeeAmt, PaymentAmt, NumPayments,
		DownPaymentAmt, FinanceCompany, FinanceNum, FinancedAmt, FirstBillDt, GrossProfitAmt,
		NetProfitAmt, ReleaseDt, ContractCostAmt, DiscountAmt, DisbursementAmt, FundingToEntityAmt,
		ReserveAmt, EffectiveDt, ExpireDt, Cancelled, CancelDt, InstallmentsMade, LastPaymentRcvdDt
FROM [Acct].[Acct];


/*
*/

OPEN acct_cursor   
FETCH NEXT FROM acct_cursor INTO
		@AppNum, @AcctNum, @ContractNum, @SaleDt, @RateDt, @Vin, @Make,	@Model, @Year, @NewOrUsed,
		@FirstName,	@LastName, @InsuredName, @Address, @City, @State, @Zip, @Phone, @Phone2, @Email,
		@Salesman, @Admin, @CoverageType, @Coverage, @TermMonth, @TermMiles, @Deduct, @Class, @PurchOdom,
		@ExpOdom, @TotalPremiumAmt, @SalesTaxAmt, @PayPlan,	@FinanceFeeAmt,	@PaymentAmt, @NumPayments,
		@DownPaymentAmt, @FinanceCompany, @FinanceNum, @FinancedAmt, @FirstBillDt, @GrossProfitAmt,
		@NetProfitAmt, @ReleaseDt, @ContractCostAmt, @DiscountAmt, @DisbursementAmt, @FundingToEntityAmt,
		@ReserveAmt, @EffectiveDt, @ExpireDt, @Cancelled, @CancelDt, @InstallmentsMade, @LastPaymentRcvdDt;


WHILE @@FETCH_STATUS = 0   
BEGIN   
	SET @IsUpdate = 0;
--	select @AppNum;

	SELECT	@log_conNumber = conNumber,	@log_custLastName = custLastName, @log_custFirstName = custFirstName,
			@log_vin = vin, @log_year = year, @log_make = make, @log_model = model, @log_rateDate = rateDate,
			@log_neworused = neworused, @log_coverage = coverage, @log_termmonth = termmonth, @log_termmiles = termmiles,
			@log_deduct = deduct, @log_class = class, @log_purchdate = purchdate, @log_expdate = expdate, @log_purchodom = purchodom,
			@log_expodom = expodom, @log_retail = retail, @log_cuscost = cuscost, @log_dlrcost = dlrcost, @log_salesman = salesman,
			@log_usr = usr,	@log_sur4wd = sur4wd, @log_surTurbo = surTurbo, @log_surDiesel = surDiesel, @log_surOneTon = surOneTon,
			@log_surTenCyl = surTenCyl,	@log_surDRW = surDRW, @log_surBus = surBus, @log_surCom = surCom, @log_surConVan = surConVan,
			@log_surMBG = surMBG, @log_finflag = finflag, @log_finfee = finfee,	@log_finterm = finterm, @log_fincomp = fincomp,
			@log_downpay = downpay, @log_listcode = listcode, @log_promocode = promocode, @log_paymeth1 = paymeth1, @log_paymeth2 = paymeth2,
			@log_grossprofit = grossprofit, @log_netprofit = netprofit, @log_admincode = admincode, @log_emailaddress = emailaddress,
			@log_commission = commission, @log_FirstBillDate = FirstBillDate, @log_paymentAmt = paymentAmt, @log_billday = billday,
			@log_CancelDate = CancelDate, @log_CancelPostDate = CancelPostDate, @log_admrefamt = admrefamt, @log_SalesTax = SalesTax,
			@log_AdmTransDt = AdmTransDt, @log_FinTransDt = FinTransDt, @log_Fronter = Fronter, @log_xTime = xTime,	@log_xTO = xTO,
			@log_Verifier = Verifier, @log_FinNumber = FinNumber, @log_Phone2 = Phone2, @log_surGPS = surGPS, @log_surEMI = surEMI,
			@log_surAV = surAV, @log_surWT = surWT, @log_surSG = surSG, @log_idays = idays, @log_iodom = iodom, @log_canrefpct = canrefpct
	FROM tmp_SalesLog
	WHERE appNumber = @AppNum;

	IF ((@ContractNum IS NULL OR @ContractNum = '') AND (@log_conNumber IS NOT NULL AND @log_conNumber <> ''))
	BEGIN
		SET @ContractNum = @log_conNumber
		SET @IsUpdate = 1;
	END

	IF ((@LastName IS NULL OR @LastName = '') AND (@log_custLastName IS NOT NULL AND @log_custLastName <> ''))
	BEGIN
		SET @LastName = @log_custLastName;
		SET @IsUpdate = 1;
	END

	IF ((@FirstName IS NULL OR @FirstName = '') AND (@log_custFirstName IS NOT NULL AND @log_custFirstName <> ''))
	BEGIN
		SET @FirstName = @log_custFirstName;
		SET @IsUpdate = 1;
	END

	IF ((@Vin IS NULL OR @Vin = '') AND (@log_Vin IS NOT NULL AND @log_Vin <> ''))
	BEGIN
		SET @Vin = @log_Vin;
		SET @IsUpdate = 1;
	END

	IF ((@Year IS NULL OR @Year = '') AND (@log_Year IS NOT NULL AND @log_Year <> ''))
	BEGIN
		SET @Year = @log_Year;
		SET @IsUpdate = 1;
	END

	IF ((@Make IS NULL OR @Make = '') AND (@log_Make IS NOT NULL AND @log_Make <> ''))
	BEGIN
		SET @Make = @log_Make;
		SET @IsUpdate = 1;
	END

	IF ((@Model IS NULL OR @Model = '') AND (@log_Model IS NOT NULL AND @log_Model <> ''))
	BEGIN
		SET @Model = @log_Model;
		SET @IsUpdate = 1;
	END

	IF ((@RateDt IS NULL OR @RateDt = '') AND (@log_ratedate IS NOT NULL AND @log_ratedate <> ''))
	BEGIN
		SET @RateDt = @log_ratedate;
		SET @IsUpdate = 1;
	END

	IF ((@NewOrUsed IS NULL OR @NewOrUsed = '') AND (@log_neworused IS NOT NULL AND @log_neworused <> ''))
	BEGIN
		SET @NewOrUsed = @log_neworused;
		SET @IsUpdate = 1;
	END

	IF ((@Coverage IS NULL OR @Coverage = '') AND (@log_coverage IS NOT NULL AND @log_coverage <> ''))
	BEGIN
		SET @Coverage = @log_coverage;
		SET @IsUpdate = 1;
	END

	IF ((@TermMonth IS NULL OR @TermMonth = '') AND (@log_termmonth IS NOT NULL AND @log_termmonth <> ''))
	BEGIN
		SET @TermMonth = @log_termmonth;
		SET @IsUpdate = 1;
	END

	IF ((@TermMiles IS NULL OR @TermMiles = '') AND (@log_termmiles IS NOT NULL AND @log_termmiles <> ''))
	BEGIN
		SET @TermMiles = @log_termmiles;
		SET @IsUpdate = 1;
	END

	IF ((@Deduct IS NULL OR @Deduct = '') AND (@log_deduct IS NOT NULL AND @log_deduct <> ''))
	BEGIN
		SET @Deduct = @log_deduct;
		SET @IsUpdate = 1;
	END

	IF ((@Class IS NULL OR @Class = '') AND (@log_class IS NOT NULL AND @log_class <> ''))
	BEGIN
		SET @Class = @log_class;
		SET @IsUpdate = 1;
	END

	IF ((@SaleDt IS NULL OR @SaleDt = '') AND (@log_purchdate IS NOT NULL AND @log_purchdate <> ''))
	BEGIN
		SET @SaleDt = @log_purchdate;
		SET @IsUpdate = 1;
	END
	
	IF ((@ExpireDt IS NULL OR @ExpireDt = '') AND (@log_expdate IS NOT NULL AND @log_expdate <> ''))
	BEGIN
		SET @ExpireDt = @log_expdate;
		SET @IsUpdate = 1;
	END

	IF ((@PurchOdom IS NULL OR @PurchOdom = '') AND (@log_purchodom IS NOT NULL AND @log_purchodom <> ''))
	BEGIN
		SET @PurchOdom = @log_purchodom;
		SET @IsUpdate = 1;
	END

	IF ((@ExpOdom IS NULL OR @ExpOdom = '') AND (@log_expodom IS NOT NULL AND @log_expodom <> ''))
	BEGIN
		SET @ExpOdom = @log_expodom;
		SET @IsUpdate = 1;
	END

	IF ((@TotalPremiumAmt IS NULL OR @TotalPremiumAmt = '') AND (@log_cuscost IS NOT NULL AND @log_cuscost <> ''))
	BEGIN
		SET @TotalPremiumAmt = @log_cuscost;
		SET @IsUpdate = 1;
	END

	IF ((@ContractCostAmt IS NULL OR @ContractCostAmt = '') AND (@log_dlrcost IS NOT NULL AND @log_dlrcost <> ''))
	BEGIN
	-- [FundingToEntityAmt]
		SET @ContractCostAmt = @log_dlrcost;
		SET @IsUpdate = 1;
	END

	IF ((@Salesman IS NULL OR @Salesman = '') AND (@log_salesman IS NOT NULL AND @log_salesman <> ''))
	BEGIN
		SET @Salesman = @log_salesman;
		SET @IsUpdate = 1;
	END

	IF ((@Salesman IS NULL OR @Salesman = '') AND (@log_salesman IS NOT NULL AND @log_salesman <> ''))
	BEGIN
		SET @Salesman = @log_salesman;
		SET @IsUpdate = 1;
	END

	IF ((@DownPaymentAmt IS NULL OR @DownPaymentAmt = '') AND (@log_downpay IS NOT NULL AND @log_downpay <> ''))
	BEGIN
		SET @DownPaymentAmt = @log_downpay;
		SET @IsUpdate = 1;
	END

	IF ((@FinanceCompany IS NULL OR @FinanceCompany = '') AND (@log_fincomp IS NOT NULL AND @log_fincomp <> ''))
	BEGIN
		SET @FinanceCompany = @log_fincomp;
		SET @IsUpdate = 1;
	END

	IF ((@NumPayments IS NULL OR @NumPayments = '') AND (@log_finterm IS NOT NULL AND @log_finterm <> ''))
	BEGIN
		SET @NumPayments = @log_finterm;
		SET @IsUpdate = 1;
	END

	IF ((@FinancedAmt IS NULL OR @FinancedAmt = '') AND (@log_finfee IS NOT NULL AND @log_finfee <> ''))
	BEGIN
		SET @FinancedAmt = @log_finfee;
		SET @IsUpdate = 1;
	END

	IF ((@NetProfitAmt IS NULL OR @NetProfitAmt = '') AND (@log_netprofit IS NOT NULL AND @log_netprofit <> ''))
	BEGIN
		SET @NetProfitAmt = @log_netprofit;
		SET @IsUpdate = 1;
	END

	IF ((@GrossProfitAmt IS NULL OR @GrossProfitAmt = '') AND (@log_grossprofit IS NOT NULL AND @log_grossprofit <> ''))
	BEGIN
		SET @GrossProfitAmt = @log_grossprofit;
		SET @IsUpdate = 1;
	END

	IF ((@Admin IS NULL OR @Admin = '') AND (@log_admincode IS NOT NULL AND @log_admincode <> ''))
	BEGIN
		SET @Admin = @log_admincode;
		SET @IsUpdate = 1;
	END

	IF ((@Email IS NULL OR @Email = '') AND (@log_emailaddress IS NOT NULL AND @log_emailaddress <> ''))
	BEGIN
		SET @Email = @log_emailaddress;
		SET @IsUpdate = 1;
	END

	IF ((@CancelDt IS NULL OR @CancelDt = '') AND (@log_CancelDate IS NOT NULL AND @log_CancelDate <> ''))
	BEGIN
		SET @CancelDt = @log_CancelDate;
		SET @IsUpdate = 1;
	END

	IF ((@PaymentAmt IS NULL OR @PaymentAmt = '') AND (@log_paymentAmt IS NOT NULL AND @log_paymentAmt <> ''))
	BEGIN
		SET @PaymentAmt = @log_paymentAmt;
		SET @IsUpdate = 1;
	END

	IF ((@FirstBillDt IS NULL OR @FirstBillDt = '') AND (@log_FirstBillDate IS NOT NULL AND @log_FirstBillDate <> ''))
	BEGIN
		SET @FirstBillDt = @log_FirstBillDate;
		SET @IsUpdate = 1;
	END

	IF ((@SalesTaxAmt IS NULL OR @SalesTaxAmt = '') AND (@log_SalesTax IS NOT NULL AND @log_SalesTax <> ''))
	BEGIN
		SET @SalesTaxAmt = @log_SalesTax;
		SET @IsUpdate = 1;
	END


[]


-- AdmTransDt	FinTransDt
/*
	IF ((@AdmTransDt IS NULL OR @AdmTransDt = '') AND (@log_AdmTransDt IS NOT NULL AND @log_AdmTransDt <> ''))
	BEGIN
		SET @AdmTransDt = @log_AdmTransDt;
		SET @IsUpdate = 1;
	END

	IF ((@FinTransDt IS NULL OR @FinTransDt = '') AND (@log_FinTransDt IS NOT NULL AND @log_FinTransDt <> ''))
	BEGIN
		SET @FinTransDt = @log_FinTransDt;
		SET @IsUpdate = 1;
	END


*/


/*
-- 		@log_retail			[money],

		@log_finflag		[varchar](10),
		@log_promocode		[varchar](20),
		@log_paymeth1		[varchar](20),
		@log_paymeth2		[varchar](20),

		@log_commission		[varchar](30),
			[varchar](30),
		@log_billday		[varchar](30),

		@log_CancelPostDate	[varchar](30),
		@log_admrefamt		[varchar](30),
				[varchar](20),

		@log_Fronter		[varchar](30),
		@log_xTime			[varchar](20),
		@log_xTO			[varchar](30),
		@log_Verifier		[varchar](30),
		@log_FinNumber		[varchar](10),
		@log_Phone2			[varchar](20),
		@log_idays			[varchar](10),
		@log_iodom			[varchar](20),
		@log_canrefpct		[varchar](20);
*/

	-------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------
	IF (@IsUpDate = 1)
	BEGIN
		SET @UpdateCnt += 1;
		PRINT 'Update: ' + @AppNum + ' Cnt: ' + cast(@UpdateCnt as char(10));
	END

/*
	select	@log_conNumber, @log_custLastName, @log_custFirstName, @log_vin, @log_year, @log_make, @log_model, @log_rateDate,
			@log_neworused, @log_coverage, @log_termmonth, @log_termmiles,
			@log_deduct, @log_class, @log_purchdate, @log_expdate, @log_purchodom,
			@log_expodom, @log_retail, @log_cuscost, @log_dlrcost, @log_salesman,
			@log_usr,	@log_sur4wd, @log_surTurbo, @log_surDiesel, @log_surOneTon,
			@log_surTenCyl,	@log_surDRW, @log_surBus, @log_surCom, @log_surConVan,
			@log_surMBG, @log_finflag, @log_finfee,	@log_finterm, @log_fincomp,
			@log_downpay, @log_listcode, @log_promocode, @log_paymeth1, @log_paymeth2,
			@log_grossprofit, @log_netprofit, @log_admincode, @log_emailaddress,
			@log_commission, @log_FirstBillDate, @log_paymentAmt, @log_billday,
			@log_CancelDate, @log_CancelPostDate, @log_admrefamt, @log_SalesTax,
			@log_AdmTransDt, @log_FinTransDt, @log_Fronter, @log_xTime,	@log_xTO,
			@log_Verifier, @log_FinNumber, @log_Phone2, @log_surGPS, @log_surEMI,
			@log_surAV, @log_surWT, @log_surSG, @log_idays, @log_iodom, @log_canrefpct;
*/

/*
	select *
	FROM tmp_SalesLog
	WHERE appNumber = @AppNum;

*/



FETCH NEXT FROM acct_cursor INTO
		@AppNum, @AcctNum, @ContractNum, @SaleDt, @RateDt, @Vin, @Make,	@Model, @Year, @NewOrUsed,
		@FirstName,	@LastName, @InsuredName, @Address, @City, @State, @Zip, @Phone, @Phone2, @Email,
		@Salesman, @Admin, @CoverageType, @Coverage, @TermMonth, @TermMiles, @Deduct, @Class, @PurchOdom,
		@ExpOdom, @TotalPremiumAmt, @SalesTaxAmt, @PayPlan,	@FinanceFeeAmt,	@PaymentAmt, @NumPayments,
		@DownPaymentAmt, @FinanceCompany, @FinanceNum, @FinancedAmt, @FirstBillDt, @GrossProfitAmt,
		@NetProfitAmt, @ReleaseDt, @ContractCostAmt, @DiscountAmt, @DisbursementAmt, @FundingToEntityAmt,
		@ReserveAmt, @EffectiveDt, @ExpireDt, @Cancelled, @CancelDt, @InstallmentsMade, @LastPaymentRcvdDt;
END   

CLOSE acct_cursor   
DEALLOCATE acct_cursor

GO

exec up_AddUpdate_Sales;