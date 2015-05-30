USE [QSM]
GO

/****** Object:  StoredProcedure [dbo].[up_CleanUpAdd_NewCars]    Script Date: 5/19/2015 1:58:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[up_CleanUpAdd_NewCars]
	@tableName varchar(50)
AS
DECLARE @SQL varchar(MAX);

/*
SELECT QuoteName(@tableName);
SELECT @SQL = 'SELECT TOP 100 * FROM ' + @tableName;
PRINT @SQL;
EXEC (@SQL);
--  SELECT TOP 100 * FROM [CarData].[CarData_2015_05_May_09]
RETURN;
*/

IF OBJECT_ID(N'tmp_DNC_Load') IS NOT NULL
	DROP TABLE tmp_DNC_Load;

CREATE TABLE tmp_DNC_Load
(
	Phone	char(10)		NOT NULL UNIQUE,
	DispCd	char(4)			NULL,
	CallTm	smalldatetime	NULL
);

SELECT @SQL = 'UPDATE ' + @tableName + ' SET CallTm = cast(last_local_call_time as smalldatetime)';
EXEC (@SQL);

SELECT @SQL = 'INSERT tmp_DNC_Load (Phone, CallTm ) select Phone_number, max(CallTm) FROM ' + @tableName + ' ' +
			  'WHERE Status in (''DNC'',''NI'',''NOC'',''WN'') AND Phone_number <> ''0000000000''  AND Phone_number like ''[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'' ' +
			  'GROUP BY phone_number';
EXEC (@SQL);

SELECT @SQL = 'CREATE INDEX FK_Phone' + RTRIM(CAST(FLOOR(CAST(GETDATE() AS FLOAT)) AS VARCHAR(10))) + ' ON ' + @tableName + ' (phone_number)';
EXEC (@SQL);

SELECT @SQL = 'UPDATE tmp_DNC_Load SET DispCd = x.status FROM tmp_DNC_Load t, ' + @tableName + ' x ' +
			  'WHERE t.Phone = x.phone_number AND t.CallTm = x.CallTm' +
			  ' AND Status in (''DNC'',''NI'',''NOC'',''WN'') ';
EXEC (@SQL);


DELETE tmp_DNC_Load
WHERE Phone in (select Phone from [PrivateReserve].[DNC].[DNC]);

DELETE tmp_DNC_Load
WHERE DispCd NOT IN ('DNC','NI','NOC','WN');

-- select top 100 * from tmp_DNC_Load

EXEC [PrivateReserve].[dbo].[up_DNC_MakeLog];

INSERT [PrivateReserve].[DNC].[DNC] (Phone, DispCd, CallTm)
SELECT Phone, DispCd, CallTm
FROM tmp_DNC_Load;

EXEC [PrivateReserve].[dbo].[up_DNC_MakeLog];

/*
SELECT * from PrivateReserve.DNC.DNC_Log
order by Dt
*/

-- RETURN;


---------------------------------------------------------------------------------------------
-- Fix some of the data in the newly loaded dataset
---------------------------------------------------------------------------------------------
SELECT @SQL = 'UPDATE ' + @tableName + ' SET Wireless = ''N''';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + @tableName + ' SET Wireless = ''Y'' WHERE SUBSTRING(phone_number,1,7) IN (SELECT PhoneBegin FROM [PrivateReserve].[DNC].[WirelessBlocks])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + @tableName + ' SET Wireless = ''Y'' WHERE phone_number in (select phone from  [PrivateReserve].[DNC].[LandlineToWireless])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + @tableName + ' SET Wireless = ''N'' WHERE phone_number in (select phone from  [PrivateReserve].[DNC].[WirelessToLandline])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + @tableName + ' SET Make = model, model = vin, vin = year, year = mileage, mileage = custom1 WHERE len(vin) = 17 and len(year) = 17';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + @tableName + ' SET Make = model, model = vin, vin = year, year = mileage, mileage = custom1 WHERE len(vin) <> 17 and len(year) = 17';
EXEC (@SQL);

SELECT @SQL = 'DELETE ' + @tableName + ' WHERE LEN(Vin) <> 17';
EXEC (@SQL);

-----------------------------------------------------------------------------------------------------
-- Put the new data into the main car table
-----------------------------------------------------------------------------------------------------
INSERT [QSM].[CarData].[Car_Log] (Dt, CarCnt) SELECT GETDATE(), COUNT(*) FROM [QSM].[CarData].[Car];
TRUNCATE TABLE [QSM].[CarData].[tmpCar];

