USE QSM;
GO

/*
INSERT [Car].[Car] (VIN, Make, Model, Year)
select VIN, Make, Model, Year
from [QSM].[CarData].[Car]
where Model in (select Model FROM [QSM].[CarData].[Car] group by Model having count(*) > 5)
*/

select top 100 * from [CarData].[Car];

INSERT [CarData].[Car] (Vin, Make, Model, Year)

select top 0 * into [CarData].[x5Car] from [CarData].[Car]


select Vin, Make, Model, Year

truncate table [CarData].[x2Car];

alter table [CarData].[Car]
	add FirstName	varchar(20)		NULL,
		LastName	varchar(30)		NULL,
		Address1	varchar(50)		NULL,
		Address2	varchar(50)		NULL,
		City		varchar(30)		NULL,
		State		char(2)			NULL,
		Zip			varchar(10)		NULL,
		Phone		char(10)		NULL,
		Odom		varchar(10)		NULL

update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c, [CarData].[CarData_2015_02_Feb_26_Step0] t
where c.vin = t.vin

update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c,  [CarData].[CarData_2015_02_Feb_26_Step0] t
-- [CarData].[CarData_2015_03_Mar_17_Step0] t
where c.vin = t.vin
  and len(c.Phone) <> 10
  and len(rtrim(substring(t.phone_number,1,10))) = 10;

update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c,  [CarData].[CarData_2015_03_Mar_17_Step0] t
-- [CarData].[CarData_2015_03_Mar_17_Step0] t
where c.vin = t.vin
  and len(c.Phone) <> 10
  and len(rtrim(substring(t.phone_number,1,10))) = 10;


update [CarData].[Car]
	set Model = t.Model
FROM [CarData].[Car] c,  [CarData].[CarData_2015_02_Feb_26_Step0] t
where c.vin = t.vin
  and len(c.Model) = 0
  and len(t.Model) > 0



update [CarData].[Car]
	set Model = t.Model
FROM [CarData].[Car] c,  [CarData].[CarData_2015_03_Mar_30_Step0] t
where c.vin = t.vin
  and len(c.Model) = 0
  and len(t.Model) > 0


update [CarData].[Car]
	set Model = t.Model
FROM [CarData].[Car] c,  [CarData].[CarData_2015_04_Apr_01_Step1] t
where c.vin = t.vin
  and len(c.Model) = 0
  and len(t.Model) > 0





update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c,  [CarData].[CarData_2015_03_Mar_26_Step0] t
-- [CarData].[CarData_2015_03_Mar_17_Step0] t
where c.vin = t.vin
  and len(c.Phone) <> 10
  and len(rtrim(substring(t.phone_number,1,10))) = 10;

update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c,  [CarData].[CarData_2015_03_Mar_30_Step0] t
-- [CarData].[CarData_2015_03_Mar_17_Step0] t
where c.vin = t.vin
  and len(c.Phone) <> 10
  and len(rtrim(substring(t.phone_number,1,10))) = 10;

update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c,  [CarData].[CarData_2015_04_Apr_01_Step1] t
-- [CarData].[CarData_2015_03_Mar_17_Step0] t
where c.vin = t.vin
  and len(c.Phone) <> 10
  and len(rtrim(substring(t.phone_number,1,10))) = 10;



update [CarData].[Car]
	set FirstName = substring(t.First_Name,1,20),
		LastName = substring(t.Last_Name,1,30),
		Address1 = substring(t.Address1,1,50),
		Address2 = substring(t.Address2,1,50),
		City = substring(t.City,1,30),
		State = substring(t.State,1,2),
		Zip = substring(t.postal_code,1,10),
		Phone = substring(t.Phone_number,1,10),
		Odom = substring(t.Mileage,1,10)
FROM [CarData].[Car] c, [CarData].[CarData_2015_04_Apr_01_Step1] t
where c.vin = t.vin


select len(Phone), count(*)
from CarData.Car
group by len(Phone)

select *
from CarData.Car
where FirstName = ''


select FirstName, count(*)
from CarData.Car
group by FirstName
having count(*) > 10
order by count(*) desc


select top 1000 * from CarData.Car
where FirstName like 'subs%'
  and FirstName not in ('SUBSCRIBER')


delete CarData.Car
where FirstName = ''

delete CarData.Car where LastName 

-- alter table CarData.Car add Exclude char(1) NULL

select count(*) from CarData.Car where Exclude = 'N' and FirstName = ' CO'

select * from CarData.Car where FirstName = 'SIRIUS' and Exclude = 'N'


select count(*)
from Legend.FirstName where Cnt > 100

select top 10000 *
from CarData.Car
where FirstName not in (select FirstName from Legend.FirstName where Cnt > 100)
  and Exclude <> 'Y'


select * from CarData.Car where lastName = 'COMPANY'

select count(*) from CarData.Car where Exclude = 'Y'

select 




