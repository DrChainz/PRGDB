USE [QSM]
GO

SELECT * FROM [CarData].[CarData_2015_08_Aug_12]

update [CarData].[CarData_2015_08_Aug_12] set HaveIt = 'N'

select Vin, count(*) from [CarData].[CarData_2015_08_Aug_12] group by Vin having count(*) > 1 


select * from [CarData].[CarData_2015_08_Aug_12]
where vin = '1FTEW1CM9BKD67494'


update select * from [CarData].[CarData_2015_08_Aug_12]


-- select top 0 * into [CarData].[CarData_2015_08_Aug_12_unique] from [CarData].[CarData_2015_08_Aug_12]

insert [CarData].[CarData_2015_08_Aug_12_unique] (Vin)
select distinct Vin
from [CarData].[CarData_2015_08_Aug_12]

update [CarData].[CarData_2015_08_Aug_12_unique]
	set FirstName = x.FirstName,
		LastName = x.LastName,
		Address = x.Address,
		City = x.City,
		State = x.State,
		Zip = x.Zip,
		Year = x.Year,
		Make = x.Make,
		Model = x.Model,
		Phone = x.Phone
from [CarData].[CarData_2015_08_Aug_12_unique] u, [CarData].[CarData_2015_08_Aug_12] x
where u.Vin = x.Vin

create unique index PKXX ON [CarData].[CarData_2015_08_Aug_12_unique] (Vin)

update [CarData].[CarData_2015_08_Aug_12_unique] set HaveIt = 'Y'
from [CarData].[CarData_2015_08_Aug_12_unique] u, CarData.Car c
where u.Vin = c.Vin


alter table [CarData].[CarData_2015_08_Aug_12] add Dup char(1);

update [CarData].[CarData_2015_08_Aug_12] set Dup = 'N'

update [CarData].[CarData_2015_08_Aug_12] set Dup = 'Y'
where Vin in (select Vin from [CarData].[CarData_2015_08_Aug_12] group by Vin having count(*) > 1)

alter table [CarData].[CarData_2015_08_Aug_12] add Dup2 char(1)

update [CarData].[CarData_2015_08_Aug_12] set Dup2 = 'Y' where Dup = 'Y'

select Dup, Dup2, count(*)
from [CarData].[CarData_2015_08_Aug_12]
group by Dup, Dup2



update [dbo].[udf_TitleCase]

update CarData.CarAux
	set Make = UPPER(Make),
		FirstName = [PRG].[dbo].[udf_TitleCase](FirstName), 
		LastName  = [PRG].[dbo].[udf_TitleCase](LastName), 
		Address1  = [PRG].[dbo].[udf_TitleCase](Address1), 
		City  = [PRG].[dbo].[udf_TitleCase](City)


select * from CarData.CarAux


select * from [CarData].[CarAdd]

insert [CarData].[CarAdd] (AddDt, Src)
select AddDt, 'CT' -- count(*)
from CarData.Car
where AddDt > '2015-08-06'
group by AddDt
order by AddDt


select AddDt, count(*)
from CarData.Car
group by AddDt
order by AddDt


select top 1000 * from CarData.Car where AddDt = '2015-08-12 00:00:00'


update CarData.Car
	set Make = UPPER(Make),
		FirstName = [PRG].[dbo].[udf_TitleCase](FirstName), 
		LastName  = [PRG].[dbo].[udf_TitleCase](LastName), 
		Address1  = [PRG].[dbo].[udf_TitleCase](Address1), 
		City  = [PRG].[dbo].[udf_TitleCase](City)
where AddDt = '2015-08-12 00:00:00'




select * from [CarData].[CarData_2015_08_Aug_12]
where Dup = 'Y' and Dup2 = 'N'




insert CarData.CarAux (Vin, Phone, AddDt, Make, Model, Year, FirstName, LastName, Address1, City, State, Zip, Exclude, Wireless, AnswerMachine, Hybrid)


select Vin, Phone, '2015-08-12', Make, Model, Year, FirstName, LastName, Address, City, State, Zip, 'N', 'N', 'N', 'N'
from [CarData].[CarData_2015_08_Aug_12]
where Dup = 'Y' and Dup2 = 'N'



select * from CarData.CarAux



-- create unique clustered index PK_CarAux ON CarData.CarAux (Vin, Phone)



