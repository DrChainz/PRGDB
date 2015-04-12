USE MASTER;
GO

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'PRG'))
	DROP DATABASE [PRG];
GO

CREATE DATABASE [PRG];		-- likely oughta define size here
GO

USE [PRG];
GO

create table [dbo].[Tmp] ( LoadData char(1) NOT NULL );
INSERT [dbo].[Tmp] SELECT 'N';
GO

---------------------------------------
-- Schemas
---------------------------------------
CREATE Schema [Legend];
GO

---------------------------------------
-- Rules
---------------------------------------
CREATE RULE [Legend].[AreaCd] 
AS
@Val like '[0-9][0-9][0-9]'
GO

CREATE RULE [dbo].[State] 
AS
@Val like '[A-Z][A-Z]'
GO

CREATE RULE [Legend].[PhoneFormat] 
AS
@Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
GO

CREATE RULE [Legend].[Year] 
AS
@Val like '[1-2][0-9][0-9][0-9]'
GO

CREATE RULE [Legend].[YearMonth] 
AS
@Val LIKE '[1-2][0,9][0-9][0-9][0-1][0-9]'
GO

CREATE RULE [Legend].[Qtr] 
AS
@Val BETWEEN 1 AND 4;
GO

CREATE RULE [Legend].[YesNo] 
AS
@Val IN ('N','Y')
GO

CREATE RULE [Legend].[YesNoUnknown] 
AS
@Val IN ('U','N','Y')
GO

CREATE RULE [Legend].[WeekDay]
AS
@Val IN ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')
GO

---------------------------------------
-- User Defined Types
---------------------------------------
CREATE TYPE [Legend].[AreaCd] FROM [char](3) NOT NULL
GO

CREATE TYPE [dbo].[State] FROM [char](2) NOT NULL
GO

CREATE TYPE [Legend].[WeekDay] FROM [varchar](9) NOT NULL
GO

CREATE TYPE [Legend].[Phone] FROM [char](10) NOT NULL
GO

CREATE TYPE [Legend].[Qtr] FROM [tinyint] NOT NULL
GO

CREATE TYPE [Legend].[Year] FROM [char](4) NOT NULL
GO

CREATE TYPE [Legend].[YearMonth] FROM [char](6) NOT NULL
GO

CREATE TYPE [Legend].[YesNo] FROM [char](1) NOT NULL
GO

CREATE TYPE [Legend].[YesNoUnknown] FROM [char](1) NOT NULL
GO

---------------------------------------
-- Bind the rules the types
---------------------------------------
sp_bindrule '[Legend].[AreaCd]', '[Legend].[AreaCd]';
GO

sp_bindrule '[dbo].[State]', '[dbo].[State]';
GO

sp_bindrule '[Legend].[WeekDay]', '[Legend].[WeekDay]';
GO

sp_bindrule '[Legend].[PhoneFormat]', '[Legend].[Phone]';
GO

sp_bindrule '[Legend].[Qtr]', '[Legend].[Qtr]';
GO

sp_bindrule '[Legend].[Year]', '[Legend].[Year]';
GO

sp_bindrule '[Legend].[YearMonth]', '[Legend].[YearMonth]';
GO

sp_bindrule '[Legend].[YesNo]', '[Legend].[YesNo]';
GO

sp_bindrule '[Legend].[YesNoUnknown]', '[Legend].[YesNoUnknown]';
GO

---------------------------------------
-- Create Defaults
---------------------------------------
CREATE DEFAULT [Legend].[No] AS 'N';
GO

CREATE DEFAULT [Legend].[Unknown] AS 'U';
GO

---------------------------------------
-- Bind Defaults
---------------------------------------
sp_bindefault '[Legend].[No]', '[Legend].[YesNo]'; 
GO
sp_bindefault '[Legend].[Unknown]', '[Legend].[YesNoUnknown]'; 
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[TimeZone]
(
	[TimeZone]		[char](4)		NOT NULL,
	[Name]			[varchar](30)	NOT NULL,
	[UTC_Offset]	[smallint]		NOT NULL,
PRIMARY KEY (TimeZone) 
) ON [PRIMARY]
GO

INSERT [Legend].[TimeZone] ( TimeZone, Name, UTC_Offset)
SELECT 'AKST','Alaska Standard Time', -9 UNION
SELECT 'CDT','Central Daylight Time', -5 UNION
SELECT 'CST','Central Standard Time', -6 UNION
SELECT 'EDT','Eastern Daylight Time', -4 UNION
SELECT 'EST','Eastern Standard Time', -5 UNION
SELECT 'HST','Hawaii Standard Time', -11 UNION
SELECT 'MDT','Mountain Daylight Time', -6 UNION
SELECT 'MST','Mountain Standard Time', -7 UNION
SELECT 'PST','Pacific Standard Time', -8
 GO

