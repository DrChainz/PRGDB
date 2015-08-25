select *
from [Car].[List]
where FileName not like '051815%'
  and FileName not like '051915%'
  and FileName not like '052215%'
  and FileName not like '052815%'
  and FileName not like '52815%'
  and FileName not like '060215%'
  and FileName not like '060515%'
  and FileName not like '061615%'
  and FileName not like '061815%'
  and FileName not like '062415%'
  and FileName not like '070115%'
  and FileName not like '070215%'
  and FileName not like '070715%'
  and FileName not like '070815%'
  and FileName not like '071015%'
  and FileName not like '071615%'
  and FileName not like '072115%'
  and FileName not like '072815%'
  and FileName not like '080315%'
  and FileName not like '080515%'
  and FileName not like '071515%'
  and FileName not like '% 0712%'
  and FileName not like '%0630'
  and FileName not like '%0625 fre%'
  and FileName not like '%0624%'
  and FileName not like '%061015'
  and FileName not like '072715%'
  and FileName not like '081915%'
;

update Car.List
set FileDt = '2015-08-19'
where FileName like '081915%'


update Car.CarLoad set AddDt = l.FileDt
from Car.CarLoad c, Car.List l
where c.ListId = l.ListId;


select AddDt, count(*)
from Car.CarLoad
group by AddDt
order by AddDt desc;


select top 1000 * from Car.CarLoad

update Car.CarLoad set Src = 'Powers', BizPhone = 'N'

update Car.CarLoad set Make = e.Make
from Car.CarLoad c, qsm.CarData.MakeErr e
where c.Make = e.MakeErr;

update Car.CarLoad set Model = e.Model
from Car.CarLoad c, qsm.CarData.ModelErr e
where c.Make = e.Make
  and c.Model = e.ModelErr;


update Car.CarLoad set Make = upper(Make);

select Year, count(*) from Car.CarLoad group by Year;

delete Car.CarLoad where Year = '0'


select Make, count(*)
from Car.CarLoad
where Make not in (select Make from qsm.CarData.Make)
group by Make;


select Make, count(*)
from Car.CarLoad
-- where Make not in (select Make from qsm.CarData.Make)
group by Make;

delete Car.CarLoad where Phone not like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'


update Car.CarLoad set Exclude = 'Y'
from Car.CarLoad c, PrivateReserve.dnc.dnc d
where c.Exclude = 'N'
  and c.phone = d.Phone
  and d.DispCd in ('DNC','NI')

update Car.CarLoad set Exclude = 'Y'
from Car.CarLoad c, PrivateReserve.dnc.dnc_gov d
where c.Exclude = 'N'
  and c.phone = d.Phone

update Car.CarLoad set Wireless = 'Y'
from Car.CarLoad c, PrivateReserve.dnc.WirelessBlocks w
where substring(c.Phone,1,7) = w.PhoneBegin;

update Car.CarLoad set Wireless = 'Y'
from Car.CarLoad c, PrivateReserve.dnc.LandlineToWireless w
where c.Phone = w.Phone
  and Wireless = 'N'

update Car.CarLoad set Wireless = 'N'
from Car.CarLoad c, PrivateReserve.dnc.WirelessToLandline w
where c.Phone = w.Phone
  and Wireless = 'Y'

select top 1000 * from Car.CarLoad

update Car.CarLoad set Hybrid = 'Y' where Model like '%hybrid%'

select Exclude, count(*) from Car.CarLoad group by Exclude


update Car.CarLoad set FirstName = qsm.[dbo].[udf_TitleCase](FirstName),
						LastName = qsm.[dbo].[udf_TitleCase](LastName),
						Address1 = qsm.[dbo].[udf_TitleCase](Address1),
						City = qsm.[dbo].[udf_TitleCase](City)



insert qsm.CarData.Car (Vin, Make, Model, Year, FirstName, LastName, Address1, Address2, City, State, Zip, Phone, Odom, Exclude, Wireless, AddDt, BizPhone, AnswerMachine, Hybrid, Src, Sale)
select Vin, Make, Model, Year, FirstName, LastName, Address1, Address2, City, State, Zip, Phone, Odom, Exclude, Wireless, AddDt, BizPhone, AnswerMachine, Hybrid, Src, 'N'
from Car.CarLoad;

