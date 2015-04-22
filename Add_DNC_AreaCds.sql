declare @a table
(
	AreaCd char(3)	NOT NULL UNIQUE
);

insert @a
select '480' union
select '303' union
select '970' union
select '305' union
select '352' union
select '407' union
select '561' union
select '813' union
select '850' union
select '904' union
select '954' union
select '630' union
select '708' union
select '773' union
select '815' union
select '847' union
select '317' union
select '508' union
select '617' union
select '781' union
select '978' union
select '301' union
select '410' union
select '248' union
select '201' union
select '609' union
select '732' union
select '856' union
select '908' union
select '973' union
select '702' union
select '315' union
select '516' union
select '518' union
select '631' union
select '716' union
select '718' union
select '845' union
select '917' union
select '330' union
select '503' union
select '210' union
select '214' union
select '281' union
select '512' union
select '713' union
select '817' union
select '832' union
select '903' union
select '972' union
select '540' union
select '703' union
select '304' union
select '808' union
select '803' union
select '843' union
select '864';

insert [PrivateReserve].[DNC].[AreaCd] (AreaCd)
select * from @a
where AreaCd not in (select AreaCd from [PrivateReserve].[DNC].[AreaCd]);