---------------------------------------
-- select * from Legend.State
-----------------------------------------
CREATE TABLE [PRG].[Legend].[State]
(
	[State]		[dbo].[State]	NOT NULL,
	[Name]		[varchar](25)		NOT NULL,
	[TimeZone]	[char](4)			NOT NULL,
PRIMARY KEY (State),
FOREIGN KEY ([TimeZone]) REFERENCES [Legend].[TimeZone](TimeZone)
) ON [PRIMARY]
 GO

-- Put all the states into the legend table
INSERT [Legend].[State] (State, Name, TimeZone)
SELECT 'HI','Hawaii', 'HST' UNION
SELECT 'AK','Alaska', 'AKST' UNION
SELECT 'WA', 'Washington', 'PST' UNION
SELECT 'CA','California', 'PST' UNION
SELECT 'OR','Oregon', 'PST' UNION
SELECT 'NV','Nevada', 'PST' UNION
SELECT 'AZ','Arizona', 'MST' UNION
SELECT 'UT','Utah', 'MST' UNION
SELECT 'CO','Colorado', 'MST' UNION
SELECT 'NM','New Mexico', 'MST' UNION
SELECT 'MT','Montana', 'MST' UNION
SELECT 'WY','Wyoming', 'MST' UNION
SELECT 'ID','Idaho', 'MST' UNION
SELECT 'ND','North Dakota', 'CST' UNION
SELECT 'SD','South Dakota', 'CST' UNION
SELECT 'NE','Nebraska', 'CST' UNION
SELECT 'KS','Kansas', 'CST' UNION
SELECT 'OK','Oklahoma', 'CST' UNION
SELECT 'TX','Texas', 'CST' UNION
SELECT 'MN','Minnesota', 'CST' UNION
SELECT 'AL','Alabama', 'CST' UNION
SELECT 'IL','Illinois', 'CST' UNION
SELECT 'AR','Arkansas', 'CST' UNION
SELECT 'MO','Missouri', 'CST' UNION
SELECT 'IA','Iowa', 'CST' UNION
SELECT 'LA','Louisiana', 'CST' UNION
SELECT 'MS','Mississippi', 'CST' UNION
SELECT 'TN','Tennessee', 'CST' UNION
SELECT 'CT','Connecticut', 'EST' UNION
SELECT 'DE','Delaware', 'EST' UNION
SELECT 'FL','Florida', 'EST' UNION
SELECT 'GA','Georgia', 'EST' UNION
SELECT 'IN','Indiana', 'EST' UNION
SELECT 'KY','Kentucky', 'EST' UNION
SELECT 'ME','Maine', 'EST' UNION
SELECT 'MD','Maryland', 'EST' UNION
SELECT 'MA','Massachusetts', 'EST' UNION
SELECT 'MI','Michigan', 'EST' UNION
SELECT 'NH','New Hampshire', 'EST' UNION
SELECT 'NJ','New Jersey', 'EST' UNION
SELECT 'NY','New York', 'EST' UNION
SELECT 'NC','North Carolina', 'EST' UNION
SELECT 'OH','Ohio', 'EST' UNION
SELECT 'PA','Pennsylvania', 'EST' UNION
SELECT 'RI','Rhode Island', 'EST' UNION
SELECT 'SC','South Carolina', 'EST' UNION
SELECT 'VT','Vermont', 'EST' UNION
SELECT 'VA','Virginia', 'EST' UNION
SELECT 'WV','West Virginia', 'EST' UNION
SELECT 'WI','Wisconsin', 'EST' UNION
SELECT 'DC','Washington DC', 'EST' UNION
SELECT 'PR','Puerto Rico', 'EST' UNION
SELECT 'VI','U.S. Virgin Islands', 'EST'
;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[Day]
(
	[Dt]			[smalldatetime]			NOT NULL,
	[WeekDayNum]	[tinyint]				NOT NULL,
 	[WeekDay]		[Legend].[WeekDay]		NOT NULL,
	[Payday]		[Legend].[YesNo]		NOT NULL,
	[Week]			[smallint]				NOT NULL,
	[Year]			[Legend].[Year]			NOT NULL,
	[Month]			[tinyint]				NOT NULL,
	[YearMonth]		[Legend].[YearMonth]	NOT NULL,
	[Qtr]			[Legend].[Qtr]			NOT NULL,
PRIMARY KEY (Dt)
) ON [PRIMARY]
GO


IF OBJECT_ID(N'Legend.up_MakeDay') IS NOT NULL
	DROP PROC [Legend].[up_MakeDay]
 GO

-----------------------------------------------------------------
-- Proc used to populate all the days of the year passed
-- called when done to put every day in current year into table
-- so have something to reference for reporting 
-----------------------------------------------------------------
CREATE PROC [Legend].[up_MakeDay]
	@Year	char(4) = NULL
