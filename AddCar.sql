update [CarData].[CarData_2015_04_Apr_23] set Wireless = 'N'

update [CarData].[CarData_2015_04_Apr_23] set Wireless = 'Y'
where substring(phone_number,1,7) in (select PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks])

update [CarData].[CarData_2015_04_Apr_23] set Wireless = 'Y'
where phone_number in (select phone from  [PrivateReserve].[DNC].[LandlineToWireless])

update [CarData].[CarData_2015_04_Apr_23] set Wireless = 'N'
where phone_number in (select phone from  [PrivateReserve].[DNC].[WirelessToLandline])

/*
select len(vin), count(*)
from [CarData].[CarData_2015_04_Apr_23]
group by len(vin)

delete [CarData].[CarData_2015_04_Apr_21]
where len(vin) = 0
*/

-------------------------------------------------------
--
-------------------------------------------------------
/*
INSERT QSM.CarData.Car (vin, make, model, year, FirstName, LastName, Address1, Address2, City, State, Zip, Phone, Odom, Exclude, Wireless)
select Vin, substring(Make,1,20), substring(Model,1,30), Year, substring(First_name,1,20) as FirstName,
			substring(last_name,1,30) as LastName, substring(Address1,1,50), substring(Address2,1,50),
			substring(City,1,30), State, substring(postal_code,1,10) as Zip, Phone_number as Phone,
			substring(Mileage,1,10) as Odom, 'N' as Exclude, Wireless
FROM [CarData].[CarData_2015_04_Apr_23]
where Vin not in (select vin from [QSM].[CarData].[Car])
  and len(vin) = 17
  and phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and State in (select State from Legend.State)
  and Year in (select Year from CarData.Year)
*/

-- select top 0 * into [CarData].[tmpCar] from [CarData].[Car]
truncate table [CarData].[tmpCar];

update [CarData].[CarData_2015_04_Apr_27] set Make = e.Make
from [CarData].[CarData_2015_04_Apr_27] x, [CarData].[MakeErr] e
where x.Make = e.MakeErr;
GO

insert [CarData].[tmpCar] (vin)
select distinct Vin
FROM [CarData].[CarData_2015_04_Apr_27]
where Vin not in (select vin from [QSM].[CarData].[Car])
  and len(vin) = 17
  and phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and State in (select State from Legend.State)
  and Year in (select Year from CarData.Year);
GO

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
from [CarData].[tmpCar] t, [CarData].[CarData_2015_04_Apr_27] x
where t.Vin = x.Vin
  and x.State in (select State from Legend.State)
  and phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and x.Year in (select Year from CarData.Year);
GO

INSERT [CarData].[Car]
SELECT * FROM [CarData].[tmpCar];
GO


