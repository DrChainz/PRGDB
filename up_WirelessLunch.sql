-- select * from Legend.State
-- select * from Legend.TimeZone;

/*
select State, count(*)
from QSM.CarData.Car
-- where Exclude = 'N'
  -- and Src <> 'Chip??'
group by State;

select State, Src, Exclude, count(*)
from qsm.Cardata.Car
where State in ('AK','HI')
group by State, Src, Exclude
*/

IF OBJECT_ID('up_WirelessLunch') IS NOT NULL
	DROP PROC up_WirelessLunch;
GO

CREATE PROC up_WirelessLunch
AS

SET NOCOUNT ON;

DECLARE @TimeZone varchar(4);

DECLARE tz_cursor CURSOR FOR 
SELECT TimeZone FROM Legend.TimeZone
WHERE TimeZone IN (SELECT DISTINCT TimeZone FROM Legend.State)
ORDER BY UTC_Offset desc;

OPEN tz_cursor;

FETCH NEXT FROM tz_cursor INTO @TimeZone;

WHILE @@FETCH_STATUS = 0
BEGIN
	exec [dbo].[up_MakeGoForte_DialSet_TimeZone] @TimeZone;

	if ((select count(*) from [PrivateReserve].[CarData].[GoForte_Extract]) > 0)
		exec [dbo].[up_ExtractGoForteSet] 'Y', 200000, @TimeZone;

	FETCH NEXT FROM tz_cursor INTO @TimeZone;
END 
CLOSE tz_cursor;
DEALLOCATE tz_cursor;
GO

exec up_WirelessLunch;