AS
SET NOCOUNT ON;

	IF @Year IS NULL
		SET @Year = datepart(year,getdate());


	DECLARE @Days TABLE
	(
		Dt			smalldatetime	NULL,
		WeekDayNum	tinyint			NULL,
		WeekDay		varchar(9)		NULL,
		Payday		char(1)			NULL,
		Week		smallint		NULL,
		Year		char(4)			NULL,
		Month		tinyint			NULL,
		YearMonth	char(6)			NULL,
		Qtr			tinyint			NULL
	);

	DECLARE @Dt smalldatetime = convert(smalldatetime,@Year+'-1-1');
	DECLARE @EndDt smalldatetime = convert(smalldatetime,@Year+'-12-31');
	DECLARE @YearMonth char(6);
	DECLARE @Month	tinyint = 0;

	WHILE (@Dt <= @EndDt)
	BEGIN
		SET @Month = DATEPART(m,@Dt);

		IF (@Month < 10)
			SET @YearMonth = @Year + '0' + convert(char(1), @Month);
		ELSE 
			SET @YearMonth = @Year + convert(char(2), @Month);

		INSERT @Days (Dt, Payday, YearMonth)
		VALUES (@Dt, 'N',  @YearMonth);

		SET @Dt += 1;
	END

	UPDATE @Days
	SET Qtr = ( CASE
				WHEN DATEPART(m,Dt) BETWEEN 1 AND 3 THEN 1
				WHEN DATEPART(m,Dt) BETWEEN 4 AND 6 THEN 2
				WHEN DATEPART(m,Dt) BETWEEN 7 AND 9 THEN 3
				WHEN DATEPART(m,Dt) BETWEEN 10 AND 12 THEN 4
				END );
	
	update @Days set Year = datepart(Year, Dt);

	update @Days set Month = datepart(Month, Dt);

	update @Days set Week = DATEPART(wk,Dt);

	update @Days set WeekDayNum = datepart(weekday, Dt);

	update @Days set WeekDay = datename(weekday,Dt);

	update @Days set Payday = 'Y'
	where WeekDay = 'Friday' and (Week % 2) = 0;

	INSERT [Legend].[Day] ( Dt, WeekDayNum, WeekDay, Payday, Week, Year, Month, YearMonth, Qtr )
	SELECT Dt, WeekDayNum, WeekDay, Payday, Week, Year, Month, YearMonth, Qtr
	FROM @Days
	WHERE Dt NOT IN (select Dt FROM [Legend].[Day])
	;
 GO

EXEC [Legend].[up_MakeDay] '2015';
EXEC [Legend].[up_MakeDay] '2016';
GO

---------------------------------------
--	Call Disposition Codes and their meanings
-----------------------------------------
CREATE TABLE [Legend].[Disp]
(
	[DispCd]		[char](4)		NOT NULL,
	[DispDesc]		[varchar](50)	NOT NULL,
PRIMARY KEY ([DispCd])
) ON [PRIMARY]
 GO

INSERT [Legend].[Disp] (DispCd, DispDesc)
SELECT 'DNC','Do Not Call' UNION
SELECT 'NI', 'Not Interested' UNION
SELECT 'NOC', 'Doesn''t Own Car' UNION
SELECT 'WN', 'Wrong Number'
GO
-- set identity_insert [Legend].[Disp] OFF;

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[FirstName]
(
	[FirstName]		[varchar](50)		NOT NULL UNIQUE,
	[Cnt]			[int]				NULL,
	[BadName]		[Legend].[YesNo]	NOT NULL
) ON [PRIMARY]
GO

-- save time while testing

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [Legend].[FirstName] (FirstName, Cnt, BadName)
	SELECT FirstName, Cnt, BadName
	FROM [QSM].[Legend].[FirstName]
END
GO

-- Figure out how to create the SIC tables correctly.
-- this also likely oughta have a log entry associated with it such that we know
-- the last time the data was updated.

--***************************************
--
--***************************************
CREATE Schema [DNC];
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[AreaCd]
(
	[AreaCd]	[Legend].[AreaCd] NOT NULL,
PRIMARY KEY ([AreaCd])
) ON [PRIMARY]
 GO

------------------------------------------
-- move area codes we already purchased
------------------------------------------
INSERT [DNC].[AreaCd] (AreaCd)
SELECT AreaCd
FROM [PrivateReserve].[DNC].[AreaCd]
 GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[DNC]
(
	[Phone]		[Legend].[Phone]	NOT NULL UNIQUE,
	[DispCd]	[char](4)			NOT NULL,
	[CallTm]	[datetime]			NULL,
FOREIGN KEY ([DispCd]) REFERENCES [Legend].[Disp](DispCd)
) ON [PRIMARY]
 GO

------------------------------------------
-- move some data into here to get started
------------------------------------------
INSERT [DNC].[DNC] (Phone, DispCd, CallTm)
SELECT Phone, DispCd, CallTm
FROM [PrivateReserve].[DNC].[DNC]
 GO

INSERT [DNC].[DNC] (Phone, DispCd, CallTm)
SELECT DISTINCT Phone, 'DNC', GETDATE()
FROM [PrivateReserve].[CarData].[DNC_Preexisting]
WHERE Phone NOT IN (SELECT Phone FROM [DNC].[DNC])
  AND Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[WirelessBlocks]
(
	[NPA] [char](3) NOT NULL,
	[NXX] [char](3) NOT NULL,
	[X] [char](1) NOT NULL,
	[CATEGORY] [varchar](10) NOT NULL,
	[PhoneBegin] [char](7) NULL
) ON [PRIMARY]
 GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[WirelessToLandline]