update [CarData].[CarData_2015_08_Aug_12] set Dup2 = 'N'
from [CarData].[CarData_2015_08_Aug_12] x, CarData.Car c
where x.Vin = c.Vin
  and x.Phone = c.Phone

Dup = 'Y'
  and Vin not in (select Vin from CarData.Car)




select HaveIt, count(*)
from [CarData].[CarData_2015_08_Aug_12_unique]
group by HaveIt


alter table [CarData].[CarData_2015_08_Aug_12_unique] add Exclude char(1), Wireless char(1)


update [CarData].[CarData_2015_08_Aug_12_unique] set Exclude = 'N', Wireless = 'N'


update [CarData].[CarData_2015_08_Aug_12_unique] set Exclude = 'Y'
from [CarData].[CarData_2015_08_Aug_12_unique] u, PrivateReserve.dnc.dnc d
where d.DispCd in ('DNC','NI')
  and d.Phone = u.Phone


update [CarData].[CarData_2015_08_Aug_12_unique] set Exclude = 'Y'
from [CarData].[CarData_2015_08_Aug_12_unique] u, PrivateReserve.dnc.dnc_gov d
where u.Exclude = 'N'
  and d.Phone = u.Phone


select Exclude, count(*)
from [CarData].[CarData_2015_08_Aug_12_unique]
where HaveIt = 'N'
group by Exclude

update [CarData].[CarData_2015_08_Aug_12_unique] set Wireless = 'Y'
where substring(Phone,1,7) in (select PhoneBegin from PrivateReserve.[DNC].[WirelessBlocks]);


update [CarData].[CarData_2015_08_Aug_12_unique] set Make = e.Make
from [CarData].[CarData_2015_08_Aug_12_unique] u, CarData.MakeErr e
where u.Make = e.MakeErr

update [CarData].[CarData_2015_08_Aug_12_unique] set Model = e.Model
from [CarData].[CarData_2015_08_Aug_12_unique] u, CarData.ModelErr e
where u.Make = e.Make
  and u.Model = e.ModelErr

update [CarData].[CarData_2015_08_Aug_12_unique] set Make = Upper(Make)


truncate table CarData.Car_Load;

insert CarData.Car_Load (Vin, Make, Model, Year, FirstName, LastName, Address1, City, State, Zip, Phone,Exclude, Wireless, AddDt, BizPhone, AnswerMachine, Hybrid)
select Vin, Make, Model, Year, FirstName, LastName, Address, City, State, Zip, Phone,Exclude, Wireless, '2015-08-12' AddDt, 'N', 'N', Hybrid
from [CarData].[CarData_2015_08_Aug_12_unique]
where HaveIt = 'N'
  and

select * from CarData.Car_Load
where Exclude = 'N'


insert CarData.Car
select * from CarData.Car_Load


select count(*) from CarData.Car


update CarData.Car
set Address1 = u.Address
from CarData.Car c, [CarData].[CarData_2015_08_Aug_12_unique] u
where c.Vin = u.Vin
  and (c.Address1 IS NULL OR c.Address1 = '')
  and u.Address IS NOT NULL AND u.Address <> ''


update CarData.Car
set City = u.City
from CarData.Car c, [CarData].[CarData_2015_08_Aug_12_unique] u
where c.Vin = u.Vin
  and (c.City IS NULL OR c.City = '')
  and u.City IS NOT NULL AND u.City <> ''






  select * from [CarData].[CarData_2015_08_Aug_12_unique] where len(Address) = 50

  update [CarData].[CarData_2015_08_Aug_12_unique] set Address = '5757 Westheimer Rd Suite 3159' where len(Address) = 52

select max(len(Address)) --- , count(*)
from [CarData].[CarData_2015_08_Aug_12_unique]
-- group by len(Vin)



update [CarData].[CarData_2015_08_Aug_12_unique] set Hybrid = 'N'


update [CarData].[CarData_2015_08_Aug_12_unique] set Wireless = 'N'
where Wireless = 'Y'
  and Phone in (select Phone from [PrivateReserve].[DNC].[WirelessToLandline])
/*
CREATE TABLE [CarData].[CarData_2015_08_Aug_12]
(
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Address] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](50) NULL,
	[Year] [varchar](20) NULL,
	[Make] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[Vin] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[HaveIt] [char](1) NULL
) ON [PRIMARY]
-- GO
*/
