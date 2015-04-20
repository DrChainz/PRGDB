USE PRG;
GO

-- drop proc up_PayDay

-----------------------------------------------
--  This only applies to closers
-----------------------------------------------
IF OBJECT_ID(N'up_ClosePay') IS NOT NULL
	DROP PROC up_ClosePay;
GO

CREATE PROC up_ClosePay
	@Week	smallint = NULL,
	@Year	char(4) = NULL
AS
	IF @Year IS NULL
		SET @Year = DatePart(Year,GETDATE()); 

	IF(@Week IS NULL)
	BEGIN
		SET @Week = (SELECT (Week - 1) FROM Legend.Day WHERE Dt = cast(floor(cast(getdate() as float)) as smalldatetime));
	END

	IF(@Week < 1)
		SET @Week = 1;

	DECLARE @BeginDt smalldatetime = (select Min(Dt) FROM Legend.Day WHERE Year = @Year AND Week = @Week);
	DECLARE @EndDt smalldatetime = (select Max(Dt) FROM Legend.Day WHERE Year = @Year AND Week = @Week);

	DECLARE @rpt TABLE
	(
		Week		smallint,
		BeginDt		smalldatetime,
		EndDt		smalldatetime,
		EmplId		int
	);

	INSERT @rpt ( Week, BeginDt, EndDt)
	SELECT @Week, @BeginDt, @EndDt;
	
	SELECT * FROM @rpt;
GO

-- select * from Legend.Day


exec up_ClosePay 7;
