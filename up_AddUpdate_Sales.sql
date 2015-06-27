
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
		@log_surTu@log_rbo	[char](1),
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

--	select @AppNum;

	SELECT	@log_conNumber = conNumber,	@log_custLastName = custLastName, @log_custFirstName = custFirstName
			@log_vin = vin, @log_year = year, @log_make = make, @log_model = model, @log_rateDate = rateDate,
			@log_neworused = neworused, @log_coverage = coverage, @log_termmonth = termmonth, @log_termmiles = termmiles,
			@log_deduct = deduct, @log_class = class, @log_purchdate = purchdate, @log_expdate = expdate, @log_purchodom = purchodom,
			@log_expodom = expodom, @log_retail = retail, @log_cuscost = cuscost, @log_dlrcost = dlrcost, @log_salesman = salesman,
		@log_usr			[varchar](20),
		@log_sur4wd			[char](1),
		@log_surTu@log_rbo	[char](1),
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




	FROM tmp_SalesLog
	WHERE appNumber = @AppNum;

	select @log_conNumber, @log_custLastName;

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