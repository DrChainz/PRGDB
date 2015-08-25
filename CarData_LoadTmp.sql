use CarLoadTest
go

create Schema Car;
GO

create table Car.tmpLoad_Init
(
	Firstname		varchar(50),
	Lastname		varchar(50),
	Address			varchar(100),
	City			varchar(50),
	State			char(2),
	Zip				varchar(10),
	Year			char(4),
	Make			varchar(30),
	Model			varchar(50),
	Vin				char(50),
	Phone			char(10)
);





create table Car.tmpLoad_Init
(
	Firstname		varchar(50),
	Lastname		varchar(50),
	Address			varchar(100),
	City			varchar(50),
	State			char(2),
	Zip				varchar(10),
	Year			char(4),
	Make			varchar(30),
	Model			varchar(50),
	Vin				char(50),
	Phone			char(10)
);



/*
drop table Car.tmpLoad;
create table Car.tmpLoad
(
	Firstname		varchar(50),
	Lastname		varchar(50),
	Address			varchar(100),
	City			varchar(50),
	State			char(2),
	Zip				varchar(10),
	Year			char(4),
	Make			varchar(30),
	Model			varchar(50),
	Vin				char(17),
	Phone			char(10)
);
GO
*/

/*
create table Car.Car
(
	ListId			int	NOT NULL,
	Vin				char(17),	
	Make			varchar(30),
	Model			varchar(50),
	Year			char(4),
	Firstname		varchar(50),
	Lastname		varchar(50),
	Address			varchar(100),
	City			varchar(50),
	State			char(2),
	Zip				varchar(10),
	Phone			char(10),
CONSTRAINT FK_ListId FOREIGN KEY (ListId) REFERENCES Car.List (ListId)
);
-- GO
*/


/*

select 'FirstName: ' + cast(max(len(FirstName)) as varchar(10)) from Car.tmpLoad union
select 'LastName: ' + cast(max(len(LastName)) as varchar(10)) from Car.tmpLoad union
select 'Address: ' + cast(max(len(Address)) as varchar(10)) from Car.tmpLoad union
select 'State: ' + cast(max(len(State)) as varchar(10)) from Car.tmpLoad union
select 'Zip: ' + cast(max(len(Zip)) as varchar(10)) from Car.tmpLoad union
select 'Year: ' + cast(max(len(Year)) as varchar(10)) from Car.tmpLoad union
select 'Make: ' + cast(max(len(Make)) as varchar(10)) from Car.tmpLoad union
select 'Model: ' + cast(max(len(Model)) as varchar(10)) from Car.tmpLoad union
select 'Vin: ' + cast(max(len(Vin)) as varchar(10)) from Car.tmpLoad union
select 'Phone: ' + cast(max(len(Phone)) as varchar(10)) from Car.tmpLoad;
*/

/*
drop table Car.ListSrc;

CREATE table Car.ListSrc
(
	Src				varchar(20)		NOT NULL UNIQUE,
CONSTRAINT PK_Src PRIMARY KEY CLUSTERED (Src)
);

Insert Car.ListSrc (Src)
select 'Powers' union
select 'Chip';
*/

-- drop table Car.List;

create table Car.List
(
	ListId			int				NOT NULL IDENTITY(1,1),
	FileName		varchar(255)	NOT NULL UNIQUE,
	FileDt			smalldatetime	NOT NULL,
	Src				varchar(20)		NOT NULL,
	Cnt				int				NOT NULL
CONSTRAINT PK_ListId PRIMARY KEY CLUSTERED (ListId),
CONSTRAINT FK_Src FOREIGN KEY (Src) REFERENCES Car.ListSrc (Src)
);


truncate table Car.tmpLoad;

insert Car.tmpLoad
select Firstname, Lastname, Address, City, State, Zip, Year, Make, Model, Vin, Phone
from Car.tmpLoad_Init
where len(Vin) = 17

select top 100 * from [Car].[tmpLoad] where LastName = 'CHILDS' and FirstName = 'MARGARET'
select count(*) FROM [Car].[tmpLoad]
-- select * from Car.Car

select * from Car.Car where Vin = '3C3CFFBRXCT101939'


select count(*) from Car.Car



insert Car.List (FileName, FileDt, Src, Cnt)
select 'John_300k_LA_WA_NJ_CO', '2015-07-17', 'Chip', 0
select * from Car.List order by ListId desc;

truncate table [Car].[tmpLoad];
insert [Car].[tmpLoad] (FirstName, LastName, Address, City, State, Zip, Year, Make, Model, Vin, Phone)
select	rtrim(FirstName) as FirstName, rtrim(LastName) as LastName, rtrim(Address) as Address, rtrim(City) as City,
		rtrim(State) as State, rtrim(Zip) as Zip, Year, rtrim(Make) as Make, rtrim(Model) as Model, rtrim(Vin) as Vin, rtrim(Phone) as Phone
from [Car].[tmpLoad_Init]
where len(Vin) = 17;

INSERT Car.Car (ListId, Vin, Make, Model, Year, FirstName, LastName, Address, City, State, Zip, Phone)
SELECT 101, Vin, Make, Model, Year, FirstName, LastName, Address, City, State, Zip, Phone
FROM [Car].[tmpLoad]


