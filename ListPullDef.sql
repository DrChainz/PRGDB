-- drop table ListGrp

DROP TABLE [Car].[ListDefCol];
DROP TABLE [Car].[ListDef];
DROP TABLE [Car].[ListGrp];
GO

CREATE TABLE [Car].[ListGrp]
(
	[ListGrpId]		[int]			NOT NULL IDENTITY (0,1),
	[ListGrp]		[varchar](50)	NOT NULL UNIQUE,
	[CreateDt]		[smalldatetime]	NOT NULL,
CONSTRAINT PK_ListGrpId PRIMARY KEY (ListGrpId)
);
GO

CREATE TABLE [Car].[ListDef]
(
	[ListDefId]		[int]			NOT NULL IDENTITY (1,1),
	[ListGrpId]		[int]			NOT NULL,
	[ListDefName]	[varchar](50)	NOT NULL
CONSTRAINT PK_ListDefId PRIMARY KEY (ListDefId),
CONSTRAINT FK_ListGrpId FOREIGN KEY (ListGrpId) REFERENCES [Car].[ListGrp] (ListGrpId)
);
GO
CREATE UNIQUE INDEX UK_ListDefName ON [Car].[ListDef] (ListDefName);
GO

CREATE TABLE [Car].[ListDefCol] 
(
	[ListDefColId]	[int]			NOT NULL IDENTITY (1,1),
	[ListDefId]		[int]			NOT NULL,
	[ColVal]		[varchar](MAX)	NOT NULL,
CONSTRAINT PK_ListDefColId PRIMARY KEY (ListDefColId),
CONSTRAINT FK_ListDefId FOREIGN KEY (ListDefId) REFERENCES [Car].[ListDef] (ListDefId)
);


---------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------
SET IDENTITY_INSERT [Car].[ListGrp] ON;

INSERT [Car].[ListGrp] (ListGrpId, ListGrp, CreateDt)
SELECT 0, 'Always', '2015-06-15';

INSERT [Car].[ListGrp] (ListGrpId, ListGrp, CreateDt)
SELECT 1, 'Best Aug_2015', GETDATE();

SET IDENTITY_INSERT [Car].[ListGrp] OFF;

----------------------------------------
----------------------------------------
SET IDENTITY_INSERT [Car].[ListDef] ON;
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 0,0,'Always';

INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 1,1,'Landline - Powers Latest';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 2,1,'Landline - TX Only';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 3,1,'Landline - NO TX';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 4,1,'Wireless - EST TimeZone';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 5,1,'Wireless - CST TimeZone';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 6,1,'Wireless - MST TimeZone';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 7,1,'Wireless - PST TimeZone';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 8,1,'Wireless - HST TimeZone';
INSERT [Car].[ListDef] (ListDefId, ListGrpId, ListDefName)
SELECT 9,1,'Wireless - AKST TimeZone';
-- select * from PrivateReserve.Legend.TimeZone order by UTC_Offset desc;
SET IDENTITY_INSERT [Car].[ListDef] OFF;


-- select * from Car.ListDef;

SET IDENTITY_INSERT [Car].[ListDefCol] ON;

INSERT [Car].[ListDefCol] (ListDefColId, ListDefId, ColVal)
SELECT 1, 0, 'Exclude = ''N''' union
SELECT 2, 0, 'Sale = ''N''' union
select 3, 0, 'Make IN (SELECT Make from [QSM].[CarData].[MakeInclude])' union
select 4, 0, 'State NOT IN (select State from [DNC].[State])' union
select 5, 0, '(FirstName IS NOT NULL AND FirstName <> '''')' union
select 6, 0, '(LastName IS NOT NULL AND c.LastName <> '''')' union
select 7, 0, 'AnswerMachine = ''N''' union
select 8, 0, 'substring(Phone,1,3) IN (SELECT AreaCd FROM [PrivateReserve].[DNC].[AreaCd])'

/*

	  and c.AnswerMachine = 'N'
*/

SET IDENTITY_INSERT [Car].[ListDefCol] OFF;

select * from [Car].[ListDefCol] 

/*
CREATE TABLE [Car].[ListDefCol] 
(
	[ListDefColId]	[int]			NOT NULL IDENTITY (1,1),
	[ListDefId]		[int]			NOT NULL,
CONSTRAINT PK_ListDefColId PRIMARY KEY (ListDefColId),
CONSTRAINT FK_ListDefId FOREIGN KEY (ListDefId) REFERENCES [Car].[ListDef] (ListDefId)
);
*/