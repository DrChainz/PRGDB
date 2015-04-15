USE PRG;
GO

-----------------------------------------------
--
-----------------------------------------------
IF OBJECT_ID(N'up_PayDay') IS NOT NULL
	DROP PROC UP_PayDay;
GO

CREATE PROC up_PayDay
	@PayPeriod smallint = 4
AS
	
	DECLARE @Year char(4) = (SELECT DatePart(Year,GETDATE()));
	DECLARE @PayPeriod_BeginDt smalldatetime;
	DECLARE @PayPeriod_EndDt smalldatetime;

-- 	select @Week;

	select * from Legend.Day
	where Year = @Year
	  and PayPeriod = @PayPeriod;

	/*
	select @PayPeriod_EndDt = (SELECT MAX(Dt) FROM [Legend].[Day] WHERE Year = @Year AND Week = @Week and Payday = 'Y');
	select @PayPeriod_EndDt;

	select * from Legend.Day
	where Dt = (@PayPeriod_EndDt - 14);
	*/

GO

-- select * from Legend.Day


exec up_PayDay 6;
