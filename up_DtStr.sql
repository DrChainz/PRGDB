IF OBJECT_ID(N'up_DtStr') IS NOT NULL
	DROP PROC up_DtStr;
GO

CREATE PROC up_DtStr
	@DtStr char(14) OUTPUT
AS
DECLARE @Year char(4) = (select cast(datepart(year, getdate()) as char(4)));
DECLARE @Month char(2) = substring(convert(varchar(6),getdate(), 112), 5,2);
DECLARE @MonthName char(3) = LEFT(datename(month,getdate()),3);
DECLARE @Day char(2) = RIGHT('00' + CONVERT(nvarchar(2), DATEPART(DAY, GETDATE())), 2);
-- DECLARE @DtStr char(14) = NULL

SELECT @DtStr = @Year + '_' + @Month + '_' + @MonthName + '_' + @Day;
-- print @DtStr;
RETURN;
GO

DECLARE @DtStr char(14);
exec up_DtStr @DtStr  OUTPUT;
select @DtStr;
-- select up_DtStr @xx;
