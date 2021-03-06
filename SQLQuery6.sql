USE [PrivateReserve]
GO
/****** Object:  StoredProcedure [dbo].[up_MakeGoForte_DialSet]    Script Date: 5/9/2015 9:59:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [up_MakeGoForte_DialSet]

ALTER PROC [dbo].[up_MakeGoForte_DialSet]
AS

DECLARE @Today smalldatetime = cast(floor(cast(getdate() as float)) as smalldatetime);
DECLARE @Listcode varchar(20);
select @Listcode = 'APC_' + CAST(DATEPART(yyyy,@Today) AS char(4)) + '_' + RIGHT('00'+ convert(varchar(2), DATEPART(mm,@Today)),2) + '_' + SUBSTRING(DATENAME(m,@Today),1,3) + '_' + CAST(DATEPART(d,@Today) AS CHAR(2));

IF OBJECT_ID(N'tmp_GoForte_Extract') IS NOT NULL
	DROP TABLE tmp_GoForte_Extract;

CREATE TABLE tmp_GoForte_Extract
(
	[Listcode] [varchar](20) NOT NULL,
	[Appnumber] [char](10) NOT NULL,
	[Priority]	[smallint] NULL,
	[Last] [varchar](30) NULL,
	[First] [varchar](30) NULL,
	[Middle] [char](1) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](30) NULL,
	[State] [char](2) NULL,
	[Zip] [char](5) NULL,
	[Phone] [char](10) NULL,
	[VIN] [char](17) NULL,
	[Year] [char](4) NULL,
	[Model] [varchar](50) NULL,
	[Make] [varchar](50) NULL,
	[Odom] [varchar](10) NULL
);

insert tmp_GoForte_Extract (ListCode, Appnumber)
select distinct @Listcode, Phone
FROM [QSM].[CarData].[Car] c
where c.Make not in (select Make from [PRG].[Car].[MakeExclude])
  and c.Make in (select Make from [PrivateReserve].[Car].[Make])
--   and cast(Year as smallint) >= 2010
  and c.Exclude = 'N'
  and c.Wireless = 'N'
  and c.phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and substring(c.phone,1,3) in (SELECT AreaCd FROM [PrivateReserve].[DNC].[AreaCd])
;

update tmp_GoForte_Extract
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
		odom = c.Odom
FROM tmp_GoForte_Extract x, [QSM].[CarData].[Car] c
where x.appnumber = c.Phone
;

update tmp_GoForte_Extract
	set Priority = y.Priority
FROM tmp_GoForte_Extract x, [PrivateReserve].[Car].[Year] y
where x.Year = y.Year
;

delete [PrivateReserve].[CarData].[GoForte_Extract];

INSERT [CarData].[GoForte_Extract] (Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom)
SELECT Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom
FROM tmp_GoForte_Extract
ORDER BY Priority;

update [CarData].[GoForte_Extract]
	set Priority = y.Priority
FROM [CarData].[GoForte_Extract] g, [PrivateReserve].[Car].[Year] y
WHERE g.Year = y.Year;
