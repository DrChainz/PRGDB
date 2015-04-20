use prg;
go

select count(*) from car.car

select State
from legend.state
where State not in (select State from car.StateExclude)

select * from car.StateExclude

insert car.StateExclude
select 'DC'

select * from c


select count(*) from DNC.AreaCd