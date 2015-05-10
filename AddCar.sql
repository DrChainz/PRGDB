update [CarData].[CarData_2015_05_May_06] set Wireless = 'N'

update [CarData].[CarData_2015_05_May_06] set Wireless = 'Y'
where substring(phone_number,1,7) in (select PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks])

update [CarData].[CarData_2015_05_May_06] set Wireless = 'Y'
where phone_number in (select phone from  [PrivateReserve].[DNC].[LandlineToWireless])

update [CarData].[CarData_2015_05_May_06] set Wireless = 'N'
where phone_number in (select phone from  [PrivateReserve].[DNC].[WirelessToLandline])

update [CarData].[CarData_2015_05_May_06] set Make = e.Make
from [CarData].[CarData_2015_05_May_01] x, [PrivateReserve].[Car].[MakeErr] e
where x.Make = e.MakeErr

/*
select len(vin), count(*)
from [CarData].[CarData_2015_05_May_06]
group by len(vin)
*/

update [CarData].[CarData_2015_05_May_06]
	set Make = model,
		model = vin,
		vin = year,
		year = mileage,
		mileage = custom1
 where len(vin) = 17 and len(year) = 17

update [CarData].[CarData_2015_05_May_06]
	set Make = model,
		model = vin,
		vin = year,
		year = mileage,
		mileage = custom1
where len(vin) <> 17 and len(year) = 17

delete [CarData].[CarData_2015_05_May_06]
where len(vin) <> 17;


select top 100 * from [CarData].[CarData_2015_05_May_06] where len(vin) <> 17 and len(year) = 17



-- select count(*) from CarData.Car


-------------------------------------------------------
--
-------------------------------------------------------
truncate table [CarData].[tmpCar]
;

select Wireless, count(*)
from [CarData].[Car]
group by Wireless


/*
select Year, count(*)
from [CarData].[CarData_2015_05_May_06]
where Year not in (select Year from [PrivateReserve].[Car].[Year])
group by Year
ORDER BY Year
;
*/

delete [CarData].[CarData_2015_05_May_06]
where Year not in (select Year from [PrivateReserve].[Car].[Year])
;

-- alter table [CarData].[CarData_2015_05_May_01] add Exclude char(1) NULL
;
update [CarData].[CarData_2015_05_May_06] set Exclude  = 'N'
;

update [CarData].[CarData_2015_05_May_06] set Exclude = 'Y'
where phone_number in (select Phone from [PrivateReserve].[DNC].[DNC])
;

update [CarData].[CarData_2015_05_May_06] set Make = e.Make
from [CarData].[CarData_2015_05_May_06] x, [CarData].[MakeErr] e
where x.Make = e.MakeErr
;

select top 100 * from [CarData].[CarData_2015_05_May_04]

select Vin, count(*)
from [CarData].[CarData_2015_05_May_04]
group by vin having count(*) > 1

truncate table [CarData].[tmpCar]

select count(distinct vin) from [CarData].[CarData_2015_05_May_04]
where Vin not in (select vin from [QSM].[CarData].[Car])


insert [CarData].[tmpCar] (vin)
select distinct Vin
FROM [CarData].[CarData_2015_05_May_06]
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
from [CarData].[tmpCar] t, [CarData].[CarData_2015_05_May_06] x
where t.Vin = x.Vin
  and x.State in (select State from Legend.State)
  and phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  and x.Year in (select Year from CarData.Year);
GO

INSERT [CarData].[Car]
SELECT * FROM [CarData].[tmpCar];
GO

/*
UPDATE [CarData].[Car] SET Wireless = 'Y'
WHERE Wireless = 'N'
  and substring(Phone,1,7) in (select PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks])
GO

UPDATE [CarData].[Car] SET Wireless = 'Y'
WHERE Wireless = 'N'
  and Phone in (select Phone from [PrivateReserve].[DNC].[LandlineToWireless])
GO

UPDATE [CarData].[Car] SET Wireless = 'N'
WHERE Wireless = 'Y'
  and Phone in (select Phone from [PrivateReserve].[DNC].[WirelessToLandline])
GO
*/

update [CarData].[Car] set Exclude = 'Y'
where Exclude = 'N'
  and Phone in (select Phone from [PrivateReserve].[DNC].[DNC])
;


-- update [CarData].[Car] set Wireless = 'N' where Wireless IS NULL





