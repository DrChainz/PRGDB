use CarLoadTest;
go

select * from Car.List
order by ListId desc;


select listid from Car.List where Src = 'Chip'

create table Car.test_Chip
(
	Vin			char(17)	NOT NULL,
	Phone		char(10)	NOT NULL
);

create unique index PK_TestChip on Car.test_Chip (Vin, Phone)

alter table Car.test_Chip add HaveIt char(1)
update Car.test_Chip set HaveIt = 'N'


update Car.test_Chip set HaveIt = 'Y'
from Car.test_Chip t, qsm.CarData.CarAux c
where t.Vin = c.Vin
  and t.Phone = c.Phone;

select HaveIt, count(*)
from Car.test_Chip
group by HaveIt






insert Car.test_Chip (Vin,Phone)
select distinct Vin, Phone
from Car.Car
where listid in (select listid from Car.List where Src = 'Chip')
and len(vin) = 17
 and len(Phone) = 10
 and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'


select Vin, count(*) as Cnt
into Car.test_ChipVinCnt
from Car.test_Chip
group by Vin
having count(*) > 1







select * from Car.List order by listid desc;