(
	[Phone]		[Legend].[Phone] NOT NULL	UNIQUE
) ON [PRIMARY]
GO


---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[LandlineToWireless]
(
	[Phone]		[Legend].[Phone] NOT NULL	UNIQUE
) ON [PRIMARY]
 GO

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [DNC].[WirelessBlocks] ( NPA, NXX, X, CATEGORY, PhoneBegin )
	SELECT  NPA, NXX, X, CATEGORY, PhoneBegin
	FROM [PrivateReserve].[DNC].[WirelessBlocks];

	INSERT [DNC].[WirelessToLandline] (Phone)
	SELECT Phone
	FROM [PrivateReserve].[DNC].[WirelessToLandline];

	INSERT [DNC].[LandlineToWireless] (Phone)
	SELECT Phone
	FROM [PrivateReserve].[DNC].[LandlineToWireless];
END
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[Wireless_LoadLog]
(
	[LoadDt]				[smalldatetime] NOT NULL,
	[WirelessCnt]			[int]			NOT NULL,
	[WirelessToLandlineCnt] [int]			NOT NULL,
	[LandlineToWirelessCnt] [int]			NOT NULL
) ON [PRIMARY]
GO

--***************************************
--
--***************************************
CREATE Schema [Car];
GO

CREATE TYPE [Car].[VIN] FROM [char](17) NOT NULL
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[StateExclude]
(
	[State]	[dbo].[State]	NOT NULL UNIQUE
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
)
 GO

-- put in the current states we're excluding
INSERT [Car].[StateExclude] (State)
SELECT State
FROM [PrivateReserve].[Legend].[ExcludeState]
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[Make]
(
	[Make]								[varchar](20)	NOT NULL,
	[FactoryWarrantyBasic_Yr]			[tinyint]		NULL,
	[FactoryWarrantyBasic_Miles]		[int]			NULL,
	[FactoryWarrantyDrivetrain_Yr]		[tinyint]		NULL,
	[FactoryWarrantyDrivetrain_Miles]	[int]			NULL,
PRIMARY KEY ([Make])
) ON [PRIMARY]
GO

INSERT [Car].[Make] ( Make, FactoryWarrantyBasic_Yr, FactoryWarrantyBasic_Miles, FactoryWarrantyDrivetrain_Yr, FactoryWarrantyDrivetrain_Miles )
SELECT Make, FactoryWarrantyBasic_Yr, FactoryWarrantyBasic_Miles, FactoryWarrantyDrivetrain_Yr, FactoryWarrantyDrivetrain_Miles
FROM [PrivateReserve].[Car].[Make]
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[MakeErr]
(
	[MakeErr]		[varchar](30) NOT NULL UNIQUE,
	[Make]			[varchar](20) NOT NULL,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
) ON [PRIMARY]
GO

INSERT [Car].[MakeErr] ( MakeErr, Make )
SELECT MakeErr, Make
FROM [PrivateReserve].[Car].[MakeErr]
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[MakeExclude]
(
	Make		[varchar](20)	NOT NULL UNIQUE,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
)
GO

INSERT  [Car].[MakeExclude] (Make)
select 'ASTON MARTIN' UNION
select 'FERRARI' UNION
select 'HONDA MOTORCYCLE' UNION
select 'LAMBORGHINI' UNION
select 'LOTUS' UNION
select 'MASERATI' UNION
select 'MAYBACH' UNION
select 'ROLLS-ROYCE' UNION
select 'TESLA' UNION
select 'SMART' UNION
select 'FISKER';
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[MakeModel]
(
	[Make]		[varchar](20) NOT NULL,
	[Model]		[varchar](30) NOT NULL,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
) ON [PRIMARY]
GO

CREATE UNIQUE INDEX PK_MakeModel ON [Car].[MakeModel] ([Make], [Model])
GO

INSERT [Car].[MakeModel] ( Make, Model )
SELECT Make, Model
FROM [PrivateReserve].[Car].[MakeModel]
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[ModelErr]
(
	[ModelErr]	[varchar](30) NOT NULL,
	[Make]		[varchar](20) NOT NULL,
	[Model]		[varchar](30) NOT NULL,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
) ON [PRIMARY]
GO

INSERT [Car].[ModelErr] ( ModelErr, Make, Model )
SELECT ModelErr, Make, Model
FROM [QSM].[CarData].[ModelErr]
GO

--------------------------------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE [Car].[Car]
(
	[VIN]			[Car].[VIN]			NOT NULL,
	[Make]			[varchar](20)		NOT NULL,
	[Model]			[varchar](30)		NOT NULL,
	[Year]			[Legend].[Year]		NOT NULL,
PRIMARY KEY ([VIN]),
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
);
GO

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [Car].[Car] (VIN, Make, Model, Year)
	select VIN, Make, Model, Year
	from [QSM].[CarData].[Car]
	where Model in (select Model FROM [QSM].[CarData].[Car] group by Model having count(*) > 5)
