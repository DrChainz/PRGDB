USE [PrivateReserve];
GO

/*
EXEC sp_configure 'show advanced options', 1;
-- GO
-- To update the currently configured value for advanced options.
RECONFIGURE;
-- GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1;
-- GO
-- To update the currently configured value for this feature.
RECONFIGURE;
-- GO
*/

IF OBJECT_ID(N'up_ExtractGoForteSet') IS NOT NULL
	DROP PROC up_ExtractGoForteSet;
GO

CREATE PROC up_ExtractGoForteSet
	@RowCntPerFile int = 300000
AS

DECLARE @TotalRows int = (SELECT COUNT(*) FROM [CarData].[GoForte_Extract]);
DECLARE @FileCnt int = (SELECT @TotalRows / @RowCntPerFile);
DECLARE @i int = 1;
DECLARE @FileName	varchar(50) = NULL;

SET @FileCnt += 1;

-- Get the current date in format we like it in
DECLARE @DtStr char(14);
exec up_DtStr @DtStr OUTPUT;
select @DtStr;
-- select @DtStr;

DECLARE @TableName varchar(50)	= NULL;
DECLARE @SQL varchar(MAX) = NULL;

CREATE TABLE #SNum (SNum int NOT NULL);
CREATE TABLE #ExtractTables (TableName	varchar(50)	NOT NULL UNIQUE);

declare @output table (output varchar(255));

WHILE (@i <= @FileCnt)
BEGIN
	
	SET @TableName = '[CarData].[GoForte_Extract_' + cast(@i as varchar(10)) + ']';
	INSERT #ExtractTables VALUES (@TableName);

	SET @SQL = 'IF OBJECT_ID(N''' + @TableName + ''') IS NOT NULL DROP TABLE ' + @TableName;
-- 	SELECT @SQL;
	EXEC (@SQL);

	SET @SQL = 'SELECT TOP ' + CAST(@RowCntPerFile AS VARCHAR(10)) + ' * INTO ' + @TableName + ' FROM [CarData].[GoForte_Extract] WHERE SNum NOT IN (SELECT SNum FROM #SNum) ORDER BY Priority, SNum';
-- 	select @SQL;
	EXEC (@SQL);

	SET @SQL = 'INSERT #SNum SELECT SNum FROM ' + @TableName;
-- 	select @SQL;
	EXEC (@SQL);

	SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP COLUMN WarrantyExpireYearDiff, PRIORITY, SNum';
	EXEC (@SQL);

 	SET @FileName = 'GoForte_' + @DtStr + '_ListFile_' + cast(@i as varchar(10)) + '_of_' + cast(@FileCnt as varchar(10)) + '.csv';
--	select @FileName;

	DECLARE @bcp_cmd varchar(8000);
	select @bcp_cmd = 'bcp [PrivateReserve].' + @TableName + ' out C:\Users\GoForte\' + @FileName + ' -SWIN7_2015_JUN16 -Usa -Pthor99 -f c:\Users\GoForte\bcp.fmt'
	insert @output
	exec master..xp_cmdshell @bcp_cmd;
	-- select @SQL;

	SET @i += 1;
END

select @TotalRows;
select @FileCnt;
select * from #ExtractTables;

select * from [CarData].[GoForte_Extract_1]

select count(*) from [dbo].[tmp_GoForte_Extract]

select substring(Phone,1,3) AreaCd, count(*)
from [dbo].[tmp_GoForte_Extract]
group by substring(Phone,1,3)

go

-- select top 100 * from [CarData].[GoForte_Extract]

-- select count(*) from [CarData].[GoForte_Extract]

exec up_ExtractGoForteSet;
