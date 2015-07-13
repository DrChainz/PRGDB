/*
select *
from Acct.Acct
where Cancelled = 'N'
*/

select count(*) from Acct.Acct
where Cancelled = 'Y'


select * from tmp_Payments

select DisbAcctNum, DisbursementPayee, DisbMethod, sum(cast(DisbPaidAmt as money)) SumDisbPaidAmt, sum(cast(DisbUnpaidAmt as money)) SumDisbUnpaidAmt
from tmp_Payments
group by DisbAcctNum, DisbursementPayee, DisbMethod


select * from Acct.Acct where ContractNum = 'SCW001002'


select * from tmp_Payments where DisbAcctNum = '4735577';


select DisbursementPayee, (CHARINDEX (' -', DisbursementPayee) - 1), substring(DisbursementPayee, 1, (CHARINDEX (' -', DisbursementPayee) - 1))
from tmp_Payments



select * from Acct.Acct
where ContractNum = 'APS50006'

APS50006

SCW001006'

/*
select AppNum
from Acct.Acct
where Cancelled = 'Y'
*/

select SaleDt, Salesman, Cancelled, count(*)
from Acct.Acct
where Cancelled = 'Y'
group by SaleDt, Salesman, Cancelled
order by SaleDt desc

-- select sum(DownpaymentAmt) from Acct.Acct;

-- update Acct.Acct set Cancelled = 'N' where Cancelled is null



  -- update Acct.Acct set CancelDt = NULL