--	  and Make = 'KIA' -- test 
END
GO

--------------------------------------------------------------------------------------------------------------------
--  drop table [Car].[CarPhone]
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE [Car].[CarPhone]
(
	[VIN]			[Car].[VIN]			NOT NULL,
	[Phone]			[Legend].[Phone]	NOT NULL,
	[Wireless]		[Legend].[YesNo]	NOT NULL,
	[FirstName]		[varchar](20)		NULL,
	[LastName]		[varchar](30)		NULL,
	[Address]		[varchar](50)		NULL,
	[City]			[varchar](30)		NULL,
	[State]			[dbo].[State]		NOT NULL,
	[Zip]			[varchar](10)		NULL
FOREIGN KEY ([VIN]) REFERENCES [Car].[Car](VIN),
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
);
GO

CREATE UNIQUE INDEX PK_CarPhone ON [Car].[CarPhone] ( VIN, Phone );
GO

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [Car].[CarPhone] (VIN, Phone, Wireless, FirstName, LastName, Address, City, State, Zip)
	SELECT VIN, Phone, Wireless, FirstName, LastName, Address, City, State, Zip
	FROM [QSM].[CarData].[CarPhone]
	WHERE State in (select State FROM Legend.State)
	  and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	  and VIN in (select VIN FROM [Car].[Car])
	  and STate not in (select State from [Car].[StateExclude])
END
GO

--------------------------------------------------------------------------------------------------------------------
--  This table is only to be used to put data into so that it can be extracted in the correct format to be loaded
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE [Car].[GoForte_Extract]
(
	[Listcode]		[varchar](20)		NOT NULL,
	[Appnumber]		[char](10)			NOT NULL	UNIQUE,		-- phone number
	[Last]			[varchar](30)		NULL,
	[First]			[varchar](30)		NULL,
	[Middle]		[char](1)			NULL,
	[Address]		[varchar](50)		NULL,
	[City]			[varchar](30)		NULL,
	[State]			[dbo].[State]		NOT NULL,
	[Zip]			[char](5)			NULL,
	[Phone]			[Legend].[Phone]	NOT NULL,
	[VIN]			[Car].[Vin]			NOT NULL,
	[Year]			[Legend].[Year]		NOT NULL,
	[Model]			[varchar](30)		NOT NULL,
	[Make]			[varchar](20)		NOT NULL,
	[Odom]			[varchar](10)		NULL,
FOREIGN KEY ([VIN]) REFERENCES [Car].[Car](VIN),
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
) ON [PRIMARY]
GO

--***************************************
--
--***************************************
CREATE Schema [Employee];
GO

--------------------------------------
--
-----------------------------------------
CREATE TABLE [Employee].[Rate]
(
	[RateId]	[int]			NOT NULL	IDENTITY(1,1),
	[Name]		[varchar](30)	NOT NULL	UNIQUE,
	[HrPay]		[money]			NOT NULL
PRIMARY KEY ([RateId])
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Employee].[Rate] ON;
INSERT [Employee].[Rate] (RateId, Name, HrPay)
SELECT 1, 'Probation', 10 UNION
SELECT 2, 'Serf', 11 UNION
SELECT 3, 'Peasant', 12 UNION
SELECT 4, 'Knight', 13 UNION
SELECT 5, 'Manager/Lord/Noble', 14
SET IDENTITY_INSERT [Employee].[Rate] OFF;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Employee].[Role]
(
	[RoleId]			[int]			NOT NULL	IDENTITY(1,1),
	[Role]				[varchar](30)	NOT NULL	UNIQUE,
	[DefaultRateId]		[int]			NULL
PRIMARY KEY ([RoleId])
FOREIGN KEY ([DefaultRateId]) REFERENCES [Employee].[Rate] (RateId)
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Employee].[Role] ON;
INSERT [Employee].[Role] (RoleId, Role, DefaultRateId)
SELECT 1, 'Screener', 1 UNION
SELECT 2, 'Manager', 5 UNION
SELECT 3, 'Closer', NULL UNION
SELECT 4, 'T.O.', NULL
SET IDENTITY_INSERT [Employee].[Role] OFF;
GO

---------------------------------------
-- drop TABLE [Employee].[Employee]
-----------------------------------------
CREATE TABLE [Employee].[Employee]
(
	[EmplId]			[int]				NOT NULL	IDENTITY(1,1),
	[RoleId]			[int]				NOT NULL,
	[RateId]			[int]				NOT NULL,
	[HireDt]			[smalldatetime]		NOT NULL,
	[FirstName]			[varchar](20)		NOT NULL,
	[LastName]			[varchar](30)		NULL,
	[Phone]				[Legend].[Phone]	NULL,
	[Address]			[varchar](50)		NULL,
	[Address2]			[varchar](50)		NULL,
	[City]				[varchar](30)		NULL,
	[State]				[State]				NULL,
	[Zip]				[varchar](10)		NULL,
PRIMARY KEY ([EmplId]),
FOREIGN KEY ([RoleId]) REFERENCES [Employee].[Role] (RoleId),
FOREIGN KEY ([RateId]) REFERENCES [Employee].[Rate] (RateId),
FOREIGN KEY ([HireDt]) REFERENCES [Legend].[Day] (Dt)
);
GO

