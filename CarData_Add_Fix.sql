use CarLoadTest
go

create Schema Car;
GO

drop table Car.tmpLoad_Init
create table Car.tmpLoad_Init
(
	Firstname		varchar(50),
	Address			varchar(100),
	City			varchar(50),
	State			char(20),
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





insert Car.List (FileName, FileDt, Src, Cnt)
select '082015 UAA aw data 100krecs', '2015-08-20', 'Powers', 0

select * from Car.List order by ListId desc;

-- delete Car.List where ListId = 46;



select * into Car.Car_backup_2015_08_Aug_18 from [QSM].[CarData].[Car]


alter table qsm.cardata.car add Src varchar(10) NULL

select top 10 * from qsm.cardata.car


select AddDt, Src, count(*)
from qsm.cardata.car
group by Src, adddt;

select Wireless, count(*)
from qsm.CarData.Car
where Exclude = 'N'
  and Src <> 'Chip??'
group by Wireless


update qsm.cardata.car set Src = 'Powers'
from qsm.cardata.car c, Car.Car x
where c.AddDt between '2015-08-04' and '2015-08-12'
  and c.Vin = x.Vin


update qsm.CarData.Car set Src = 'Chip??'
where AddDt = '2015-08-14' -- and '2015-08-12'
  and Src IS NULL




create index PK_XX ON Car.Car (Vin)


select * into CarData

select top 100 * from [Car].[tmpLoad] where LastName = 'CHILDS' and FirstName = 'MARGARET'
select count(*) FROM [Car].[tmpLoad]
-- select * from Car.Car

select * from Car.Car where Vin = '3C3CFFBRXCT101939'

truncate table Car.tmpLoad;
insert Car.tmpLoad
select Firstname, Lastname, Address, City, State, Zip, Year, Make, Model, Vin, Phone
from Car.tmpLoad_Init
where len(Vin) = 17

select top 100 * from Car.tmpLoad

select * from Car.List order by ListId desc;

select top 10 * from Car.Car where ListId = 62


INSERT Car.Car (ListId, Vin, Make, Model, Year, FirstName, LastName, Address, City, State, Zip, Phone)
SELECT 65, Vin, Make, Model, Year, FirstName, LastName, Address, City, State, Zip, Phone
FROM [Car].[tmpLoad]

truncate table [Car].[tmpLoad];

select count(*) from Car.Car

select ListId, count(*) from Car.Car group by ListId order by ListId desc;

select top 1000 * from Car.Car where ListId = 3;


select * from Car.Car where ListId = 58


select * from Car.Car where Vin = '1GCEC14X09Z101090'

select Vin, count(*)
from Car.Car
where ListId >= 54
group by Vin
having count(*) > 1

truncate table Car.tmpLoad;

insert Car.tmpLoad (Vin)
select distinct Vin from Car.Car where ListId >= 54

delete Car.tmpLoad
from Car.tmpLoad l, Car.Car c
where l.Vin = c.Vin


select count(*) from Car.tmpLoad


select * from PrivateReserve.Legend.TimeZone order by UTC_Offset desc;

