USE PrivateReserve;
GO

select top 100 * from [DNC].[WirelessBlocks]
update [DNC].[WirelessBlocks] set PhoneBegin = NPA + NXX + X;


-------------------------------------------------------------
-- 
-------------------------------------------------------------
IF OBJECT_ID(N'up_MakeWirelessLoadLogEntry') IS NOT NULL
	DROP PROC up_MakeWirelessLoadLogEntry;
GO

CREATE PROC up_MakeWirelessLoadLogEntry
AS
	DECLARE @Today smalldatetime = cast(floor(cast(getdate() as float)) as smalldatetime);
	DECLARE @WirelessCnt int = (select count(*) from [DNC].[WirelessBlocks]);
	DECLARE @WirelessToLandlineCnt int = (select count(*) from [DNC].[WirelessToLandline]);
	DECLARE @LandlineToWirelessCnt int = (select count(*) from [DNC].[LandlineToWireless]);

	-- not best place for this thou work well enough for now.
	UPDATE [QSM].[CarData].[Car] SET Wireless = 'Y'
	WHERE Wireless = 'N'
	  and substring(Phone,1,7) in (SELECT PhoneBegin FROM [PrivateReserve].[DNC].[WirelessBlocks])

	DELETE [DNC].[Wireless_LoadLog] WHERE LoadDt = @Today;

	INSERT [DNC].[Wireless_LoadLog] (LoadDt, WirelessCnt, WirelessToLandlineCnt, LandlineToWirelessCnt)
	SELECT @Today, @WirelessCnt, @WirelessToLandlineCnt, @LandlineToWirelessCnt;
GO

exec up_MakeWirelessLoadLogEntry;

select * from [DNC].[Wireless_LoadLog]