SET IDENTITY_INSERT [Employee].[Employee] ON;
INSERT [Employee].[Employee] (EmplId, RoleId, RateId, FirstName, HireDt)
select 1, 3, 5, 'Tawney', '2015-04-01' union
select 2, 1, 1, 'Guz Jr', '2015-04-01' union
SELECT 3, 2, 5, 'Chainz', '2015-04-01' union
select 4, 1, 2, 'Prego', '2015-04-01'
SET IDENTITY_INSERT [Employee].[Employee] OFF;

/*
select e.FirstName, o.Role, r.Name
from [Employee].[Employee] e, [Employee].[Role] o, [Employee].[Rate] r
where e.RateId = r.RateId
  and e.RoleId = o.RoleId
*/

---------------------------------------
-- drop table [Employee].[Day]
-----------------------------------------
CREATE TABLE [Employee].[Day]
(
	[EmplId]			[int]				NOT NULL,
	[Dt]				[smalldatetime]		NOT NULL,
	[StartTm]			[smalldatetime]		NOT NULL,
	[EndTm]				[smalldatetime]		NULL,
	[TransferCnt]		[smallint]			NULL,
	[CloseCnt]			[smallint]			NULL
FOREIGN KEY ([EmplId]) REFERENCES [Employee].[Employee] (EmplId),
FOREIGN KEY ([Dt]) REFERENCES [Legend].[Day] (Dt)
);
GO

CREATE UNIQUE INDEX PK_EmployeeDay ON [Employee].[Day] ([EmplId], [Dt])
GO

--***************************************
--
--***************************************
CREATE Schema [Call];
GO

CREATE TABLE [Call].[Disp]
(
	Disp		varchar(5)		NOT NULL	UNIQUE,
	LongDisp	varchar(30)		NOT NULL,
PRIMARY KEY (Disp)
)
GO

INSERT [Call].[Disp] (Disp, LongDisp)
SELECT 'DNC', 'Do Not Call' UNION
SELECT 'A', 'Answering Machine' UNION
SELECT 'NI', 'Not Interested'
GO

--***************************************
--
--***************************************
CREATE Schema [Policy];
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Policy].[Company]
(
	[CompanyId]			[int]				NOT NULL	IDENTITY(1,1),
	[Company]			[varchar](30)		NOT NULL	UNIQUE,
PRIMARY KEY ([CompanyId])
);
GO

INSERT [Policy].[Company] ( Company )
SELECT 'American Auto Shield' UNION
SELECT 'Royal' UNION
SELECT 'Sentinel'  UNION
SELECT 'SunPath'
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Policy].[Term]
(
	Months				[smallint]			NOT NULL,
PRIMARY KEY (Months)
);
GO

INSERT [Policy].[Term] (Months)
SELECT 0 UNION
SELECT 6 UNION
SELECT 9 UNION
SELECT 12 UNION
SELECT 15 UNION
SELECT 18 UNION
SELECT 24;
GO

---------------------------------------
-- drop table [Policy].[PayPlan]
-----------------------------------------
CREATE TABLE [Policy].[PayPlan]
(
	[PayPlanId]		[int]			NOT NULL	IDENTITY(1,1),
	[Name]			varchar(30)		NOT NULL	UNIQUE,
	[RoleId]		[int]			NOT NULL
PRIMARY KEY (PayPlanId),
FOREIGN KEY ([RoleId]) REFERENCES [Employee].[Role] (RoleId)
);
GO

DECLARE @RoleId_Closer int = (SELECT RoleId FROM [Employee].[Role] WHERE Role = 'Closer');
SET IDENTITY_INSERT [Policy].[PayPlan] ON;
INSERT [Policy].[PayPlan] (PayPlanId, Name, RoleId)
SELECT 1, 'Bizkit', @RoleId_Closer ;
SET IDENTITY_INSERT [Policy].[PayPlan] OFF;
GO

