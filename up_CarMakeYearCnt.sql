IF OBJECT_ID(N'up_CarMakeYearCnt') IS NOT NULL
	DROP PROC up_CarMakeYearCnt;
GO

CREATE PROC  up_CarMakeYearCnt
AS

DECLARE @tmp TABLE
(
	Make	varchar(20)	NOT NULL,
	Year	char(4)		NOT NULL,
	Wireless	char(1)	NOT NULL,
	Cnt			int		NOT NULL
);

INSERT @tmp (Make, Year, Wireless, Cnt)
SELECT Make, Year, Wireless, count(*) Cnt
FROM [QSM].[CarData].[Car]
WHERE Make in (select Make from [QSM].[CarData].[Make])
  and Make not in (select Make from [PRG].[Car].[MakeExclude])
  and Year in (select year from [PrivateReserve].[Car].[Year])
  and Exclude <> 'Y'
GROUP BY Year, Make, Model, Wireless;

DECLARE @Rpt TABLE
(
	Make	varchar(20)	NOT NULL,
	Year	char(4)		NOT NULL,
	Landline	int		NOT NULL,
	Wireless	int		NOT NULL,
	Total		int		NOT NULL
);

INSERT @Rpt (Make, Year, Landline, Wireless, Total)
SELECT DISTINCT Make, Year, 0,0,0
FROM @tmp;

UPDATE @Rpt set Landline = t.Cnt
FROM @Rpt r, @tmp t
where r.Make = t.Make
  and r.Year = t.Year
  and t.Wireless = 'N';

UPDATE @Rpt set Wireless = t.Cnt
FROM @Rpt r, @tmp t
where r.Make = t.Make
  and r.Year = t.Year
  and t.Wireless = 'Y';

UPDATE @Rpt set Total = Landline + Wireless;

SELECT * from @Rpt
ORDER BY Make, Year;
GO

exec up_CarMakeYearCnt;