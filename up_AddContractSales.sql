-- select count(*) from [CarData].[CarData_2015_05_May_19]
USE QSM;
GO

/*
select top 100 * 
from [CarData].[CarData_2015_05_May_19]
where Status = 'SALE'
*/

/*
create table [CarData].[ContractSales]
(
	Vin			char(17)			NOT NULL UNIQUE,
	SaleDt		smalldatetime		NULL,
	Make		varchar(30)			NULL,
	Model		varchar(30)			NULL,
	Year		char(4)			 	NULL
);
*/

IF OBJECT_ID(N'up_AddContractSales') IS NOT NULL
	DROP PROC up_AddContractSales;
GO

CREATE PROC up_AddContractSales
	@tableName		varchar(50)
AS

CREATE TABLE #sale
(
	Vin			char(17),
	SaleDt		smalldatetime,
	Make		varchar(30)			NULL,
	Model		varchar(30)			NULL,
	Year		char(4)			 	NULL
);

DECLARE @SQL varchar(8000) = NULL;

SELECT @SQL = 'insert #sale (Vin, SaleDt) select Vin, max(cast(last_local_call_time as smalldatetime)) FROM ' + @tableName + ' where status = ''SALE'' group by Vin';
EXEC (@SQL);

SELECT @SQL = 'update #sale SET Make = t.Make, Model = t.Model, Year = t.Year FROM ' + @tableName + ' t, #sale s where t.Vin = s.Vin';
EXEC (@SQL);

update #sale set SaleDt = cast(floor(cast(SaleDt as float)) as smalldatetime);

-- select * from #sale;

delete #sale
where Vin in (select Vin from [CarData].[ContractSales]);

insert [CarData].[ContractSales] ( Vin, SaleDt, Make, Model, Year)
select Vin, SaleDt, Make, Model, Year
from #sale;

GO

exec up_AddContractSales '[CarData].[CarData_2015_05_May_21]';


select * from [CarData].[ContractSales]
