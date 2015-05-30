use PrivateReserve;
GO


CREATE PROC up_Add_dnc_tmp
AS
create table #tmp
(
	Phone char(10)			NOT NULL UNIQUE,
	DispCd varchar(5)		NULL,
	CallTm smalldatetime	NULL);

insert #tmp (Phone, CallTm)
select Phone, max(cast(last_local_call_time as smalldatetime))
from dnc.dnc_tmp
where Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
group by Phone;

update #tmp set DispCd = x.DispCd
from #tmp t, dnc.dnc_tmp x
where t.Phone = x.Phone
  and t.CallTm = cast(x.last_local_call_time as smalldatetime);

delete #tmp
where Phone in (select Phone from dnc.dnc);

insert dnc.dnc
select Phone, DispCd, CallTm
from #tmp

GO