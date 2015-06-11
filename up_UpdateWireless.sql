
CREATE PROC up_UpdateWireless
AS
DECLARE @w TABLE (Phone CHAR(10) NOT NULL UNIQUE);

----------------------------
-- What Might be wireless
----------------------------
INSERT @w (Phone)
SELECT DISTINCT Phone
FROM [CarData].[Car]
WHERE Wireless = 'N'
  AND SUBSTRING(Phone,1,7) IN (SELECT PhoneBegin FROM [PrivateReserve].[DNC].[WirelessBlocks]);

INSERT @w (Phone)
SELECT DISTINCT Phone
FROM [CarData].[Car]
WHERE Wireless = 'N'
  AND Phone IN (SELECT Phone FROM [PrivateReserve].[DNC].[LandlineToWireless])
  AND Phone NOT IN (SELECT Phone FROM @w);

DELETE @w
WHERE Phone IN (select phone from  [PrivateReserve].[DNC].[WirelessToLandline]);

UPDATE [CarData].[Car] SET Wireless = 'Y'
WHERE Wireless = 'N'
  and Phone in (SELECT Phone FROM @w);
GO

exec up_UpdateWireless