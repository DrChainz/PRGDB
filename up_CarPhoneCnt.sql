-- select count(*) from Car.Car
use qsm;
go

IF OBJECT_ID(N'up_CarPhoneCnt') IS NOT NULL
	DROP PROC up_CarPhoneCnt;
GO

CREATE PROC up_CarPhoneCnt
	@StateCnt char(1) = 'N'
AS

DECLARE @Cnt TABLE
(
	AreaCd			char(3)			NOT NULL UNIQUE,
	HaveAreaCd		char(1)			NOT NULL,
	LandlineCnt		int				NOT NULL,
	LandlinePercent	numeric(5,3)	NULL,
	WirelessCnt		int				NOT NULL,
	WirelessPercent	numeric(5,3)	NULL,
	TotalCnt		int				NULL,
	TotalPercent	numeric(5,3)	NULL
);

DECLARE @CntState TABLE
(
	State			char(2)			NOT NULL UNIQUE,
	LandlineCnt		int				NOT NULL,
	LandlinePercent	numeric(5,3)	NULL,
	WirelessCnt		int				NOT NULL,
	WirelessPercent	numeric(5,3)	NULL,
	TotalCnt		int				NULL,
	TotalPercent	numeric(5,3)	NULL
);


IF (@StateCnt = 'N')
BEGIN
	insert @Cnt (AreaCd, HaveAreaCd, LandlineCnt, WirelessCnt)
	select substring(Phone,1,3) as AreaCd, 'N', 0, 0
	from [CarData].[Car]
	where Exclude = 'N'
	  and Phone like '[0-9][0-9][0-9]%'
	group by substring(Phone,1,3);

	DECLARE @tmp TABLE
	(
		AreaCd			char(3)	NOT NULL UNIQUE,
		Cnt				int		NOT NULL
	);

	UPDATE @Cnt set HaveAreaCd = 'Y'
	where AreaCd IN (SELECT AreaCd FROM [PrivateReserve].[CarData].[DNC_AreaCd]);

	insert @tmp (AreaCd, Cnt)
	select substring(Phone,1,3) as AreaCd, count(*)
	from [CarData].[Car]
	where Exclude = 'N'
	  and Wireless = 'N'
	group by substring(Phone,1,3)
	;

	update @Cnt set LandlineCnt = t.Cnt
	from @Cnt c, @tmp t
	where c.AreaCd = t.AreaCd;

	delete @tmp;

	insert @tmp (AreaCd, Cnt)
	select substring(Phone,1,3) as AreaCd, count(*)
	from [CarData].[Car]
	where Exclude = 'N'
	  and Wireless = 'Y'
	group by substring(Phone,1,3)
	;

	update @Cnt set WirelessCnt = t.Cnt
	from @Cnt c, @tmp t
	where c.AreaCd = t.AreaCd;

	update @Cnt SET TotalCnt = LandlineCnt + WirelessCnt;

	DECLARE @TotalLandlineCnt float = (SELECT SUM(LandlineCnt) FROM @Cnt);
	DECLARE @TotalWirelessCnt float = (SELECT SUM(WirelessCnt) FROM @Cnt);
	DECLARE @TotalCnt float = @TotalLandlineCnt + @TotalWirelessCnt;
	
	update @Cnt set LandlinePercent = cast((cast(LandlineCnt as float) / @TotalLandlineCnt) as numeric(4,3));
	update @Cnt set WirelessPercent = cast((cast(WirelessCnt as float) / @TotalWirelessCnt) as numeric(4,3));
	update @Cnt set TotalPercent = cast((cast(TotalCnt as float) / @TotalCnt) as numeric(4,3));

	select *
	from @Cnt
	order by LandlineCnt desc
	;
END
-- select top 1000 * from @Cnt;

IF (@StateCnt = 'Y')
BEGIN
	insert @CntState (State, LandlineCnt, WirelessCnt)
	select State, 0, 0
	from [CarData].[Car]
	where Exclude = 'N'
	group by State

	DECLARE @tmpState TABLE
	(
		State			char(3)	NOT NULL UNIQUE,
		Cnt				int		NOT NULL
	);

	insert @tmpState (State, Cnt)
	select State, count(*)
	from [CarData].[Car]
	where Exclude = 'N'
	  and Wireless = 'N'
	group by State
	;

	update @CntState set LandlineCnt = t.Cnt
	from @CntState c, @tmpState t
	where c.State = t.State;

	delete @tmpState;

	insert @tmpState (State, Cnt)
	select State, count(*)
	from [CarData].[Car]
	where Exclude = 'N'
	  and Wireless = 'Y'
	group by State
	;

	update @CntState set WirelessCnt = t.Cnt
	from @CntState c, @tmpState t
	where c.State = t.State;

	update @CntState set TotalCnt = LandlineCnt + WirelessCnt;

	DECLARE @TotalStateLandlineCnt float = (SELECT SUM(LandlineCnt) FROM @CntState);
	DECLARE @TotalStateWirelessCnt float = (SELECT SUM(WirelessCnt) FROM @CntState);
	DECLARE @TotalStateCnt float = @TotalStateLandlineCnt + @TotalStateWirelessCnt;
	
	update @CntState set LandlinePercent = cast((cast(LandlineCnt as float) / @TotalStateLandlineCnt) as numeric(4,3));
	update @CntState set WirelessPercent = cast((cast(WirelessCnt as float) / @TotalStateWirelessCnt) as numeric(4,3));
	update @CntState set TotalPercent = cast((cast(TotalCnt as float) / @TotalStateCnt) as numeric(4,3));


	----------------------------------------------------
	-- Rpt
	----------------------------------------------------
	select c.State, s.Name, c.LandlineCnt, c.LandlinePercent, c.WirelessCnt, c.WirelessPercent, c.TotalCnt, c.TotalPercent
	from @CntState c, Legend.State s
	where c.State = s.State
	  and c.State <> 'MO'
	order by LandlineCnt desc
	;
END

-- select top 100 * from Legend.State
go

exec up_CarPhoneCnt 'Y';
go
