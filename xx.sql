USE [PrivateReserve]
GO

IF OBJECT_ID(N'up_updateAcct_rptSalesLog') IS NOT NULL
	DROP PROC up_updateAcct_rptSalesLog;
GO

CREATE PROC up_updateAcct_rptSalesLog
			@ClearAll	char(1) = 'N'
AS

DECLARE
	@appNumber	[varchar](30),
	@conNumber [varchar](20),
	@custLastName [varchar](30),
	@custFirstName [varchar](20),
	@vin [varchar](20),
	@year [char](4),
	@make [varchar](20),
	@model [varchar](30),
	@rateDate [smalldatetime],
	@neworused [char](1),
	@coverage [varchar](20),
	@termmonth [smallint],
	@termmiles [int],
	@deduct [money],
	@class [varchar](10),
	@purchdate [smalldatetime],
	@expdate [smalldatetime],
	@purchodom [int],
	@expodom [int],
	@retail [money],
	@cuscost [money],
	@dlrcost [money],
	@salesman [varchar](30),
	@usr [varchar](20),
	@sur4wd [char](1),
	@surTurbo [char](1),
	@surDiesel [char](1),
	@surOneTon [char](1),
	@surTenCyl [char](1),
	@surDRW [char](1),
	@surBus [char](1),
	@surCom [char](1),
	@surConVan [char](1),
	@surMBG [char](1),
	@finflag [varchar](10),
	@finfee [varchar](20),
	@finterm [varchar](20),
	@fincomp [varchar](10),
	@downpay [varchar](20),
	@listcode [varchar](30),
	@promocode [varchar](20),
	@paymeth1 [varchar](20),
	@paymeth2 [varchar](20),
	@grossprofit [varchar](20),
	@netprofit [varchar](30),
	@admincode [varchar](20),
	@emailaddress [varchar](60),
	@commission [varchar](30),
	@FirstBillDate [varchar](30),
	@paymentAmt [varchar](30),
	@billday [varchar](30),
	@CancelDate [varchar](30),
	@CancelPostDate [varchar](30),
	@admrefamt [varchar](30),
	@SalesTax [varchar](20),
	@AdmTransDt [varchar](30),
	@FinTransDt [varchar](30),
	@Fronter [varchar](30),
	@xTime [varchar](20),
	@xTO [varchar](30),
	@Verifier [varchar](30),
	@FinNumber [varchar](10),
	@Phone2 [varchar](20),
	@surGPS [varchar](10),
	@surEMI [varchar](10),
	@surAV [varchar](10),
	@surWT [varchar](10),
	@surSG [varchar](10),
	@idays [varchar](10),
	@iodom [varchar](20),
	@canrefpct [varchar](20);

INSERT [Acct].[Acct](AppNum)
SELECT AppNumber FROM tmp_SalesLog WHERE AppNumber NOT IN (SELECT AppNum FROM [Acct].[Acct]);

IF (@ClearAll = 'Y')
BEGIN
	TRUNCATE TABLE [Acct].[Acct];
-- 	UPDATE [Acct].[Acct] SET Make = NULL, Model = NULL, Year = NULL;
END


DECLARE log_cursor CURSOR FOR
	SELECT
	appNumber,	conNumber,	custLastName,	custFirstName,	vin, year, make, model,	 rateDate,  neworused, coverage, termmonth,
	termmiles,	deduct, class, purchdate, expdate, purchodom, expodom, retail, cuscost, dlrcost, salesman, usr, sur4wd,
	surTurbo, surDiesel, surOneTon, surTenCyl, surDRW, surBus, surCom, surConVan, surMBG, finflag, finfee, finterm, fincomp,
	downpay, listcode, promocode, paymeth1, paymeth2, grossprofit, netprofit, admincode, emailaddress, commission, FirstBillDate,
	paymentAmt, billday, CancelDate, CancelPostDate, admrefamt, SalesTax, AdmTransDt, FinTransDt, Fronter, xTime, xTO, Verifier,
	FinNumber, Phone2, surGPS, surEMI, surAV, surWT, surSG, idays, iodom, canrefpct
	FROM tmp_SalesLog;

OPEN log_cursor
FETCH NEXT  FROM log_cursor INTO 
	@appNumber,	@conNumber,	@custLastName,	@custFirstName,	@vin, @year, @make,	@model,	@rateDate, @neworused, @coverage, @termmonth,
	@termmiles,	@deduct, @class, @purchdate, @expdate, @purchodom, @expodom, @retail, @cuscost, @dlrcost, @salesman, @usr, @sur4wd,
	@surTurbo, @surDiesel, @surOneTon, @surTenCyl, @surDRW, @surBus, @surCom, @surConVan, @surMBG, @finflag, @finfee, @finterm, @fincomp,
	@downpay, @listcode, @promocode, @paymeth1, @paymeth2, @grossprofit, @netprofit, @admincode, @emailaddress, @commission, @FirstBillDate,
	@paymentAmt, @billday, @CancelDate, @CancelPostDate, @admrefamt, @SalesTax, @AdmTransDt, @FinTransDt, @Fronter, @xTime, @xTO, @Verifier,
	@FinNumber, @Phone2, @surGPS, @surEMI, @surAV, @surWT, @surSG, @idays, @iodom, @canrefpct;


