USE [PrivateReserve];
GO




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

-- Get the current date in format we like it in
DECLARE @DtStr char(14);
exec up_DtStr @DtStr OUTPUT;
select @DtStr;
-- select @DtStr;

DECLARE @TableName varchar(50)	= NULL;
DECLARE @SQL varchar(MAX) = NULL;

CREATE TABLE #SNum (SNum int NOT NULL);
CREATE TABLE #ExtractTables (TableName	varchar(50)	NOT NULL UNIQUE);

WHILE (@i <= @FileCnt+1)
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

	SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP COLUMN PRIORITY, SNum';
	EXEC (@SQL);

 	SET @FileName = 'GoForte_' + @DtStr + '_ListFile_' + cast(@i as varchar(10)) + '_of_' + cast(@FileCnt as varchar(10)) + '.csv';
--	select @FileName;

	DECLARE @bcp_cmd varchar(8000);
	select @bcp_cmd = 'bcp [PrivateReserve].' + @TableName + ' out C:\Users\DevWin7_2015_Feb_20\Documents\GoForte\' + @FileName + ' -SDEVWIN7_FEB20 -Usa -Pthor99 -f c:\GoForte\bcp.fmt'
	exec master..xp_cmdshell @bcp_cmd;
	-- select @SQL;

	SET @i += 1;
END

select @TotalRows;
select @FileCnt;
select * from #ExtractTables;




go

exec up_ExtractGoForteSet;
