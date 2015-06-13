 /*
 select * from Acct.Acct
 where AppNum = '5123947737'
 
 select * from Acct.Acct
 where Vin is null;
 */
-- select * from CarData.Car where Vin = '1GNKVGED9BJ413022'

exec [dbo].[up_Add_Acct]
	@AppNum				= '5123947737',
	@FirstName			= 'Rosa',
	@LastName			= 'Davidson',
	@AcctNum			= NULL,
	@PolicyNum	 		= 'SAF037236',
	@SerialNum			= NULL,
	@InsuredName		= NULL,
	@Vin				= 'KNAGE124285169034',
	@AdminName			= 'SUNPATH',
	@PaymentAmt			= 0,
	@NumPayments		= 0,
	@PolicyTerm			= '60/60',
	@CoverageType		= 'NAMED',
	@Coverage			= 'SPSAGU',
	@TotalPremiumAmt	= 2370,
	@DownPaymentAmt		= 0,
	@FinancedAmt		= 0,			-- maybe we oughta keep some sort of Finance column like they do ???
	@SellerCostAmt		= NULL,
	@DiscountAmt		= NULL,
	@DisbursementAmt	= NULL,
	@FundingToEntityAmt	= NULL,
	@ReserveAmt			= NULL,
	@CreateDt			= '6/04/2015',
	@EffectiveDt		= NULL,
	@FirstDueDt			= NULL,
	@ReleaseDt			= NULL,
	@Cancelled			= NULL,
	@CancelDt			= NULL,
	@Make				= 'KIA',
	@Model				= 'OPTIMA',
	@Year				= '2008',
	@ExpireDt			= '7/03/2020',
	@Salesman			= NULL,
	@Admin				= NULL,			-- dont need to update as already on file
	@Address			= '16812 Luckenwald Dr',
	@City				= 'Round Rock',
	@State				= 'TX',
	@Zip				= '78681-5307',
	@Phone				= '5123947737',
	@Phone2				= '5129235429',
	@Email				= 'beewell@austin.rr.com',
	@Odom				= 55433
;
