USE PrivateReserve;
GO

IF OBJECT_ID(N'up_MakeGoForte_DialSet') IS NOT NULL
	DROP PROC up_MakeGoForte_DialSet;
GO

CREATE PROC up_MakeGoForte_DialSet
AS

DECLARE @Today smalldatetime = cast(floor(cast(getdate() as float)) as smalldatetime);
DECLARE @Listcode varchar(20);
select @Listcode = 'QSM_' + CAST(DATEPART(yyyy,@Today) AS char(4)) + '_' + RIGHT('00'+ convert(varchar(2), DATEPART(mm,@Today)),2) + '_' + SUBSTRING(DATENAME(m,@Today),1,3) + '_' + CAST(DATEPART(d,@Today) AS CHAR(2));

delete [PrivateReserve].[CarData].[GoForte_Extract];

INSERT [PrivateReserve].[CarData].[GoForte_Extract] (Listcode, Appnumber)
select distinct @Listcode, Phone
from [QSM].[CarData].[Car]
where Make not in (select Make from [PRG].[Car].[MakeExclude])
  and Make in (select Make from [PrivateReserve].[Car].[Make])
  and cast(Year as smallint) >= 2010
  and Exclude = 'N'
  and Wireless = 'N'
  and substring(phone,1,3) in (SELECT AreaCd FROM [PrivateReserve].[DNC].[AreaCd])
;

update [PrivateReserve].[CarData].[GoForte_Extract]
	SET Last = c.LastName,
		First = c.FirstName,
		Middle = '',
		Address = c.Address1,
		City = c.City,
		State = c.State,
		Zip = substring(c.Zip,1,5),
		Phone = c.Phone,
		vin = c.vin,
		year = c.year,
		model = c.model,
		make = c.make,
		odom = c.odom
FROM [PrivateReserve].[CarData].[GoForte_Extract] x, [QSM].[CarData].[Car] c
where x.appnumber = c.phone
;
GO

exec up_MakeGoForte_DialSet;