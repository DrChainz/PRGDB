USE [QSM]
GO

-- select count(*) from [CarData].[Car]


----------------------------------------------------------------------
-- 
----------------------------------------------------------------------
IF OBJECT_ID(N'up_AddDNC_NewData') IS NOT NULL
	DROP PROC up_AddDNC_NewData;
GO

CREATE PROC up_AddDNC_NewData
AS

-- IF @TableName IS NULL RETURN;

/*
declare @t table
(
	Phone	char(10)		NOT NULL UNIQUE,
	DispCd	char(4)			NULL,
	CallTm	smalldatetime	NULL
);
*/

/*
drop table tmp_t;

create table tmp_t
(
	Phone	char(10)		NOT NULL UNIQUE,
	DispCd	char(4)			NULL,
	CallTm	smalldatetime	NULL
);
*/

insert tmp_t (	Phone, CallTm )
select Phone_number, max(cast(last_local_call_time as smalldatetime)) as CallTm
from [CarData].[CarData_2015_05_May_07]
where Status in ('DNC','NI','NOC','WN')
  and Phone_number <> '0000000000'
  and Phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
group by phone_number

-- create unique index PK_tmp_t ON tmp_t (Phone);

-- create index FK_Phonex10 ON [CarData].[CarData_2015_05_May_07] (phone_number)

-- update [CarData].[CarData_2015_05_May_07] set CallTm = cast(last_local_call_time as smalldatetime)

-- delete [CarData].[CarData_2015_05_May_06] where lead_id = 'lead_id'

update tmp_t
set DispCd = x.status
from tmp_t t,  [CarData].[CarData_2015_05_May_07] x
where t.Phone = x.phone_number
  and t.CallTm = x.CallTm


delete tmp_t
where phone in (select Phone from [PrivateReserve].[DNC].[DNC]);

select count(*) from tmp_t;

select top 100 * from tmp_t

insert [PrivateReserve].[DNC].[DNC] (Phone, DispCd, CallTm)
select Phone, DispCd, CallTm
from tmp_t
where phone not in (select Phone from [PrivateReserve].[DNC].[DNC]);







update [CarData].[Car] set Exclude = 'Y'
where Exclude = 'N'
  and Phone in (select Phone from [PrivateReserve].[DNC].[DNC]);

GO

exec up_AddDNC_NewData ;