select top 1000 *
from CarData.Car
where Exclude = 'N'

 and lastname like '%auction%'


   and lastname like '%public%'
--   and lastname like '%DRIVING SCHOOL%'


  and lastname like '%lease%'

  and lastname like '% autom%'

update CarData.Car set Exclude = 'Y'
where Exclude = 'N'
  and lastName = 'COMPANY'

  and lastName = '%TELEPHONE%'

  and lastname like '%EMPLOYEE%'


  and lastname like '%auction%'

  and lastname like '%UTILITIES%'


  and firstname like '%UTILITIES%'


   and lastname like '%public %'

   and lastname like '%TECHNOLOGY%'

   and lastname like '%DRIVING SCHOOL%'

  and lastname like '%SCHOOL DIST%'

  and lastname like '%auto school%'

  and lastname = 'DRIVING SCHOOL'


and lastname like '%service%'


and lastname like '%supply%'

  and lastname = 'LEASE PLAN U S'

  and lastname = 'NOTCALLAPLEASE'

and firstname like 'lease'

  and lastname like '% autom%'


  and lastname like '% LTD%'


  and lastname like '% contract%'

  and lastname like '% contracting%'


  and lastname like '% ranch%'

and lastname like '% Plumb%'

  and lastname like '% energy%'

  and lastname like '% farm%'

  and lastname like 'XM'

  and lastname like '% invest%'

  and lastname like '% CONSTRUCT%'

  and lastname like '% SPECIALTY%'


  and lastname like '% CORP%'

  and lastname like '% LLC%'
  
  
  and FirstName = 'SIRIUS'

  and FirstName = 'ITQ-DCC'


  and lastName like '% INC%'


update CarData.Car set Exclude = 'Y'
where Exclude = 'N'
  and lastName like '% INC%'

select Exclude, count(*)
from CarData.Car
group by Exclude

update CarData.Car set Exclude = 'N' where Exclude is null;

update CarData.Car set Exclude = 'N'

update CarData.Car set Exclude = 'Y' where LastName = 'INC'


select FirstName, count(*)
from CarData.Car
where lastName = 'INC'
group by FirstName
order by count(*) desc

select top 1000 * from CarData.Car
where lastName = 'INC'


select top 1000 * from CarData.Car
where lastName like '%INC%'


where FirstName in ('SUBSCRIBER')


where FirstName in ('VALUED SUBSCRIBER', 'VALUED','VALUEDSUBSCRIBER','VALUED CUSTOMER','VALUED SUB','VALUED SU')


delete CarData.Car where len(Phone) <> 10

select top 100 * from CarData.CAr where len(Phone) = 10

select 


select count(*) from CarData.Car
where len(Phone) = 10 



insert [CarData].[x5Car] (Vin)
select distinct Vin
-- from [CarData].[CarData_2015_03_Mar_17_Step0] s
-- FROM [CarData].[CarData_2015_03_Mar_30_Step1] s
FROM [CarData].[CarData_2015_04_Apr_01_Step1] s
where year in (select Year from [PRG].[Car].[Year])
  and Make in (select Make from [PRG].[Car].[Make])
  and len(Vin) = 17
  and Vin NOT IN (SELECT VIN from [CarData].[Car]);
GO


select count(*) from [CarData].[CarData_2015_03_Mar_17_Step0] s


create unique index PK_x4Car ON [CarData].[x4Car] (VIN);
create index XK_wildtigerz ON [CarData].[CarData_2015_03_Mar_17_Step0] (VIN);

update [CarData].[x4Car] set Make = s.Make, Model = s.Model, Year = s.Year
FROM [CarData].[x4Car] x, [CarData].[CarData_2015_03_Mar_30_Step1] s
where x.vin = s.vin

select top 1000 * from [CarData].[xxCar]

insert [CarData].[Car]
select * from [CarData].[x4Car]




select count(*) from [CarData].[CarData_2015_03_Mar_26_Step1]


select Year, count(*)
from [CarData].[Car]
group by Year
order by Year


select count(*) from [CarData].[Car];
GO

select Vin, Make, Model, Year

select top 100 * from [CarData].[CarData_2015_02_Feb_26_Step1_save]

select top 100 vin, make, model, Year
from [CarData].[CarData_2015_02_Feb_26_Step1_save]

select count(*) from [CarData].[CarData_2015_02_Feb_26_Step1_Save]

update [CarData].[CarData_2015_02_Feb_26_Step1_Save] set Make = e.Make
from [CarData].[CarData_2015_02_Feb_26_Step1_Save] s, [PRG].[Car].[MakeErr] e
where s.Make = e.MakeErr






select * from PRG.Car.MakeErr


-- 6232529



select top 100 * from [CarData].[CarData_2015_02_Feb_26_Step0]
select count(*) from [CarData].[CarData_2015_02_Feb_26_Step0] where len(vin) = 17

select * from []
