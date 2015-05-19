[dbo].[up_MakeGoForte_DialSet]

select top 1000 * from [CarData].[GoForte_Extract]


USE [PrivateReserve]
GO

drop table [CarData].[GoForte_Extract_1];
drop table [CarData].[GoForte_Extract_2];
drop table [CarData].[GoForte_Extract_3];
drop table [CarData].[GoForte_Extract_4];


select top 100 * from [CarData].[GoForte_Extract] ORDER by Priority, SNum
[CarData].[GoForte_Extract_1]


select top 304000 *
into [CarData].[GoForte_Extract_1]
from [CarData].[GoForte_Extract]
ORDER by Priority, SNum

select top 304000 *
into [CarData].[GoForte_Extract_2]
from [CarData].[GoForte_Extract]
where SNum NOT IN (select SNum from [CarData].[GoForte_Extract_1])
ORDER by Priority, SNum

select top 304000 *
into [CarData].[GoForte_Extract_3]
from [CarData].[GoForte_Extract]
where SNum NOT IN (select SNum from [CarData].[GoForte_Extract_1])
 and  SNum NOT IN (select SNum from [CarData].[GoForte_Extract_2])
ORDER by Priority, SNum

select top 304000 *
into [CarData].[GoForte_Extract_4]
from [CarData].[GoForte_Extract]
where SNum NOT IN (select SNum from [CarData].[GoForte_Extract_1])
 and  SNum NOT IN (select SNum from [CarData].[GoForte_Extract_2])
 and  SNum NOT IN (select SNum from [CarData].[GoForte_Extract_3])
ORDER by Priority, SNum