SELECT @SQL = 'INSERT [QSM].[CarData].[tmpCar] (Vin) SELECT DISTINCT Vin FROM ' + @tableName + ' ' +
			  'WHERE Vin NOT IN (SELECT Vin FROM [QSM].[CarData].[Car]) AND len(vin) = 17 AND phone_number like ''[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'' ' +
			  '  AND State IN (SELECT State FROM Legend.State) AND Year IN (SELECT Year from CarData.Year)' +
			  '  AND Make IN (SELECT Make FROM [CarData].[MakeInclude])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE [CarData].[tmpCar] ' +
			  ' SET make = substring(x.Make,1,20), ' +
			  '		model = substring(x.Model,1,30), ' +
			  '		year = substring(x.year,1,4), ' +
			  '		FirstName = substring(x.First_name,1,20), ' +
			  '		LastName = substring(x.last_name,1,30), ' + 
			  '		Address1 = substring(x.Address1,1,50), ' +
			  '		Address2 = substring(x.Address2,1,50), ' +
			  '		City = substring(x.City,1,30), ' +
			  '		State = substring(x.State,1,2), ' +
			  '		Zip = substring(x.Postal_code,1,10), ' +
			  '		Phone = substring(x.phone_number,1,10), ' +
			  '		Odom = substring(x.Mileage,1,10), ' +
			  '		Exclude = ''N'', ' +
		      '		Wireless = x.Wireless ' +
'FROM [CarData].[tmpCar] t, ' + @tableName + ' x ' +
'WHERE t.Vin = x.Vin ' +
 ' AND x.State IN (SELECT State FROM Legend.State) ' +
 ' AND phone_number LIKE ''[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'' ' +
 ' AND x.Year IN (SELECT Year FROM CarData.Year)';
  EXEC (@SQL);

--------------------------------
-- Put it in there
--------------------------------
INSERT [CarData].[Car]
SELECT * FROM [CarData].[tmpCar];
			  
--*******************************************************
--** At this point all the data is in the Car table
--*******************************************************
UPDATE [QSM].[CarData].[Car] SET Exclude = 'N'
WHERE Exclude NOT IN ('Y','N');

UPDATE [QSM].[CarData].[Car] SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND Phone IN (SELECT Phone FROM [PrivateReserve].[DNC].[DNC]);

------------------------------------------------------  
-- Maybe do something to deal with the wireless thing
------------------------------------------------------  
  
---------------------------------------------------------
-- Clean up any Make/Model garbage
---------------------------------------------------------
UPDATE [QSM].[CarData].[Car]
	SET Make = e.Make
FROM [QSM].[CarData].[Car] c, [QSM].[CarData].[MakeErr] e
WHERE c.Make NOT IN (select Make from CarData.Make)
  AND c.Make = e.MakeErr;

UPDATE [QSM].[CarData].[Car]
	SET Model = e.Model
FROM [QSM].[CarData].[Car] c, [CarData].[ModelErr] e
WHERE c.Make = e.Make
  AND c.Model = e.ModelErr;
  
---------------------------------------------------------
-- Exclude business entries
---------------------------------------------------------
UPDATE [QSM].[CarData].[Car]
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName LIKE '% inc%';

UPDATE [QSM].[CarData].[Car]
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND ( LastName like '% co %' OR LastName like '% co');

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%SHERIFF OFF%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%CONSTRUCTION%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%TRANSPORTATION%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  and FirstName = 'ITQ-DCC'

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  and FirstName = 'VALUED'

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  and FirstName = 'VALUED SUBSCRIBER'
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%ENTERPRISE%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% COOLING%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% HEATING%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% ELECTRIC%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% SHOP%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% COLLISON %';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% ERECTORS %';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% IMPORTS %';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% CONTRACTING%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% DRYWALL%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% HOLDING%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% ENERGY%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% DEBT%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% OIL%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
    AND LastName like '% ARMY%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% LAW %';	
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% TRAINING %';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%SAFETY%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
    AND LastName like '%ACCOUNTING%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%SERVICES%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%HOIST%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%COMPLIANCE%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%VEHICLE%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%RENTAL%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%FOUNDATION%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%EQUIPMENT%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%UNIVERSITY%';  

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%ROOFING%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%GROUP%';  

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%LABORATORIES%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
   AND LastName like '%PUBLIC SCHOOL%'; 
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%EXCAVATING%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%SECURITY%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%Hospital%';
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%COSOLIDATED%';

UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '%CONSTRUCTION%';  
  
UPDATE [QSM].[CarData].[Car]  
	SET Exclude = 'Y'
WHERE Exclude = 'N'
  AND LastName like '% LLC';  
  
---------------------------------------------------------
--  Now we are ready to use the new car data
---------------------------------------------------------

GO