WHILE @@FETCH_STATUS = 0
BEGIN

	declare @ContractNum varchar(10) = (Select ContractNum FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@conNumber IS NOT NULL)) AND ((@ContractNum IS NULL))
		UPDATE Acct.Acct set ContractNum = @conNumber WHERE AppNum = @AppNumber;

	declare @acct_Vin char(17) = (Select Vin FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@vin IS NOT NULL)) AND ((@acct_vin IS NULL))
		UPDATE Acct.Acct set Vin = @vin WHERE AppNum = @AppNumber;

	declare @acct_Make char(20) = (Select Make FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@Make IS NOT NULL)) AND ((@acct_Make IS NULL))
		UPDATE Acct.Acct set Make = @Make WHERE AppNum = @AppNumber;
	
	declare @acct_Model char(30) = (Select Model FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@Model IS NOT NULL)) AND ((@acct_Model IS NULL))
		UPDATE Acct.Acct set Model = @Model WHERE AppNum = @AppNumber;

	declare @acct_Year char(4) = (Select Year FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@Year IS NOT NULL)) AND ((@acct_Year IS NULL))
		UPDATE Acct.Acct set Year = @Year WHERE AppNum = @AppNumber;

	declare @acct_SaleDt smalldatetime = (Select SaleDt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@purchdate IS NOT NULL)) AND ((@acct_SaleDt IS NULL))
		UPDATE Acct.Acct set SaleDt = @purchdate WHERE AppNum = @AppNumber;

	declare @acct_RateDt smalldatetime = (Select RateDt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@ratedate IS NOT NULL)) AND ((@acct_RateDt IS NULL))
		UPDATE Acct.Acct set RateDt = @ratedate WHERE AppNum = @AppNumber;

	declare @acct_NewOrUsed char(1) = (Select NewOrUsed FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@neworused IS NOT NULL)) AND ((@acct_NewOrUsed IS NULL))
		UPDATE Acct.Acct set NewOrUsed = @neworused WHERE AppNum = @AppNumber;

	declare @acct_FirstName varchar(20) = (Select FirstName FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@custFirstName IS NOT NULL)) AND ((@acct_FirstName IS NULL))
		UPDATE Acct.Acct set FirstName = @custFirstName WHERE AppNum = @AppNumber;

	declare @acct_LastName varchar(30) = (Select LastName FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@custLastName IS NOT NULL)) AND ((@acct_LastName IS NULL))
		UPDATE Acct.Acct set LastName = @custLastName WHERE AppNum = @AppNumber;

	declare @acct_Salesman varchar(10) = (Select Salesman FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@usr IS NOT NULL)) AND ((@acct_Salesman IS NULL))
		UPDATE Acct.Acct set Salesman = @usr WHERE AppNum = @AppNumber;

	declare @acct_Admin varchar(10) = (Select Admin FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@admincode IS NOT NULL)) AND ((@acct_Admin IS NULL))
		UPDATE Acct.Acct set Admin = @admincode WHERE AppNum = @AppNumber;

	declare @acct_TermMonth smallint = (Select TermMonth FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@termmonth IS NOT NULL)) AND ((@acct_TermMonth IS NULL))
		UPDATE Acct.Acct set TermMonth = @termmonth WHERE AppNum = @AppNumber;

	declare @acct_TermMiles int = (Select TermMiles FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@termmiles IS NOT NULL)) AND ((@acct_TermMiles IS NULL))
		UPDATE Acct.Acct set TermMiles = @termmiles WHERE AppNum = @AppNumber;

	declare @acct_Deduct money = (Select Deduct FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@deduct IS NOT NULL)) AND ((@acct_Deduct IS NULL))
		UPDATE Acct.Acct set Deduct = @deduct WHERE AppNum = @AppNumber;

	declare @acct_Class varchar(10) = (Select Class FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@class IS NOT NULL) AND (@acct_Class IS NULL))
		UPDATE Acct.Acct set Class = @Class WHERE AppNum = @AppNumber;

	declare @acct_PurchOdom int = (Select PurchOdom FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@purchodom IS NOT NULL)) AND ((@acct_PurchOdom IS NULL))
		UPDATE Acct.Acct set PurchOdom = @purchodom WHERE AppNum = @AppNumber;

	declare @acct_ExpOdom int = (Select ExpOdom FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@expodom IS NOT NULL AND @acct_ExpOdom IS NULL)
		UPDATE Acct.Acct set ExpOdom = @expodom WHERE AppNum = @AppNumber;

	declare @acct_TotalPremiumAmt money = (Select TotalPremiumAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@cuscost IS NOT NULL AND @acct_TotalPremiumAmt IS NULL)
		UPDATE Acct.Acct set TotalPremiumAmt = @cuscost WHERE AppNum = @AppNumber;

	declare @acct_SalesTaxAmt money = (Select SalesTaxAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@SalesTax IS NOT NULL AND @acct_SalesTaxAmt IS NULL)
		UPDATE Acct.Acct set SalesTaxAmt = @SalesTax WHERE AppNum = @AppNumber;

	declare @acct_SellCostAmt money = (Select SellerCostAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@dlrcost IS NOT NULL AND @acct_SellCostAmt IS NULL)
		UPDATE Acct.Acct set SellerCostAmt = @dlrcost WHERE AppNum = @AppNumber;

	declare @acct_PayPlan varchar(10) = (Select PayPlan FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@finflag IS NOT NULL AND @acct_PayPlan IS NULL)
		UPDATE Acct.Acct set PayPlan = @finflag WHERE AppNum = @AppNumber;

	declare @acct_FinanceFeeAmt money = (Select FinanceFeeAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@finfee IS NOT NULL AND @acct_FinanceFeeAmt IS NULL)
		UPDATE Acct.Acct set FinanceFeeAmt = @finfee WHERE AppNum = @AppNumber;

