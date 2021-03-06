USE [PrivateReserve]
GO
/****** Object:  StoredProcedure [dbo].[up_MakeGoForte_DialSet_TimeZone]    Script Date: 8/25/2015 10:54:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[up_MakeGoForte_DialSet_TimeZone]
	@TimeZone	varchar(4) = 'EST',
 	@Wireless	char(1) = 'Y'
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
	[MakePriority]	[smallint] NULL,
	[YearPriority]	[smallint] NULL,
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
	[WarrantyExpireYearDiff] [smallint] NULL,
	[AddDt] [smalldatetime] NULL
);

	insert tmp_GoForte_Extract (ListCode, Appnumber, Vin)
	select distinct @Listcode, Phone, Vin
	FROM [QSM].[CarData].[Car] c
	where c.Make in (select UPPER(Make) from [QSM].[CarData].[MakeInclude])
	  and c.State NOT IN (select State from [DNC].[State])
	  and c.Address1 <> '' and c.Address1 IS NOT NULL
	  and c.Exclude = 'N'
	  and (c.FirstName IS NOT NULL AND c.FirstName <> '')
	  and (c.LastName IS NOT NULL AND c.LastName <> '')
	  and c.LastName not in (select LastName from [QSM].[Legend].[LastName] where Country = 'CN')
	  and c.AnswerMachine = 'N'
	  and c.Sale <> 'Y'
-- 	  and c.Src <> 'Chip??'
	  and c.Wireless = @Wireless
	  and c.State in (select State from [PrivateReserve].[Legend].[State] where TimeZone = @TimeZone)
	  and c.phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	  and substring(c.phone,1,3) in (SELECT AreaCd FROM [PrivateReserve].[DNC].[AreaCd])
	;

DELETE tmp_GoForte_Extract
WHERE Appnumber in (select AppNum from [PrivateReserve].[Acct].[Acct]);

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
--		vin = c.vin,
		year = c.year,
		model = c.model,
		make = c.make,
		odom = c.Odom,
		WarrantyExpireYearDiff = -5,
		AddDt = c.AddDt
FROM tmp_GoForte_Extract x, [QSM].[CarData].[Car] c
where x.appnumber = c.Phone
  and x.Vin = c.Vin
;

/*
update tmp_GoForte_Extract
	SET Last = c.LastName,
		First = c.FirstName,
		Middle = '',
		Address = c.Address1,
		City = c.City,
		State = c.State,
		Zip = substring(c.Zip,1,5),
		Phone = c.Phone,
--		vin = c.vin,
		year = c.year,
		model = c.model,
		make = c.make,
		odom = c.Odom,
		WarrantyExpireYearDiff = -5,
		AddDt = c.AddDt
FROM tmp_GoForte_Extract x, [QSM].[CarData].[CarAux] c
where x.appnumber = c.Phone
  and x.Vin = c.Vin
;
*/

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

-- select * from qsm.cardata.year

-----------------------------
-- This oughnt do anything --
DELETE tmp_GoForte_Extract
WHERE Make in (select Make from [PRG].[Car].[MakeExclude]);

DELETE tmp_GoForte_Extract
WHERE Make NOT IN (select Make from [PRG].[Car].[MakeInclude]);

select WarrantyExpireYearDiff, count(*)
FROM tmp_GoForte_Extract
GROUP BY WarrantyExpireYearDiff;

DECLARE @SortYearOrder TABLE
(
	[WarrantyExpireYearDiff] [smallint] NOT NULL,
	[Priority]				 [smallint]	NOT NULL
);
INSERT @SortYearOrder
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
SELECT -6, 15 union
SELECT 9, 16 union
SELECT 10, 17 union
SELECT 11, 18 union
SELECT 12, 19 union
SELECT 13, 20 union
SELECT 14, 21 union
SELECT 15, 22 union
SELECT 16, 23
;

DECLARE @SortMakeOrder TABLE
(
	[Make]			 [varchar](20)	NOT NULL,
	[Priority]		 [smallint]		NOT NULL
);

INSERT @SortMakeOrder (Make, Priority)
SELECT 'CHEVROLET', 1 UNION
SELECT 'FORD', 2 UNION
SELECT 'TOYOTA', 3 UNION
SELECT 'DODGE', 4 UNION
SELECT 'NISSAN', 5 UNION
SELECT 'HONDA', 6 UNION
SELECT 'GMC', 7 UNION
SELECT 'HYUNDAI', 8 UNION
SELECT 'KIA', 9 UNION
SELECT 'BMW', 10 UNION
SELECT 'CHRYSLER', 11 UNION
SELECT 'MERCEDES-BENZ', 12 UNION
SELECT 'VOLKSWAGEN', 13 UNION
SELECT 'CADILLAC', 14 UNION
SELECT 'BUICK', 15 UNION
SELECT 'LEXUS', 16 UNION
SELECT 'JEEP', 17 UNION
SELECT 'AUDI', 18 UNION
SELECT 'MAZDA', 19 UNION
SELECT 'ACURA', 20 UNION
SELECT 'INFINITI', 21 UNION
SELECT 'LINCOLN', 22 UNION
SELECT 'PONTIAC', 23 UNION
SELECT 'SUBARU', 24 UNION
SELECT 'SATURN', 25 UNION
SELECT 'MINI', 26 UNION
SELECT 'VOLVO', 27 UNION
SELECT 'MITSUBISHI', 28 UNION
SELECT 'MERCURY', 29 UNION
SELECT 'SCION', 30 UNION
SELECT 'SUZUKI', 31 UNION
SELECT 'LAND ROVER', 32 UNION
SELECT 'MERCEDES BENZ', 33 UNION
SELECT 'HUMMER', 34 UNION
SELECT 'SAAB', 35 UNION
SELECT 'JAGUAR', 36 UNION
SELECT 'FIAT', 37 UNION
SELECT 'ISUZU', 38
;

update tmp_GoForte_Extract
	set YearPriority = y.Priority
FROM tmp_GoForte_Extract x, @SortYearOrder y
where x.WarrantyExpireYearDiff = y.WarrantyExpireYearDiff
;

update tmp_GoForte_Extract
	set MakePriority = m.Priority
FROM tmp_GoForte_Extract x, @SortMakeOrder m
where x.Make = m.Make
;

update tmp_GoForte_Extract set MakePriority = 50 where MakePriority IS NULL;

delete [PrivateReserve].[CarData].[GoForte_Extract];

INSERT [CarData].[GoForte_Extract] (Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom, WarrantyExpireYearDiff, MakePriority, YearPriority)
SELECT Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom, WarrantyExpireYearDiff, MakePriority, YearPriority
FROM tmp_GoForte_Extract
ORDER BY MakePriority asc, YearPriority asc, AddDt desc;
