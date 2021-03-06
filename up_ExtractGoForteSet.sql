USE [PrivateReserve]
GO
/****** Object:  StoredProcedure [dbo].[up_ExtractGoForteSet]    Script Date: 8/20/2015 11:01:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[up_ExtractGoForteSet]
	@Wireless char(1) = 'N',
	@RowCntPerFile int = 200000,
	@TimeZone varchar(4) = NULL
AS

DECLARE @TotalRows int = (SELECT COUNT(*) FROM [CarData].[GoForte_Extract]);
DECLARE @FileCnt int = (SELECT @TotalRows / @RowCntPerFile);
DECLARE @i int = 1;
DECLARE @FileName	varchar(100) = NULL;

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

	SET @SQL = 'SELECT TOP ' + CAST(@RowCntPerFile AS VARCHAR(10)) + ' * INTO ' + @TableName + ' FROM [CarData].[GoForte_Extract] WHERE SNum NOT IN (SELECT SNum FROM #SNum) ORDER BY MakePriority, YearPriority, SNum';
-- 	select @SQL;
	EXEC (@SQL);

	SET @SQL = 'INSERT #SNum SELECT SNum FROM ' + @TableName;
-- 	select @SQL;
	EXEC (@SQL);

	SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP COLUMN WarrantyExpireYearDiff, MakePriority, YearPriority, SNum';
	EXEC (@SQL);

	IF (@TimeZone IS NULL)
	BEGIN
		IF (@Wireless = 'N') 
 			SET @FileName = 'GoForte_' + @DtStr + '_ListFile_' + cast(@i as varchar(10)) + '_of_' + cast(@FileCnt as varchar(10)) + '_Landline.csv';

		ELSE
 			SET @FileName = 'GoForte_' + @DtStr + '_ListFile_' + cast(@i as varchar(10)) + '_of_' + cast(@FileCnt as varchar(10)) + '_Wireless.csv';
	END
	ELSE
	BEGIN
		IF (@Wireless = 'N') 
 			SET @FileName = 'GoForte_' + @TimeZone + '_' + @DtStr + '_ListFile_' + cast(@i as varchar(10)) + '_of_' + cast(@FileCnt as varchar(10)) + '_Landline.csv';

		ELSE
 			SET @FileName = 'GoForte_' + @TimeZone + '_' + @DtStr + '_ListFile_' + cast(@i as varchar(10)) + '_of_' + cast(@FileCnt as varchar(10)) + '_Wireless.csv';
	END
--	select @FileName;

	DECLARE @bcp_cmd varchar(8000);
	select @bcp_cmd = 'bcp [PrivateReserve].' + @TableName + ' out C:\Users\GoForte\output.csv' + ' -SWIN7_2015_JUN16 -Usa -Pthor99 -f c:\Users\GoForte\bcp.fmt'
	insert @output
	exec master..xp_cmdshell @bcp_cmd;

	DECLARE @cmd varchar(1000);
	select @cmd = 'copy /b "C:\Users\GoForte\Header.txt"+"c:\Users\GoForte\output.csv" "C:\Users\GoForte\' + @FileName;
	exec master..xp_cmdshell @cmd;
	
	-- select @SQL;

	select @SQL = 'DROP TABLE ' + @TableName;
	EXEC (@SQL);

	select @cmd = 'DEL C:\Users\GoForte\output.csv';
	exec master..xp_cmdshell @cmd;

	SET @i += 1;

-- 	if(@i> 4) break;
END

select @TotalRows;
select @FileCnt;
select * from #ExtractTables;

-- select * from [CarData].[GoForte_Extract_1]

-- select count(*) from [dbo].[tmp_GoForte_Extract]

/*
select substring(Phone,1,3) AreaCd, count(*)
from [dbo].[tmp_GoForte_Extract]
group by substring(Phone,1,3)
*/
