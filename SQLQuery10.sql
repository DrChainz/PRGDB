
/*
select top 100 * from [CarData].[GoForte_Extract]
where phone = '2819327473'
*/

/*
select * from PRG.Legend.State
where State not in ('VI','DC','PR')
--select * from PRG.Car.StateExclude
*/

--insert PRG.Car.StateExclude

select count(*) from PrivateReserve.dnc.areacd;

insert PrivateReserve.dnc.areacd (areaCd)
select '617' union 
select '503' union 
select '248' union 
select '540' union 
select '917' union 
select '864' union 
select '315' union 
select '716' union 
select '480' union 
select '808'

where not in (select AreaCd from PrivateReserve.dnc.areacd;)