---------------------------------------
-- drop table [Policy].[Policy]
-----------------------------------------
CREATE TABLE [Policy].[Policy]
(
	[PolicyId]			[int]				NOT NULL	IDENTITY(1,1),
	[CompanyId]			[int]				NOT NULL,
	[Front_EmplId]		[int]				NOT NULL,
	[Sale_EmplId]		[int]				NOT NULL,
	[TO_EmplId]			[int]				NULL,
	[PayPlanId]			[int]				NOT NULL,
	[Vin]				[Car].[Vin]			NOT NULL,
	[ClosingDt]			[smalldatetime]		NOT NULL,
	[SaleCnt]			[tinyint]			NOT NULL,
	[PaidInFull]		[Legend].[YesNo]	NOT NULL,
	[Retail++]			[money]				NOT NULL,
	[Retail]			[money]				NOT NULL,
	[Discount]			[money]				NOT NULL,
	[TotalCost]			[money]				NOT NULL,		-- outta be Retail - Discount unless is 0 and total is greater than Retail and more towards Retail++
	[AdminCost]			[money]				NOT NULL,
	[GrossProfit]		[money]				NOT NULL,
	[FirstPaymentDt]	[smalldatetime]		NULL,
	[Months]			[smallint]			NOT NULL,
	[PaymentFrequency]	[int]				NULL,
PRIMARY KEY ([PolicyId]),
FOREIGN KEY ([CompanyId]) REFERENCES [Policy].[Company] (CompanyId),
FOREIGN KEY ([Front_EmplId]) REFERENCES [Employee].[Employee] (EmplId),
FOREIGN KEY ([Sale_EmplId]) REFERENCES [Employee].[Employee] (EmplId),
FOREIGN KEY ([PayPlanId]) REFERENCES [Policy].[PayPlan] (PayPlanId),
FOREIGN KEY ([Vin]) REFERENCES [Car].[Car] (Vin),
FOREIGN KEY ([ClosingDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([Months]) REFERENCES [Policy].[Term] (Months)
);
GO

CREATE UNIQUE INDEX UK_Policy_EmplId_ClosingDt_SaleCnt ON [Policy].[Policy] ([Sale_EmplId], [ClosingDt], [SaleCnt] );
GO

/* --------------------------------------------------------------------------------------------------------

select top 100 * from car.car
select Make, count(*) from car.car group by Make
-------------------------------------------------------------------------------------------------------- */


-- select top 100 * from [Policy].[Policy]

--******************************************
-- Pay Schema
--******************************************
CREATE Schema [Pay];
GO

---------------------------------------
-- drop table [Pay].[Sale]
-----------------------------------------
CREATE TABLE [Pay].[Sale]
(
	[PayPlanId]		[int]			NOT NULL,
	[Cnt]			[tinyint]		NOT NULL,
	[Multiplier]	[money]			NOT NULL,
	[Gravy]			[money]			NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Policy].[PayPlan] ( PayPlanId )
)
GO

CREATE UNIQUE INDEX PK_Pay_Sale ON [Pay].[Sale] ( [PayPlanId], [Cnt] );
GO

INSERT [Pay].[Sale] (PayPlanId, Cnt, Multiplier, Gravy)
select 1, 1,  90, 250 union
select 1, 2,  95, 250 union
select 1, 3, 115, 250 union
select 1, 4, 130, 250 union
select 1, 5, 150, 250 union
select 1, 6, 150, 250 -- need to figure out what the software does for sales beyond this - i.e., only keep the last number or 
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Pay].[SalePIF]
(
	[PayPlanId]		[int]			NOT NULL,
	[Discount]		[money]			NOT NULL,
	[Bonus]			[money]			NOT NULL,
FOREIGN KEY ([PayPlanId]) REFERENCES [Policy].[PayPlan] ( PayPlanId )
);
GO

CREATE UNIQUE INDEX PK_SalePIF ON [Pay].[SalePIF] (PayPlanId, Discount);
GO

INSERT [Pay].[SalePIF] (PayPlanId, Discount, Bonus)
select 1,   0, 450 union
select 1, 100, 440 union
select 1, 200, 420 union
select 1, 300, 380 union
select 1, 400, 340 union
select 1, 500, 300 union
select 1, 600, 260 union
select 1, 700, 230 union
select 1, 800, 210
;
GO

--------------------------------------------------
-- drop table [Employee].[GravyMod_Downpayment]
--------------------------------------------------
CREATE TABLE [Pay].[GravyMod_Payment]
(
	[PayPlanId]		[int]		NOT NULL,
	[Down]			[money]		NOT NULL,
	[Subtract]		[money]		NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Policy].[PayPlan] (PayPlanId)
)
GO

CREATE UNIQUE INDEX PK_GravyMod_Payment ON [Pay].[GravyMod_Payment] ( [PayPlanId], [Down] );
GO

INSERT [Pay].[GravyMod_Payment] (PayPlanId, Down, Subtract )
select 1, 995,  0 union
select 1, 895, 10 union
select 1, 795, 20 union
select 1, 695, 30 union
select 1, 595, 40 union
select 1, 495, 50 union
select 1, 395, 60 union
select 1, 295, 70 union
select 1, 195, 80;
go

---------------------------------------
--  This is the amonth that is discounted from the retail price
-----------------------------------------
CREATE TABLE [Pay].[GravyMod_Retail]
(
	[PayPlanId]			[int]		NOT NULL,
	[Discount]			[money]		NOT NULL,
	[Subtract]			[money]		NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Policy].[PayPlan] (PayPlanId)
);
GO

CREATE UNIQUE INDEX PK_GravyMod_Retail ON [Pay].[GravyMod_Retail] ( [PayPlanId], [Discount] );
GO

INSERT [Pay].[GravyMod_Retail] ( PayPlanId, Discount, Subtract )
select 1, 100, 5 union
select 1, 200, 15 union
select 1, 300, 35 union
select 1, 400, 55 union
select 1, 500, 75 union
select 1, 600, 95 union
select 1, 700, 115 union
select 1, 800, 130
;
GO

