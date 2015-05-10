USE [QSM];
GO

CREATE PROC [dbo].[up_CleanUpAdd_NewCars]
	@tableName varchar(50)
AS

-------------------------------------------------------
-- All the New DNCs
-------------------------------------------------------
DECLARE @t TABLE
(
	Phone	char(10)		NOT NULL UNIQUE,
	DispCd	char(4)			NULL,
	CallTm	smalldatetime	NULL
);

DECLARE @SQL varchar(MAX);

SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET CallTm = cast(last_local_call_time as smalldatetime)';
EXEC (@SQL);

SELECT @SQL = 'INSERT @t (	Phone, CallTm ) select Phone_number, max(CallTm) FROM ' + QuoteName(@tableName) + ' ' +
			  'WHERE Status in ('DNC','NI','NOC','WN') AND Phone_number <> '0000000000'  AND Phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ' +
			  'GROUP BY phone_number';
EXEC (@SQL);

SELECT @SQL = 'CREATE INDEX FK_Phone'+ QuoteName(@tableName) + ' ON ' + QuoteName(@tableName) + ' (phone_number)';
EXEC (@SQL);

SELECT @SQL = 'UPDATE @t SET DispCd = x.status FROM @t, ' + QuoteName(@tableName) + ' x ' +
			  'WHERE @t.Phone = x.phone_number AND @t.CallTm = x.CallTm';
EXEC (@SQL);

DELETE @t
WHERE Phone in (select Phone from [PrivateReserve].[DNC].[DNC]);

EXEC [PrivateReserve].[dbo].[up_DNC_MakeLog];

INSERT [PrivateReserve].[DNC].[DNC] (Phone, DispCd, CallTm)
SELECT Phone, DispCd, CallTm
FROM @t;

EXEC [PrivateReserve].[dbo].[up_DNC_MakeLog];

---------------------------------------------------------------------------------------------
-- Fix some of the data in the newly loaded dataset
---------------------------------------------------------------------------------------------
SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET Wireless = 'N'';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET Wireless = 'Y' WHERE SUBSTRING(phone_number,1,7) IN (SELECT PhoneBegin FROM [PrivateReserve].[DNC].[WirelessBlocks])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET Wireless = 'Y' WHERE phone_number in (select phone from  [PrivateReserve].[DNC].[LandlineToWireless])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET Wireless = 'N' WHERE phone_number in (select phone from  [PrivateReserve].[DNC].[WirelessToLandline])';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET Make = model, model = vin, vin = year, year = mileage, mileage = custom1 WHERE len(vin) = 17 and len(year) = 17';
EXEC (@SQL);

SELECT @SQL = 'UPDATE ' + QuoteName(@tableName) + ' SET Make = model, model = vin, vin = year, year = mileage, mileage = custom1 WHERE len(vin) <> 17 and len(year) = 17';
EXEC (@SQL);

SELECT @SQL = 'DELETE ' + QuoteName(@tableName) + ' WHERE LEN(Vin) <> 17';
EXEC (@SQL);
			  
--*******************************************************
--** At this point all the data is in the Car table
--*******************************************************
UPDATE [QSM].[CarData].[Car] SET Exclude = 'N'
WHERE Exclude NOT IN ('Y','N');

UPDATE [QSM].[CarData].[Car] SET Exclude = 'Y'
WHERE Exclude = 'N'
  and Phone in [SELECT Phone FROM PrivateReserve].[DNC].[DNC]);

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
  
  
  