USE [QSM]
GO
up_AddDNC_NewData '[CarData].[CarData_2015_04_Apr_20_2]'
----------------------------------------------------------------------
-- 
----------------------------------------------------------------------
IF OBJECT_ID(N'up_AddDNC_NewData') IS NOT NULL
	DROP PROC up_AddDNC_NewData;
GO

CREATE PROC up_AddDNC_NewData
	@TableName		varchar(50)	NULL
AS

IF @TableName IS NULL
	RETURN;

declare @t table
(
	Phone	char(10)		NOT NULL UNIQUE,
	DispCd	char(4)			NULL,
	CallTm	smalldatetime	NULL
);

insert @t (	Phone, CallTm )
select Phone_number, max(cast(last_local_call_time as smalldatetime)) as CallTm
from [@TableName]
where Status in ('DNC','NI','NOC','WN')
  and Phone_number <> '0000000000'
  and Phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
group by phone_number

update @t set DispCd = x.status
from @t t,  [@TableName]
where t.Phone = x.phone_number
  and t.CallTm = cast(x.last_local_call_time as smalldatetime)

delete @t
where phone in (select Phone from [PrivateReserve].[DNC].[DNC]);

insert [PrivateReserve].[DNC].[DNC] (Phone, DispCd, CallTm)
select * from @t;

update [CarData].[Car] set Exclude = 'Y'
where Exclude = 'N'
  and Phone in (select Phone from [PrivateReserve].[DNC].[DNC]);

GO