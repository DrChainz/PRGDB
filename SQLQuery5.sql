IF OBJECT_ID(N'up_UpdatePayments') IS NOT NULL
	DROP PROC up_UpdatePayments;
GO

CREATE PROC up_UpdatePayments
AS

UPDATE tmp_Payments SET InstallmentsMade = 0 WHERE InstallmentsMade = '';
UPDATE tmp_Payments SET LastPaymentReceivedDt = NULL WHERE LastPaymentReceivedDt = '--';
UPDATE tmp_Payments SET DisbAcctNum = substring(DisbursementPayee, 1, (CHARINDEX (' -', DisbursementPayee) - 1));

DECLARE @SNum					int,
		@InsuredName			varchar(50),
		@AcctNum				varchar(15),
		@ContractNum			varchar(10),
		@EffectiveDt			varchar(20),
		@FirstDueDt				varchar(20),
		@InstallmentsMade		varchar(30),
		@InstallmentsRemaining	varchar(30),
		@LastPaymentReceivedDt	varchar(20),
		@TotalPaymentAmt		varchar(30);

DECLARE	@Prev_InsuredName			varchar(50),
		@Prev_AcctNum				varchar(15),
		@Prev_ContractNum			varchar(10),
		@Prev_EffectiveDt			varchar(20),
		@Prev_FirstDueDt			varchar(20),
		@Prev_InstallmentsMade		varchar(30),
		@Prev_InstallmentsRemaining	varchar(30),
		@Prev_LastPaymentReceivedDt	varchar(20),
		@Prev_TotalPaymentAmt		varchar(30);
		

DECLARE payment_cursor CURSOR FOR  
SELECT	SNum, InsuredName, AcctNum, ContractNum, EffectiveDt, FirstDueDt, InstallmentsMade, InstallmentsRemaining, LastPaymentReceivedDt, TotalPaymentAmt
FROM tmp_Payments
FOR UPDATE;

OPEN payment_cursor
FETCH NEXT FROM payment_cursor
	INTO @SNum, @InsuredName, @AcctNum, @ContractNum, @EffectiveDt, @FirstDueDt,
		 @InstallmentsMade, @InstallmentsRemaining, @LastPaymentReceivedDt, @TotalPaymentAmt;

WHILE @@FETCH_STATUS = 0   
BEGIN   
	
	-- print cast(@SNum as varchar(10)) + ' ' + @InsuredName;

	IF ((@ContractNum IS NULL OR @ContractNum = '') AND (@Prev_ContractNum <> '' AND @Prev_ContractNum IS NOT NULL))
		UPDATE tmp_Payments
			SET InsuredName = @Prev_InsuredName,
				ContractNum = @Prev_ContractNum,
				AcctNum = @Prev_AcctNum,
--				AgentName = @Prev_AgentName,
				EffectiveDt = @Prev_EffectiveDt,
				FirstDueDt = @Prev_FirstDueDt,
				InstallmentsMade = @Prev_InstallmentsMade,
				InstallmentsRemaining = @Prev_InstallmentsRemaining,
				LastPaymentReceivedDt = @Prev_LastPaymentReceivedDt,
				TotalPaymentAmt = @Prev_TotalPaymentAmt
		WHERE SNum = @SNum;

	------------------------------
	--
	------------------------------
	IF ((@ContractNum IS NOT NULL) AND (@ContractNum <> ''))
	BEGIN
		SET @Prev_InsuredName = @InsuredName;
		SET @Prev_AcctNum = @AcctNum;
		SET @Prev_ContractNum = @ContractNum;
		SET @Prev_EffectiveDt = @EffectiveDt;
		SET @Prev_FirstDueDt = @FirstDueDt;
		SET	@Prev_InstallmentsMade = @InstallmentsMade;
		SET	@Prev_InstallmentsRemaining = @InstallmentsRemaining;
		SET	@Prev_LastPaymentReceivedDt = @LastPaymentReceivedDt;
		SET	@Prev_TotalPaymentAmt = @TotalPaymentAmt;
	END

	------------------------------
	--
	------------------------------
	FETCH NEXT FROM payment_cursor
		INTO @SNum, @InsuredName, @AcctNum, @ContractNum, @EffectiveDt, @FirstDueDt,
			 @InstallmentsMade, @InstallmentsRemaining, @LastPaymentReceivedDt, @TotalPaymentAmt;

END   

CLOSE payment_cursor;
DEALLOCATE payment_cursor;


GO


EXEC up_UpdatePayments;

-- select * from tmp_Payments
-- alter table tmp_Payments add SNum int identity(1,1) NOT NULL

/*
select distinct ContractNum
from tmp_Payments
where ContractNum <> ''

select ContractNum from Acct.Acct where ContractNum is not null
*/

----------------------------------------------------
-- There are ActNum missing you will not find till the payment info is available.
----------------------------------------------------
/*
select a.AcctNum, p.AcctNum, p.ContractNum
from tmp_Payments p, Acct.Acct a
where a.ContractNum <> ''
  and a.ContractNum = p.ContractNum
  and p.AcctNum IS NOT NULL
  and p.AcctNum <> ''
  and a.AcctNum is NULL
*/

/*
update Acct.Acct set AcctNum = p.AcctNum
from tmp_Payments p, Acct.Acct a
where a.ContractNum <> ''
  and a.ContractNum = p.ContractNum
  and p.AcctNum IS NOT NULL
  and p.AcctNum <> ''
  and a.AcctNum is NULL
*/


/*
drop table tmp_Payments;
-- GO

-- select * into tmp_Payments_backup from tmp_Payments

insert tmp_Payments (AcctNum, InsuredName, ContractNum, AgentName, EffectiveDt, FirstDueDt, InstallmentsMade, InstallmentsRemaining, LastPaymentReceivedDt,
		TotalPaymentAmt, BillingMethod, DisbursementPayee, DisbMethod, DisbPaidAmt, DisbUnpaidAmt)

select	AcctNum, InsuredName, ContractNum, AgentName, EffectiveDt, FirstDueDt, InstallmentsMade, InstallmentsRemaining, LastPaymentReceivedDt,
		TotalPaymentAmt, BillingMethod, DisbursementPayee, DisbMethod, DisbPaidAmt, DisbUnpaidAmt
from tmp_Payments_backup
order by SNum

select * from tmp_Payments

CREATE TABLE tmp_Payments
(
	[SNum]					[int]	IDENTITY(1,1) NOT NULL,
	[AcctNum]				[varchar](15),
	[InsuredName]			[varchar](50),
	[ContractNum]			[varchar](10),
	[AgentName]				[varchar](50),
	[EffectiveDt]			[varchar](20),
	[FirstDueDt]			[varchar](20),
	[InstallmentsMade]		[varchar](30),
	[InstallmentsRemaining]	[varchar](30),
	[LastPaymentReceivedDt]	[varchar](20),
	[TotalPaymentAmt]		[varchar](30),
	[BillingMethod]			[varchar](30),
	[DisbursementPayee]		[varchar](50),
	[DisbMethod]			[varchar](30),
	[DisbPaidAmt]			[varchar](30),
	[DisbUnpaidAmt]			[varchar](30),
	[DisbAcctNum]			[varchar](15)
);
-- GO

-- alter table tmp_Payments add [DisbAcctNum]			[varchar](6)

*/
-- Account Number	Account Name	Policy Number		O/R	Agent Name	Effective Date	First Due Date	Install Made	Installments Remaining	Last Payment Received Date	Total Payment Amount	Billing Method	Disbursement Payee		Disb. Method			Disb. Paid Amount	Disb. Unpaid Amount
