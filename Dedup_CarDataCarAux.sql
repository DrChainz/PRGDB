use qsm;
go

/*
select *
from sysobjects
where type = 'U'
order by crdate desc
*/

/*
update CarData.Car set Make = e.Make
from CarData.Car c, CarData.MakeErr e
where c.Make = e.MakeErr


update CarData.CarAux_tmp set Make = e.Make
from CarData.CarAux_tmp c, CarData.MakeErr e
where c.Make = e.MakeErr


update CarData.CarAux set Make = e.Make
from CarData.CarAux c, CarData.MakeErr e
where c.Make = e.MakeErr


update CarData.CarAux set Model = e.Model
from CarData.CarAux c, CarData.ModelErr e
where c.Make = e.Make
  and c.Model = e.ModelErr;

update CarData.CarAux_tmp set Model = e.Model
from CarData.CarAux_tmp c, CarData.ModelErr e
where c.Make = e.Make
  and c.Model = e.ModelErr;

update CarData.Car set Model = e.Model
from CarData.Car c, CarData.ModelErr e
where c.Make = e.Make
  and c.Model = e.ModelErr;


update CarData.CarAux_tmp set Make = e.Make
from CarData.CarAux_tmp c, CarData.MakeErr e
where c.Make = e.MakeErr

select * from CarData.CarAux_tmp
where Cnt = 2
order by vin, phone


select * from CarData.CarAux_tmp
where Make = 'Chrys'

select * from CarData.MakeErr
where Make = 'Chrys'

delete CarData.MakeErr
where Make = 'Chrys'


select * from CArData.MakeErr where MakeErr = 'Chrys'


select count(*)
from CarData.Car
where Make = 'DODGE' and Model = 'Av'



select * from CarData.MakeErr
where MakeErr = 'Chrys'

insert CarData.MakeErr
select 'Chrys', 'Chrysler'
*/

-- select top 0 * into CarData.CarAux_Single from CarData.CarAux


DECLARE @Cnt smallint = 0;
DECLARE @Vin char(17), @Phone char(10);
DECLARE @Make varchar(20),
		@Model varchar(30),
		@Year char(4),
		@FirstName varchar(20),
		@LastName varchar(30),
		@Address1 varchar(50),
		@Address2 varchar(50),
		@City varchar(30),
		@State char(2),
		@Zip varchar(10),
		@Odom varchar(10),
		@Exclude char(1),
		@AnswerMachine char(1),
		@Hybrid char(1);

DECLARE @Vin_Single char(17),
		@Phone_Single char(10),
		@Make_Single varchar(20),
		@Model_Single varchar(30),
		@Year_Single char(4),
		@FirstName_Single varchar(20),
		@LastName_Single varchar(30),
		@Address1_Single varchar(50),
		@Address2_Single varchar(50),
		@City_Single varchar(30),
		@State_Single char(2),
		@Zip_Single varchar(10),
		@Odom_Single varchar(10),
		@Exclude_Single char(1),
		@AnswerMachine_Single char(1),
		@Hybrid_Single char(1);

SET @Vin_Single = '';
SET @Phone_Single = '';
SET @Make_Single = '';
SET @Model_Single = '';
SET @Year_Single = '';
SET @FirstName_Single = '';
SET @LastName_Single = '';
SET @Address1_Single = '';
SET	@Address2_Single = '';
SET @City_Single = '';
SET @State_Single = '';
SET @Zip_Single = '';
SET @Odom_Single = '';
SET @Exclude_Single = 'N';
SET @AnswerMachine_Single = 'N';
SET @Hybrid_Single = 'N';

DECLARE dup_cursor CURSOR FOR 
SELECT VIN, Phone
FROM CarData.CarAux_tmp
group by Vin, Phone
having count(*) > 1;

OPEN dup_cursor

FETCH NEXT FROM dup_cursor INTO @Vin, @Phone;

WHILE @@FETCH_STATUS = 0
BEGIN

--	if(@Cnt > 10)
--		BREAK;

	DECLARE car_cursor CURSOR FOR 
    
	SELECT Make, Model, Year, FirstName, LastName, Address1, Address2, City, State, Zip, Odom, Exclude, AnswerMachine, Hybrid
	from CarData.CarAux_tmp
	where Vin = @Vin
	  and Phone = @Phone;

    OPEN car_cursor
    FETCH NEXT FROM car_cursor INTO @Make, @Model, @Year, @FirstName, @LastName, @Address1, @Address2, @City, @State, @Zip, @Odom, @Exclude, @AnswerMachine, @Hybrid;

    WHILE @@FETCH_STATUS = 0
    BEGIN

--	if len(@Vin) < len(@Vin_Single)
		set @Vin_Single = @Vin;

