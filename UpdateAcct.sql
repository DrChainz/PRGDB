/*
select * from Acct.Acct
where FirstName is null


where FirstDueDt is NULL
  and FinancedAmt <> 0

select AppNum, FirstDueDt, Odom
from Acct.Acct
where FirstDueDt is NULL
*/

exec [dbo].[up_Add_Acct]
	@AppNum				= '8452906929',
	@FirstName			= 'Clinton',
	@LastName			= 'Bullock',
	@AcctNum			= NULL,
	@PolicyNum	 		= '',
	@SerialNum			= NULL,
	@InsuredName		= NULL,
	@Vin				= '2C4RDGDG4CR123225',
	@AdminName			= 'AASB',
	@PaymentAmt			= 149.50,
	@NumPayments		= 18,
	@PolicyTerm			= '60/100',
	@CoverageType		= 'EXCLUSION',
	@Coverage			= 'ABDIAM',
	@TotalPremiumAmt	= 2986,
	@DownPaymentAmt		= 295,
	@FinancedAmt		= 2691,			-- maybe we oughta keep some sort of Finance column like they do ???
	@SellerCostAmt		= NULL,
	@DiscountAmt		= NULL,
	@DisbursementAmt	= NULL,
	@FundingToEntityAmt	= NULL,
	@ReserveAmt			= NULL,
	@CreateDt			= '5/19/2015',
	@EffectiveDt		= NULL,
	@FirstDueDt			= NULL,
	@ReleaseDt			= NULL,
	@Cancelled			= NULL,
	@CancelDt			= NULL,
	@Make				= 'DODG',
	@Model				= 'GRAND CREW CARAVAN',
	@Year				= '2012',
	@ExpireDt			= '6/17/2020',
	@Salesman			= NULL,
	@Admin				= NULL,			-- dont need to update as already on file
	@Address			= '12 Wood St',
	@City				= 'Spring Valley',
	@State				= 'NY',
	@Zip				= '10977-5144',
	@Phone				= '845-290-6929',
	@Phone2				= '',
	@Email				= '',
	@Odom				= 29381
;