/*
	-- This data is blank in the report
	declare @acct_PaymentAmt money = (Select PaymentAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF ((@paymentAmt IS NOT NULL)) AND ((@acct_PaymentAmt IS NULL))
		UPDATE Acct.Acct set PaymentAmt = @paymentAmt WHERE AppNum = @AppNumber;
*/

	declare @acct_NumPayments smallint = (Select NumPayments FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@finterm IS NOT NULL AND @acct_NumPayments IS NULL)
		UPDATE Acct.Acct set NumPayments = @finterm WHERE AppNum = @AppNumber;

	declare @acct_DownPaymentAmt money = (Select DownPaymentAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@downpay IS NOT NULL AND @acct_NumPayments IS NULL)
		UPDATE Acct.Acct set DownPaymentAmt = @downpay WHERE AppNum = @AppNumber;

	declare @acct_Email varchar(60) = (Select Email FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@emailaddress IS NOT NULL AND @emailaddress <> '')
		UPDATE Acct.Acct set Email = @emailaddress WHERE AppNum = @AppNumber;

	declare @acct_FirstBillDt smalldatetime = (Select FirstBillDt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@FirstBillDate IS NOT NULL AND @acct_FirstBillDt IS NULL)
		UPDATE Acct.Acct set FirstBillDt = @FirstBillDate WHERE AppNum = @AppNumber;

	declare @acct_GrossProfitAmt money = (Select GrossProfitAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@grossprofit IS NOT NULL AND @acct_GrossProfitAmt IS NULL)
		UPDATE Acct.Acct set GrossProfitAmt = @grossprofit WHERE AppNum = @AppNumber;

	declare @acct_NetProfitAmt money = (Select NetProfitAmt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@netprofit IS NOT NULL AND @acct_NetProfitAmt IS NULL)
		UPDATE Acct.Acct set NetProfitAmt = @netprofit WHERE AppNum = @AppNumber;

	declare @acct_CancelDt smalldatetime = (Select CancelDt FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@CancelDate IS NOT NULL AND @CancelDate <> '' AND @acct_CancelDt IS NULL)
		UPDATE Acct.Acct set CancelDt = @CancelDate, Cancelled = 'Y' WHERE AppNum = @AppNumber;

	declare @acct_FinanceCompany varchar(10) = (Select FinanceCompany FROM Acct.Acct WHERE AppNum = @AppNumber) ;
	IF (@fincomp IS NOT NULL AND @fincomp <> '' AND @acct_FinanceCompany IS NULL)
		UPDATE Acct.Acct set FinanceCompany = @fincomp WHERE AppNum = @AppNumber;

	
-- [NumPayments]
-- 	FinanceFeeAmt
-- [PayPlan]
-- [TotalPremiumAmt]
-- 	IF () IS NULL OR (Select PolicyNum FROM Acct.Acct)

--------------------------------
-- last statement in while loop
--------------------------------
FETCH NEXT  FROM log_cursor INTO 
	@appNumber,	@conNumber,	@custLastName,	@custFirstName,	@vin, @year, @make,	@model,	@rateDate, @neworused, @coverage, @termmonth,
	@termmiles,	@deduct, @class, @purchdate, @expdate, @purchodom, @expodom, @retail, @cuscost, @dlrcost, @salesman, @usr, @sur4wd,
	@surTurbo, @surDiesel, @surOneTon, @surTenCyl, @surDRW, @surBus, @surCom, @surConVan, @surMBG, @finflag, @finfee, @finterm, @fincomp,
	@downpay, @listcode, @promocode, @paymeth1, @paymeth2, @grossprofit, @netprofit, @admincode, @emailaddress, @commission, @FirstBillDate,
	@paymentAmt, @billday, @CancelDate, @CancelPostDate, @admrefamt, @SalesTax, @AdmTransDt, @FinTransDt, @Fronter, @xTime, @xTO, @Verifier,
	@FinNumber, @Phone2, @surGPS, @surEMI, @surAV, @surWT, @surSG, @idays, @iodom, @canrefpct;
END

CLOSE log_cursor;
DEALLOCATE log_cursor;

GO

exec up_updateAcct_rptSalesLog 'N';