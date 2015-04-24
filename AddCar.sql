select count(*) from [CarData].[CarData_2015_04_Apr_20]


select top 100 * from [CarData].[CarData_2015_04_Apr_20]

alter table [CarData].[CarData_2015_04_Apr_20] add Wireless char(1) NULL

update [CarData].[CarData_2015_04_Apr_21] set Wireless = 'N'


update [CarData].[CarData_2015_04_Apr_21] set Wireless = 'Y'
where substring(phone_number,1,7) in (select PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks])

update [CarData].[CarData_2015_04_Apr_21] set Wireless = 'Y'
where phone_number in (select phone from  [PrivateReserve].[DNC].[LandlineToWireless])


update [CarData].[CarData_2015_04_Apr_21] set Wireless = 'N'
where phone_number in (select phone from  [PrivateReserve].[DNC].[WirelessToLandline])


select count(*) from [PrivateReserve].[Car].[Car]
select count(*) from [QSM].[CarData].[Car]

select Year, count(*) from [CarData].[CarData_2015_04_Apr_20]
group by Year 


select Year from CarData.Year

select top 100 * from QSM.CarData.Car

-- select top 0 * into [CarData].[CarData_2015_04_Apr_21] from [CarData].[CarData_2015_04_Apr_20]

select top 1000 * from [CarData].[CarData_2015_04_Apr_21]
where len(vin) = 0

select len(vin), count(*)
from [CarData].[CarData_2015_04_Apr_21]
group by len(vin)

delete [CarData].[CarData_2015_04_Apr_21]
where len(vin) = 0

delete [CarData].[CarData_2015_04_Apr_21]
where Vin in (select Vin from [CarData].[Car])

update [CarData].[Cartmp]
[CarData].[CarData_2015_04_Apr_21]



-- truncate table [CarData].[CarData_2015_04_Apr_21]


-------------------------------------------------------
--
-------------------------------------------------------
INSERT QSM.CarData.Car (vin, make, model, year, FirstName, LastName, Address1, Address2, City, State, Zip, Phone, Odom, Exclude, Wireless)
select Vin, substring(Make,1,20), substring(Model,1,30), Year, substring(First_name,1,20) as FirstName,
			substring(last_name,1,30) as LastName, substring(Address1,1,50), substring(Address2,1,50),
			substring(City,1,30), State, substring(postal_code,1,10) as Zip, Phone_number as Phone,
			substring(Mileage,1,10) as Odom, 'N' as Exclude, Wireless
FROM [CarData].[CarData_2015_04_Apr_20]
where Vin not in (select vin from [QSM].[CarData].[Car])
  and State in (select State from Legend.State)
  and Year in (select Year from CarData.Year)


-- select top 0 * into [CarData].[tmpCar] from [CarData].[Car]
truncate table [CarData].[tmpCar];

insert [CarData].[tmpCar] (vin)
select distinct Vin
FROM [CarData].[CarData_2015_04_Apr_21]
where Vin not in (select vin from [QSM].[CarData].[Car])
  and State in (select State from Legend.State)
  and phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and Year in (select Year from CarData.Year)


update [CarData].[tmpCar]
	set make = substring(x.Make,1,20),
		model = substring(x.Model,1,30),
		year = substring(x.year,1,4),
		FirstName = substring(x.First_name,1,20),
		LastName = substring(x.last_name,1,30),
		Address1 = substring(x.Address1,1,50),
		Address2 = substring(x.Address2,1,50),
		City = substring(x.City,1,30),
		State = substring(x.State,1,2),
		Zip = substring(x.Postal_code,1,10),
		Phone = substring(x.phone_number,1,10),
		Odom = substring(x.Mileage,1,10),
		Exclude = 'N',
		Wireless = x.Wireless
from [CarData].[tmpCar] t, [CarData].[CarData_2015_04_Apr_21] x
where t.Vin = x.Vin
  and x.State in (select State from Legend.State)
  and phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and x.Year in (select Year from CarData.Year)


select top 100 * from [CarData].[tmpCar]


select count(*) from [CarData].[Car]

select len(vin), count(*)
from [CarData].[tmpCar]
group by len(vin)

select top 100 * from [CarData].[tmpCar]

update [CarData].[tmpCar] set Wireless = 'N'

update [CarData].[tmpCar] set Wireless = 'Y'
where phone in (select phone_number from [CarData].[CarData_2015_04_Apr_21] where Wireless = 'Y')

select top 100 * from [CarData].[tmpCar]


insert [CarData].[Car]
select * from [CarData].[tmpCar]


select count(*) from [CarData].[Car]

delete [CarData].[CarData_2015_04_Apr_20]
where state not in (select State from Legend.State)



select count(*) from 



update [CarData].[CarData_2015_04_Apr_21] set Make = e.Make
from [CarData].[CarData_2015_04_Apr_21] x, [CarData].[MakeErr] e
where x.Make = e.MakeErr

select State, count(*)
from [CarData].[CarData_2015_04_Apr_20]
where State not in (select State from Legend.State)
group by State


select top 100 * from [PrivateReserve].[DNC].[LandlineToWireless]


select top 100 * from [PrivateReserve].[DNC].[WirelessBlocks]