-- select * from [Pay].[GravyMod_Retail];

---------------------------------------
-- drop table [Employee].[GravyMod_Term]
-----------------------------------------
CREATE TABLE [Pay].[GravyMod_Term]
(
	[PayPlanId]			[int]		NOT NULL,
	[Months]			[smallint]	NOT NULL,
	[Subtract]			[money]		NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Policy].[PayPlan] (PayPlanId),
FOREIGN KEY ([Months]) REFERENCES [Policy].[Term] (Months)
);
GO

CREATE UNIQUE INDEX PK_GravyMod_Term ON [Pay].[GravyMod_Term] ( [PayPlanId], [Months] );
GO

INSERT [Pay].[GravyMod_Term] ( PayPlanId, Months, Subtract )
SELECT 1, 0,   0 union
SELECT 1, 6,   0 union
SELECT 1, 9,  10 union
SELECT 1, 12, 20 union
SELECT 1, 15, 30 union
SELECT 1, 18, 40 union
SELECT 1, 24, 40;
GO

------------------------------------------
-- 
------------------------------------------
/*
select * from [Policy].[PayPlan];
select * from [Pay].[GravyMod_Payment];
select * from [Pay].[GravyMod_Retail];
select * from [Pay].[GravyMod_Term];
select * from [Pay].[SalePIF];
select * from [Pay].[Sale]
*/
-- select * from pay.salebase

--*****************************
-- Clean Up
--*****************************
DROP table [dbo].[Tmp];
GO


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Put some sample in to get us going.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
SET IDENTITY_INSERT [Policy].[Policy] ON;

DECLARE @CompanyId_Sunpath int = (SELECT CompanyId FROM [Policy].[Company] WHERE Company = 'SunPath');
DECLARE @PayPlanId int = (SELECT PayPlanId from [Policy].[PayPlan] WHERE Name = 'Bizkit');
DECLARE @EmplId_Tawny int = (SELECT EmplId from [Employee].[Employee] WHERE FirstName = 'Tawney');
DECLARE @EmplId_Chainz int = (SELECT EmplId from [Employee].[Employee] WHERE FirstName = 'Chainz');
select @EmplId_Chainz

INSERT [Policy].[Policy] (	PolicyId, CompanyId, Front_EmplId, Sale_EmplId, PayPlanId, Vin, ClosingDt, SaleCnt, PaidInFull, Retail, [Retail++], Discount,
							TotalCost, AdminCost, GrossProfit, FirstPaymentDt, Months, PaymentFrequency )

SELECT	1 as PolicyId, @CompanyId_Sunpath as CompanyId, @EmplId_Chainz, @EmplId_Tawny as EmplId, @PayPlanId, '1FMEU75847UB32730' as VIN, '2015-03-27' as ClosingDt, 1 as SaleCnt, 'Y' as PaidInFull,
		2105 as Retail, 2600 as [Retail++], 500 as Discount, 1605 as TotalCost, 595 as AdminCost, 1010 as GrossProfit,
		'2015-03-27' as FirstPaymentDt, 0 as Months, 0 as PaymentFrequency

SET IDENTITY_INSERT [Policy].[Policy] OFF;

select * from Policy.Policy

-------------------------
-- Hire some screeners
-------------------------
select * from employee.employee

DECLARE @RoleId int = (SELECT RoleId from [Employee].[Role] WHERE Role = 'Screener')
DECLARE @RateId int = (SELECT RateId from [Employee].[Rate] WHERE Name = 'Probation')

INSERT [Employee].[Employee] (RoleId, RateId, FirstName, HireDt)
select @RoleId, @RateId, 'Kitty', '2015-04-15' union
select @RoleId, @RateId, 'Chad', '2015-04-15' union
select @RoleId, @RateId, 'Smith', '2015-04-15' union
select @RoleId, @RateId, 'Julie', '2015-04-15' union
select @RoleId, @RateId, 'Kelly', '2015-04-15'
GO

*/

/*
select * from Policy.Policy
select * from employee.employee
select * from employee.day
*/

-- add housrs worked
/*
truncate table [Employee].[Day];

DECLARE @EmplId_Chainz int = (SELECT EmplId from [Employee].[Employee] WHERE FirstName = 'Chainz');
select @EmplId_Chainz

insert [Employee].[Day] (EmplId, Dt, StartTm, EndTm, TransferCnt, CloseCnt)
select @EmplId_Chainz, '2015-03-26', '2015-03-26 9:45am', '2015-03-26 6:00pm', 2, 0 union
select @EmplId_Chainz, '2015-03-27', '2015-03-27 9:45am', '2015-03-27 6:00pm', 3, 1 union
select @EmplId_Chainz, '2015-03-30', '2015-03-30 10:20am', '2015-03-30 6:00pm', 1, 0 union
select @EmplId_Chainz, '2015-03-31', '2015-03-31 11:00am', '2015-03-30 6:00pm', 0, 0 union

select * from employee.day

select 2, '2015-04-13'
*/



