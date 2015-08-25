use qsm;
go

-- select top 100 *

-- select FirstName, count(*)
select top 1000 *
from CarData.Car
where Exclude = 'N'
  and LastName like '% inc'


  FirstName = 'Itq-Dcc'

select top 1000 *
from CarData.Car
where Exclude = 'N'
  and LastName like '% inc'

update CarData.Car set Exclude = 'Y'
where Exclude = 'N'
  and FirstName = 'Itq-Dcc'


update CarData.Car set Exclude = 'Y'
where Exclude = 'N'
  and LastName like 'valued%'

select Make, Model, count(*)
from CarData.Car
where Vin like '1FT8W3%'
group by Make, Model


 and (LastName like 'northeast'
or LastName like 'northwest'
or LastName like 'southwest'
or LastName like 'southeast')


update CarData.Car
where Exclude = 'N'
 and (LastName like 'northeast'
or LastName like 'northwest'
or LastName like 'southwest'
or LastName like 'southeast')



 and (FirstName like 'northeast'
or FirstName like 'northwest'
or FirstName like 'southwest'
or FirstName like 'southeast')


update CarData.Car set Exclude = 'Y'
where Exclude = 'N'
 and (FirstName like 'northeast'
or FirstName like 'northwest'
or FirstName like 'southwest'
or FirstName like 'southeast')



--  and LastName in (select make from CarData.Make)
--  and FirstName = City
-- where FirstName like 'south%'

/*
update CarData.CarAux set Exclude = 'Y'
where Exclude = 'N'
  and LastName in (select make from CarData.Make)
  and FirstName = City
*/

-- group by FirstName


/*
update CarData.Car set Exclude = 'Y'
where FirstName like 'valued%'
  and Exclude = 'N'
*/