--	if len(@Phone) < len(@Phone_Single)
		set @Phone_Single = @Phone;

	if len(@Make_Single) < len(@Make)
		set @Make_Single = @Make;

	if len(@Model_Single) < len(@Model)
		set @Model_Single = @Model;

	if len(@Year_Single) < len(@Year)
		set @Year_Single = @Year;

	if len(@FirstName_Single) < len(@FirstName)
		set @FirstName_Single = @FirstName;

	if len(@LastName_Single) < len(@LastName)
		set @LastName_Single = @LastName;

	if len(@Address1_Single) < len(@Address1)
		set @Address1_Single = @Address1;

	if len(@Address2_Single) < len(@Address2)
		set @Address2_Single = @Address2;

	if len(@City_Single) < len(@City)
		set @City_Single = @City;

	if len(@State_Single) < len(@State)
		set @State_Single = @State;

	if len(@Zip_Single) < len(@Zip)
		set @Zip_Single = @Zip;

	if len(@Odom_Single) < len(@Odom)
		set @Odom_Single = @Odom;

	if @Exclude_Single = 'N' AND @Exclude = 'Y'
		set @Exclude_Single = @Exclude;
	
	if @AnswerMachine_Single = 'N' AND @AnswerMachine = 'Y'
		set @AnswerMachine_Single = @AnswerMachine;
	
	if @Hybrid_Single = 'N' AND @Hybrid = 'Y'
		set @Hybrid_Single = @Hybrid;
	
-- 	select @Vin, @Phone, @Make, @Model, @Year, @FirstName, @LastName, @Address1, @Address2, @City, @State, @Zip, @Odom, @Exclude, @AnswerMachine, @Hybrid;
	
    FETCH NEXT FROM car_cursor INTO @Make, @Model, @Year, @FirstName, @LastName, @Address1, @Address2, @City, @State, @Zip, @Odom, @Exclude, @AnswerMachine, @Hybrid;

    END

	INSERT CarData.CarAux_Single (Vin, Phone, Make, Model, Year, FirstName, LastName, Address1, Address2, City, State, Zip, Odom, Exclude, AnswerMachine, Hybrid)

	select	@Vin_Single, @Phone_Single, @Make_Single, @Model_Single, @Year_Single, @FirstName_Single, @LastName_Single,
			@Address1_Single, @Address2_Single, @City_Single, @State_Single, @Zip_Single, @Odom_Single, @Exclude_Single, @AnswerMachine_Single, @Hybrid_Single;


	---------------------
	-- Clear the Single
	---------------------
	SET @Vin_Single = '';
	SET @Phone_Single = '';
	SET @Make_Single = '';
	SET @Model_Single = '';
	SET @Year_Single = '';
	SET @FirstName_Single = '';
	SET @LastName_Single = '';
	SET @Address1_Single = '';
	SET	@Address2_Single = '';
	SET @City_Single = '';
	SET @State_Single = '';
	SET @Zip_Single = '';
	SET @Odom_Single = '';
	SET @Exclude_Single = 'N';
	SET @AnswerMachine_Single = 'N';
	SET @Hybrid_Single = 'N';

    CLOSE car_cursor
    DEALLOCATE car_cursor


	FETCH NEXT FROM dup_cursor INTO @Vin, @Phone;
	SET @Cnt += 1;
END 
CLOSE dup_cursor;
DEALLOCATE dup_cursor;

/*
truncate table CarData.CarAux_Single
select * from CarData.CarAux_Single
*/

select * from CarData.CarAux_Single

delete CarData.CarAux_Single
from CarData.CarAux_Single s, CarData.CarAux a
where s.Vin = a.Vin
  and s.Phone = a.Phone


insert CarData.CarAux
select * from CarData.CarAux_Single

select count(*) from CarData.CarAux

select AddDt, count(*) from CarData.CarAux group by AddDt

update CarData.CarAux_Single set AddDt = '2015-08-14'

select * from CarData.CarAux_Single

update CarData.CarAux_Single set Wireless = 'N'


update CarData.CarAux set Wireless = 'Y'
where substring(Phone,1,7) in (select PhoneBegin from PrivateReserve.DNC.WirelessBlocks)

update CarData.CarAux set Wireless = 'Y'
where phone in (select Phone from PrivateReserve.DNC.LandlineToWireless)
  and Wireless = 'N'

update CarData.CarAux set Wireless = 'N'
where phone in (select Phone from PrivateReserve.DNC.WirelessToLandline)
  and Wireless = 'Y'

update CarData.CarAux set Exclude = 'N'
where Exclude = 'Y'

update CarData.CarAux set Exclude = 'Y'
where Phone in (select Phone from PrivateReserve.dnc.dnc where DispCd in ('DNC','NI'))

update CarData.CarAux set Exclude = 'Y'
where Exclude = 'N'
  and Phone in (select Phone from PrivateReserve.dnc.dnc_gov)


update CarData.CarAux set Exclude = 'Y'
FROM PrivateReserve.dnc.dnc_gov g, CarData.CarAux ca
where ca.Exclude = 'N'
  and g.Phone = ca.Phone


update CarData.CarAux set AnswerMachine = 'Y'
FROM CarData.CarAux ca
where ca.AnswerMachine = 'N'
  and ca.Phone in (select Phone from PrivateReserve.dnc.dnc where DispCd in ('AA','ADC'))

select top 1000 * from CarData.CarAux

select State, count(*) from CarData.CarAux group by State


select Exclude, count(*)
from CarData.carAux
group by Exclude





[dbo].[udf_TitleCase]

update CarData.CarAux set FirstName = [dbo].[udf_TitleCase](FirstName),
						  LastName = [dbo].[udf_TitleCase](LastName),
						  Address1 = [dbo].[udf_TitleCase](Address1),
						  City = [dbo].[udf_TitleCase](City);



update CarData.CarAux

select DispCd, count(*)
from PrivateReserve.dnc.dnc
group by DispCd





select top 100 * from PrivateReserve.DNC.WirelessBlocks