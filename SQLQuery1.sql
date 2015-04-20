select top 100 *
from [CarData].[CarPhone]
where state not in (select State FROM [PRG].[Legend].[State])


alter table [CarData].[CarPhone] add Wireless char(1) NULL

update [CarData].[CarPhone] set Wireless = 'Y'
where substring(Phone,1,7) in (select PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks])


select Year, count(*) from cardata.car group by Year

select top 100 * from cardata.car
where Make = 'RAM'

select top 100 * from cardata.car
where Make in (select MakeErr from prg.Car.MakeErr)

update Cardata.Car set Make = e.Make
from CarData.Car c, PRG.Car.MakeErr e
where c.Make = e.MakeErr

select Make, Model, count(*)
from CarData.Car
where Exclude = 'N'
  and Make not in (select Make from PRG.Car.Make)
group by Make, Model




update CarData.Car set Make = 'MERCEDES BENZ'
where Make = '' and Model = ''

update CarData.Car set Make = Model, Model = Make
where Exclude = 'N'
  and Make not in (select Make from PRG.Car.Make)
 and Model in ('MERCEDES BENZ','MERCEDES B')


update CarData.Car set Exclude = 'Y'
where Exclude = 'N'
  and Make not in (select Make from PRG.Car.Make)




update cardata.car set Make = 'Dodge' where Make = 'RAM'

select * from cardata.car where phone = '2819327473'

select top 10 * from go_for

--  select top 100 PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks]

select Wireless, count(*)
from [CarData].[CarPhone]
group by Wireless

---------------------------------------
--
-----------------------------------------
/*
CREATE TABLE [CarData].[Year]
(
	Year		char(4)		NOT NULL UNIQUE
);
-- GO

INSERT [CarData].[Year] (Year)
SELECT '2005' UNION
SELECT '2006' UNION
SELECT '2007' UNION
SELECT '2008' UNION
SELECT '2009' UNION
SELECT '2010' UNION
SELECT '2011' UNION
SELECT '2012' UNION
SELECT '2013' UNION
SELECT '2014' UNION
SELECT '2015';
-- GO
*/




select count(*) from car.car





elect distinct substring(Phone,1,3) as AreaCd, State
into [CarData].[AreaCdState]
from [CarData].[CarPhone]
where state in (select State FROM [PRG].[Legend].[State])
  and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'


update [CarData].[CarPhone]

  select top 1000 * from [CarData].[AreaCdState]

select top 100 * from [PrivateReserve].[DNC].[WirelessBlocks]

update cardata.car set Make = 'INFINITI'
where make = 'INFINITY'


select Len(vin), count(*)
from cardata.car
group by len(vin)




update cardata.car set make = upper(Make);


  create unique index PK_AreaCdState ON [CarData].[AreaCdState] (AreaCd)

  select AreaCd, State
  from [CarData].[AreaCdState]
  where AreaCd in (select AreaCd from [CarData].[AreaCdState] group by AreaCd having count(*) > 1)
order by AreaCd

  delete [CarData].[AreaCdState] where areaCd = '100'