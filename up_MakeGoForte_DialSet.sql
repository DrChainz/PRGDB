USE [PrivateReserve]
GO
/****** Object:  StoredProcedure [dbo].[up_MakeGoForte_DialSet]    Script Date: 7/11/2015 6:10:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[up_MakeGoForte_DialSet]
-- 	@Wireless	char(1) = 'N'
	@WirelessLandlineTogether char(1) = 'Y'
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
	[Odom] [varchar](10) NULL,
	[WarrantyExpireYearDiff] [smallint] NULL
);

insert tmp_GoForte_Extract (ListCode, Appnumber)
select distinct @Listcode, Phone
FROM [QSM].[CarData].[Car] c
where c.Make in (select UPPER(Make) from [QSM].[CarData].[MakeInclude])
--   and c.Make in (select Make from [PrivateReserve].[Car].[Make])
--   and cast(Year as smallint) >= 2010
  and c.Exclude = 'N'
--   and c.Wireless = @Wireless
--   and c.BizPhone = 'N'
  and c.phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and substring(c.phone,1,3) in (SELECT AreaCd FROM [PrivateReserve].[DNC].[AreaCd])
;

-- select count(*) from tmp_GoForte_Extract;

-- RETURN;
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
		odom = c.Odom,
		WarrantyExpireYearDiff = -5
FROM tmp_GoForte_Extract x, [QSM].[CarData].[Car] c
where x.appnumber = c.Phone
;

UPDATE tmp_GoForte_Extract SET Last = '' WHERE Last IS NULL;
UPDATE tmp_GoForte_Extract SET First = '' WHERE First IS NULL;
UPDATE tmp_GoForte_Extract SET Address = '' WHERE Address IS NULL;
UPDATE tmp_GoForte_Extract SET City = '' WHERE City IS NULL;
UPDATE tmp_GoForte_Extract SET Model = '' WHERE Model IS NULL;


DECLARE @Year smallint = (select cast(datepart(year, getdate()) as smallint));

UPDATE tmp_GoForte_Extract set WarrantyExpireYearDiff =  (@Year - m.FactoryWarrantyBasic_Yr) - cast(x.Year as smallint)
from tmp_GoForte_Extract x, [QSM].[CarData].[Make] m
where x.Make = m.Make
;

-----------------------------
-- This oughnt do anything --
DELETE tmp_GoForte_Extract
WHERE Make in (select Make from [PRG].[Car].[MakeExclude]);

select WarrantyExpireYearDiff, count(*)
FROM tmp_GoForte_Extract
GROUP BY WarrantyExpireYearDiff;

DECLARE @SortOrder TABLE
(
	[WarrantyExpireYearDiff] [smallint] NOT NULL,
	[Priority]				 [smallint]	NOT NULL
);
INSERT @SortOrder
SELECT 0, 1 UNION
SELECT 1, 2 UNION
SELECT 2, 3 UNION
SELECT -1, 4 UNION
SELECT 3, 5 UNION
SELECT 4, 6 UNION
SELECT 5, 7 UNION
SELECT 6, 8 UNION
SELECT 7, 9 UNION
SELECT 8, 10 UNION
SELECT -2, 11 UNION
SELECT -3, 12 UNION
SELECT -4, 13 UNION
SELECT -5, 14 UNION
SELECT -6, 15
;

update tmp_GoForte_Extract
	set Priority = y.Priority
FROM tmp_GoForte_Extract x, @SortOrder y
where x.WarrantyExpireYearDiff = y.WarrantyExpireYearDiff
;

delete [PrivateReserve].[CarData].[GoForte_Extract];

INSERT [CarData].[GoForte_Extract] (Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom, WarrantyExpireYearDiff, Priority)
SELECT Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom, WarrantyExpireYearDiff, Priority
FROM tmp_GoForte_Extract
ORDER BY Priority;
GO

/*
update [CarData].[GoForte_Extract]
	set Priority = y.Priority
FROM [CarData].[GoForte_Extract] g, [PrivateReserve].[Car].[Year] y
WHERE g.Year = y.Year;
*/
exec [up_MakeGoForte_DialSet]