select count(*) from Car.Car


truncate table [Car].[tmpLoad];

select count(*) from Car.Car

declare @cnt table
(
	ListId	int,
	Cnt		int
);
insert @cnt
select ListId, count(*) from Car.Car group by ListId order by ListId desc;

update Car.List set Cnt = t.Cnt
from Car.List l, @cnt t
where l.ListId = t.ListId

select * from Car.List order by ListId desc;

select top 1000 * from Car.Car where ListId = 3;


delete Car.Car where len(Vin) <> 17;

select len(Vin) from Car.Car group by len(Vin)

select count(distinct Vin) from Car.Car

-- select top 0 * into Car.CarLoad from qsm.cardata.car

select Vin, max(ListId) as ListId
into tmpCarList
from Car.Car
group by Vin

truncate table Car.CarLoad;

insert Car.CarLoad (Vin)
select distinct Vin
from Car.Car
where listid = 65

create unique clustered index PK_Vin ON tmpCarList (Vin)


delete Car.CarLoad
from Car.CarLoad l, qsm.CarData.Car c
where l.Vin = c.Vin

select count(*) from Car.CarLoad

alter table Car.CarLoad add ListId int 

update Car.CarLoad set ListId = 65 --t.ListId
from Car.CarLoad l, tmpCarList t
where l.Vin = t.Vin

select count(*) from Car.CarLoad

select ListId, count(*)
from Car.CarLoad
group by ListId


select top 100 * from Car.CarLoad

select max(len(Address)) from Car.Car

select count(*) from Car.Car where len(Address) > 50;
select Year, count(*) from Car.Car group by Year;

update Car.CarLoad
	set Make = substring(c.Make,1,20),
		Model = substring(c.Model,1,30),
		Year = c.Year,
		FirstName = substring(c.FirstName,1,20),
		LastName = substring(c.LastName,1,30),
		Address1 = c.Address,
		City = substring(c.City,1,30),
		State = c.State,
		Zip = c.Zip,
		Phone = c.Phone,
		Exclude = 'N',
		Wireless = 'N',
		AnswerMachine = 'N',
		Hybrid = 'N',
		Sale = 'N'
from Car.CarLoad l, Car.Car c
where l.Vin = c.Vin
  and l.ListId = c.ListId
  and l.Address1 is NULL
  and len(Address) <= 50;


select count(*) from Car.CarLoad

select * from Car.CarLoad

select Exclude, count(*) from Car.CarLoad group by Exclude

select count(*) from Car.CarLoad

select * from Car.CarLoad

insert qsm.CarData.Car
select Vin, Make, Model, Year, FirstName, LastName, Address1, Address2, City, State, Zip, Phone, Odom, Exclude, Wireless, AddDt, 'N' as BizPhone, AnswerMachine, Hybrid, 'Powers' as Src, Sale
from Car.CarLoad


select AddDt, Src, count(*)
from qsm.CarData.Car
group by AddDt, Src
order by AddDt desc, Src

select count(*) from qsm.CarData.Car

update Car.Car set  FirstName = PRG.[dbo].[udf_TitleCase](FirstName),
					LastName = PRG.[dbo].[udf_TitleCase](LastName),
					Address = PRG.[dbo].[udf_TitleCase](Address),
					City = PRG.[dbo].[udf_TitleCase](City),
					Make = UPPER(Make)

select * from Car.Car where Make = 'GEO'


select * from car.car where Year = '0'

select Year, count(*) from car.car group by Year


select Make, count(*)
from Car.Car
where Make not in (select Make from qsm.CarData.Make)
group by Make
order by count(*) desc;

update Car.Car set Make = e.Make
from Car.Car c, qsm.CarData.MakeErr e
where c.Make = e.MakeErr;

update Car.Car set Model = e.Model
from Car.Car c, qsm.CarData.ModelErr e
where c.Make = e.Make
  and c.Model = e.ModelErr;


update Car.CarLoad set AddDt = '2015-08-20'


update Car.CarLoad set Hybrid = 'Y' where Model like '%hybrid%'

update Car.CarLoad set Wireless = 'Y'
from Car.CarLoad l, PrivateReserve.dnc.WirelessBlocks w
where substring(Phone,1,7) = w.PhoneBegin;

update Car.CarLoad set Wireless = 'Y'
from Car.CarLoad l, PrivateReserve.dnc.LandlineToWireless w
where l.Phone = w.Phone
  and l.Wireless = 'N'
;

update Car.CarLoad set Wireless = 'N'
from Car.CarLoad l, PrivateReserve.dnc.WirelessToLandline w
where l.Phone = w.Phone
  and l.Wireless = 'Y'
;





update Car.CarLoad set Exclude = 'Y'
from Car.CarLoad l, PrivateReserve.dnc.dnc_gov d
where l.Phone = d.Phone
  and l.Exclude = 'N';

--   and d.DispCd in ('DNC','NI');



select count(*) from Car.CarLoad where Address1 is null
delete Car.CarLoad where Address1 is null