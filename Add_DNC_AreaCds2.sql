-- select * from Le


/*
select * from [Legend].[StateAreaCd]

declare @rpt table
(
	State	char(2)		NULL,
	StateName	varchar(30)		NULL,
);
*/


-- select * from [PrivateReserve].[DNC].[AreaCd] order by AreaCd

-- drop table PrivateReserve.[CarData].[DNC_AreaCd]


select * from [PrivateReserve].[DNC].[AreaCd]

/*
DROP PROC up_Add_DNC_AreaCd
CREATE PROC up_Add_DNC_AreaCd
	@AreaCd	char(3)	= NULL
AS

IF NOT EXISTS (select * from [PrivateReserve].[DNC].[AreaCd] WHERE AreaCd = @AreaCd)
	INSERT [PrivateReserve].[DNC].[AreaCd]
	select @AreaCd;
GO
*/

/*
exec up_Add_DNC_AreaCd '808';
exec up_Add_DNC_AreaCd '803';
exec up_Add_DNC_AreaCd '843';
exec up_Add_DNC_AreaCd '864';
exec up_Add_DNC_AreaCd '480';
exec up_Add_DNC_AreaCd '303';
exec up_Add_DNC_AreaCd '970';
exec up_Add_DNC_AreaCd '305';
exec up_Add_DNC_AreaCd '352';
exec up_Add_DNC_AreaCd '407';
exec up_Add_DNC_AreaCd '561';
exec up_Add_DNC_AreaCd '813';
exec up_Add_DNC_AreaCd '850';
exec up_Add_DNC_AreaCd '904';
exec up_Add_DNC_AreaCd '954';
exec up_Add_DNC_AreaCd '630';
exec up_Add_DNC_AreaCd '708';
exec up_Add_DNC_AreaCd '773';
exec up_Add_DNC_AreaCd '815';
exec up_Add_DNC_AreaCd '847';
exec up_Add_DNC_AreaCd '317';
exec up_Add_DNC_AreaCd '508';
exec up_Add_DNC_AreaCd '617';
exec up_Add_DNC_AreaCd '781';
exec up_Add_DNC_AreaCd '978';
exec up_Add_DNC_AreaCd '301';
exec up_Add_DNC_AreaCd '410';
exec up_Add_DNC_AreaCd '248';
exec up_Add_DNC_AreaCd '201';
exec up_Add_DNC_AreaCd '609';
exec up_Add_DNC_AreaCd '732';
exec up_Add_DNC_AreaCd '856';
exec up_Add_DNC_AreaCd '908';
exec up_Add_DNC_AreaCd '973';
exec up_Add_DNC_AreaCd '702';
exec up_Add_DNC_AreaCd '315';
exec up_Add_DNC_AreaCd '516';
exec up_Add_DNC_AreaCd '518';
exec up_Add_DNC_AreaCd '631';
exec up_Add_DNC_AreaCd '716';
exec up_Add_DNC_AreaCd '718';
exec up_Add_DNC_AreaCd '845';
exec up_Add_DNC_AreaCd '917';
exec up_Add_DNC_AreaCd '330';
exec up_Add_DNC_AreaCd '503';
exec up_Add_DNC_AreaCd '210';
exec up_Add_DNC_AreaCd '214';
exec up_Add_DNC_AreaCd '254';
exec up_Add_DNC_AreaCd '281';
exec up_Add_DNC_AreaCd '361';
exec up_Add_DNC_AreaCd '409';
exec up_Add_DNC_AreaCd '512';
exec up_Add_DNC_AreaCd '713';
exec up_Add_DNC_AreaCd '806';
exec up_Add_DNC_AreaCd '817';
exec up_Add_DNC_AreaCd '830';
exec up_Add_DNC_AreaCd '832';
exec up_Add_DNC_AreaCd '903';
exec up_Add_DNC_AreaCd '972';
exec up_Add_DNC_AreaCd '540';
exec up_Add_DNC_AreaCd '703';
exec up_Add_DNC_AreaCd '304';
*/

select count(*) from [PrivateReserve].[DNC].[AreaCd]
