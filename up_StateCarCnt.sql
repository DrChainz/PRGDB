USE PRG;
GO

IF  OBJECT_ID(N'up_StateCarCnt') IS NOT NULL
	DROP PROC up_StateCarCnt;
GO

CREATE PROC up_StateCarCnt
	@CompleteState	CHAR(1) = 'Y'
AS

declare @s table
(
	State		char(2)
);

-- List of states where we have complete set of area codes
INSERT @s (State)
SELECT State
FROM [Legend].[AreaCdState]
WHERE AreaCd NOT IN (SELECT AreaCd FROM [DNC].[AreaCd])
GROUP BY State;

declare @I table
(
	State			char(2),
	StateName		varchar(50),
	IncludeCnt		int,
	ExcludeCnt		int,
	TotalCnt		int
);

IF @CompleteState = 'Y'
BEGIN
	insert @I (State, StateName)
	select s.State, s.Name
	from [Legend].[State] s
	where State not in (select State from @s)
	;
END
ELSE
BEGIN
	insert @I (State, StateName)
	select s.State, s.Name
	from [Legend].[State] s
END


declare @t table
(
	State	char(2),
	Exclude	char(1),
	Cnt		int
);

insert @t
select c.State, c.Exclude, count(*) Cnt
from PRG.Car.Car c, @I i
where c.State = i.State
group by c.State, c.Exclude

update @I set IncludeCnt = t.Cnt
from  @I i, @t t
where i.State = t.State
  and t.Exclude = 'N';

update @I set ExcludeCnt = t.Cnt
from  @I i, @t t
where i.State = t.State
  and t.Exclude = 'Y';

update @I set TotalCnt = IncludeCnt + ExcludeCnt;

select * from @I
where TotalCnt IS NOT NULL
order by TotalCnt asc;
GO

exec up_StateCarCnt 'N'