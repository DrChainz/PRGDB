
[dbo].[up_CarPhoneCnt]


select State, count(*)
from CarData.Car
where substring(Phone,1,3) = '732'
group by State
order by count(*) desc


select * from [PrivateReserve].[Legend].[StateAreaCd]

insert [PrivateReserve].[Legend].[StateAreaCd] values ('NJ', '732')