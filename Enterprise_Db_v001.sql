USE MASTER;
GO

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'ENTERPRISE'))
	DROP DATABASE [ENTERPRISE];
GO

CREATE DATABASE [ENTERPRISE];		-- likely oughta define size here
GO

USE [ENTERPRISE];
GO

------------------------------
--
------------------------------
CREATE SCHEMA [Security];
GO
CREATE SCHEMA [Legend];
GO

---------------------------------------
-- Rules
---------------------------------------
CREATE RULE [dbo].[State] 
AS
@Val like '[A-Z][A-Z]'
GO

CREATE TYPE [dbo].[State] FROM [char](2) NOT NULL
GO

sp_bindrule '[dbo].[State]', '[dbo].[State]';
GO

--------------------------------------
--
--------------------------------------
CREATE RULE [Legend].[DbAction]
AS
@Val IN ('UPDATE','DELETE','INSERT')
GO

CREATE RULE [Legend].[AreaCd] 
AS
@Val like '[0-9][0-9][0-9]'
GO

CREATE RULE [Legend].[PhoneFormat] 
AS
@Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
GO

CREATE RULE [Legend].[Year] 
AS
@Val like '[1-2][0-9][0-9][0-9]'
GO

CREATE RULE [Legend].[YearMonth] 
AS
@Val LIKE '[1-2][0,9][0-9][0-9][0-1][0-9]'
GO

CREATE RULE [Legend].[Qtr] 
AS
@Val BETWEEN 1 AND 4;
GO

CREATE RULE [Legend].[YesNo] 
AS
@Val IN ('N','Y')
GO

CREATE RULE [Legend].[YesNoUnknown] 
AS
@Val IN ('U','N','Y')
GO

CREATE RULE [Legend].[Gender]
AS
@Val IN ('U','M','F')
GO

CREATE RULE [Legend].[WeekDay]
AS
@Val IN ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')
GO

CREATE TYPE [Legend].[DbAction] FROM [char](6) NOT NULL
GO

CREATE TYPE [Legend].[AreaCd] FROM [char](3) NOT NULL
GO

-- CREATE TYPE [dbo].[State] FROM [char](2) NOT NULL
-- GO

CREATE TYPE [Legend].[WeekDay] FROM [varchar](9) NOT NULL
GO

CREATE TYPE [Legend].[Phone] FROM [char](10) NOT NULL
GO

CREATE TYPE [Legend].[Qtr] FROM [tinyint] NOT NULL
GO

CREATE TYPE [Legend].[Year] FROM [char](4) NOT NULL
GO

CREATE TYPE [Legend].[YearMonth] FROM [char](6) NOT NULL
GO

CREATE TYPE [Legend].[YesNo] FROM [char](1) NOT NULL
GO

CREATE TYPE [Legend].[YesNoUnknown] FROM [char](1) NOT NULL
GO

CREATE TYPE [Legend].[Gender] FROM [char](1) NOT NULL
GO

---------------------------------------
-- Bind the rules the types
---------------------------------------
sp_bindrule '[Legend].[DbAction]', '[Legend].[DbAction]';
GO

sp_bindrule '[Legend].[AreaCd]', '[Legend].[AreaCd]';
GO

sp_bindrule '[dbo].[State]', '[dbo].[State]';
GO

sp_bindrule '[Legend].[WeekDay]', '[Legend].[WeekDay]';
GO

sp_bindrule '[Legend].[PhoneFormat]', '[Legend].[Phone]';
GO

sp_bindrule '[Legend].[Qtr]', '[Legend].[Qtr]';
GO

sp_bindrule '[Legend].[Year]', '[Legend].[Year]';
GO

sp_bindrule '[Legend].[YearMonth]', '[Legend].[YearMonth]';
GO

sp_bindrule '[Legend].[YesNo]', '[Legend].[YesNo]';
GO

sp_bindrule '[Legend].[YesNoUnknown]', '[Legend].[YesNoUnknown]';
GO

sp_bindrule '[Legend].[Gender]', '[Legend].[Gender]';
GO

---------------------------------------
-- Create Defaults
---------------------------------------
CREATE DEFAULT [Legend].[No] AS 'N';
GO

CREATE DEFAULT [Legend].[Unknown] AS 'U';
GO

---------------------------------------
-- Bind Defaults
---------------------------------------
sp_bindefault '[Legend].[No]', '[Legend].[YesNo]'; 
GO
sp_bindefault '[Legend].[Unknown]', '[Legend].[YesNoUnknown]'; 
GO


--**************************************************
-- Functions
--**************************************************
IF OBJECT_ID(N'udf_TitleCase') IS NOT NULL
	DROP FUNCTION dbo.udf_TitleCase;
GO

---------------------------------------
-- [dbo].[udf_TitleCase]
-----------------------------------------
CREATE  FUNCTION [dbo].[udf_TitleCase] (@InputString varchar(4000) )
RETURNS VARCHAR(4000)
AS
BEGIN
DECLARE @Index          INT
DECLARE @Char           CHAR(1)
DECLARE @OutputString   VARCHAR(255)

SET @OutputString = LOWER(@InputString)
SET @Index = 2
SET @OutputString =

STUFF(@OutputString, 1, 1,UPPER(SUBSTRING(@InputString,1,1)))

WHILE @Index <= LEN(@InputString)
BEGIN
	SET @Char = SUBSTRING(@InputString, @Index, 1)

	IF @Char IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&','''', '(')
		IF @Index + 1 <= LEN(@InputString)
		BEGIN
			IF @Char != '''' OR	UPPER(SUBSTRING(@InputString, @Index + 1, 1)) != 'S'
			SET @OutputString = STUFF(@OutputString, @Index + 1, 1,UPPER(SUBSTRING(@InputString, @Index + 1, 1)))
		END

	SET @Index = @Index + 1
END
RETURN ISNULL(@OutputString,'')
END
GO

---------------------------------------
-- [dbo].[udf_date]
-----------------------------------------
CREATE FUNCTION [dbo].[udf_date] ( @Dt smalldatetime )
	RETURNS smalldatetime
AS
BEGIN
	RETURN (cast(floor(cast(@Dt as float)) as smalldatetime));
END
GO

------------------------------
--
------------------------------
CREATE RULE [Security].[DbAction]
AS
@Val IN ('UPDATE','DELETE','INSERT')
GO

CREATE TABLE [Security].[Grp]
(
	[GrpId]			[int]				NOT NULL	IDENTITY(0,1),
	[GrpName]		[varchar](20)		NOT NULL	UNIQUE,
PRIMARY KEY ([GrpId])
);
GO

SET IDENTITY_INSERT [Security].[Grp] ON;
INSERT [Security].[Grp] ([GrpId], [GrpName])
SELECT 0, 'Root' union
SELECT 1, 'Admin' union
SELECT 2, 'Manager';
SET IDENTITY_INSERT [Security].[Grp] OFF;
GO

CREATE TABLE [Security].[Login]
(
	[Login]			[varchar](10)		NOT NULL	UNIQUE,
	[Passwd]		[varchar](20)		NOT NULL,
PRIMARY KEY ([Login])
);
GO

INSERT [Security].[Login] ([Login], [Passwd])
SELECT 'root', 'dsk34jwz!' union
SELECT 'Matt', 'MakeMoney44$' union
SELECT 'Pj', 'Dks34jwz!' union
SELECT 'GuzJr', 'PornKing44$';
GO

CREATE TABLE [Security].[LoginGrp]
(
	[Login]			[varchar](10)		NOT NULL,
	[GrpId]			[int]				NOT NULL,
FOREIGN KEY ([Login]) REFERENCES [Security].[Login] (Login),
FOREIGN KEY ([Login]) REFERENCES [Security].[Login] (Login),
);

INSERT [Security].[LoginGrp] ([Login], [GrpId])
SELECT 'root', 0 union
SELECT 'Matt', 0 union
SELECT 'Pj', 1 union
SELECT 'GuzJr', 2;
GO


---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[TimeZone]
(
	[TimeZone]		[char](4)		NOT NULL,
	[Name]			[varchar](30)	NOT NULL,
	[UTC_Offset]	[smallint]		NOT NULL,
PRIMARY KEY (TimeZone) 
) ON [PRIMARY]
GO

INSERT [Legend].[TimeZone] ( TimeZone, Name, UTC_Offset)
SELECT 'AKST','Alaska Standard Time', -9 UNION
SELECT 'CDT','Central Daylight Time', -5 UNION
SELECT 'CST','Central Standard Time', -6 UNION
SELECT 'EDT','Eastern Daylight Time', -4 UNION
SELECT 'EST','Eastern Standard Time', -5 UNION
SELECT 'HST','Hawaii Standard Time', -11 UNION
SELECT 'MDT','Mountain Daylight Time', -6 UNION
SELECT 'MST','Mountain Standard Time', -7 UNION
SELECT 'PST','Pacific Standard Time', -8
GO

---------------------------------------
-- select max(len(CountryName)) from [Legend].[Country] -- 44
-- select * from [Legend].[Country]
-----------------------------------------
CREATE TABLE [Legend].[Country]
(
	[CountryCd]			[char](3)		NOT NULL UNIQUE,
	[CountryName]		[varchar](50)	NOT NULL,
PRIMARY KEY (CountryCd)
);
GO

INSERT [Legend].[Country] ( [CountryCd], [CountryName] )
select 'ABW','Aruba' union
select 'AFG','Afghanistan' union
select 'AGO','Angola' union
select 'AIA','Anguilla' union
select 'ALA','Åland Islands' union
select 'ALB','Albania' union
select 'AND','Andorra' union
select 'ARE','United Arab Emirates' union
select 'ARG','Argentina' union
select 'ARM','Armenia' union
select 'ASM','American Samoa' union
select 'ATA','Antarctica' union
select 'ATF','French Southern Territories' union
select 'ATG','Antigua and Barbuda' union
select 'AUS','Australia' union
select 'AUT','Austria' union
select 'AZE','Azerbaijan' union
select 'BDI','Burundi' union
select 'BEL','Belgium' union
select 'BEN','Benin' union
select 'BES','Bonaire, Sint Eustatius and Saba' union
select 'BFA','Burkina Faso' union
select 'BGD','Bangladesh' union
select 'BGR','Bulgaria' union
select 'BHR','Bahrain' union
select 'BHS','Bahamas' union
select 'BIH','Bosnia and Herzegovina' union
select 'BLM','Saint Barthélemy' union
select 'BLR','Belarus' union
select 'BLZ','Belize' union
select 'BMU','Bermuda' union
select 'BOL','Bolivia, Plurinational State of' union
select 'BRA','Brazil' union
select 'BRB','Barbados' union
select 'BRN','Brunei Darussalam' union
select 'BTN','Bhutan' union
select 'BVT','Bouvet Island' union
select 'BWA','Botswana' union
select 'CAF','Central African Republic' union
select 'CAN','Canada' union
select 'CCK','Cocos (Keeling) Islands' union
select 'CHE','Switzerland' union
select 'CHL','Chile' union
select 'CHN','China' union
select 'CIV','Côte d''Ivoire' union
select 'CMR','Cameroon' union
select 'COD','Congo, the Democratic Republic of the' union
select 'COG','Congo' union
select 'COK','Cook Islands' union
select 'COL','Colombia' union
select 'COM','Comoros' union
select 'CPV','Cabo Verde' union
select 'CRI','Costa Rica' union
select 'CUB','Cuba' union
select 'CUW','Curaçao' union
select 'CXR','Christmas Island' union
select 'CYM','Cayman Islands' union
select 'CYP','Cyprus' union
select 'CZE','Czech Republic' union
select 'DEU','Germany' union
select 'DJI','Djibouti' union
select 'DMA','Dominica' union
select 'DNK','Denmark' union
select 'DOM','Dominican Republic' union
select 'DZA','Algeria' union
select 'ECU','Ecuador' union
select 'EGY','Egypt' union
select 'ERI','Eritrea' union
select 'ESH','Western Sahara' union
select 'ESP','Spain' union
select 'EST','Estonia' union
select 'ETH','Ethiopia' union
select 'FIN','Finland' union
select 'FJI','Fiji' union
select 'FLK','Falkland Islands (Malvinas)' union
select 'FRA','France' union
select 'FRO','Faroe Islands' union
select 'FSM','Micronesia, Federated States of' union
select 'GAB','Gabon' union
select 'GBR','United Kingdom' union
select 'GEO','Georgia' union
select 'GGY','Guernsey' union
select 'GHA','Ghana' union
select 'GIB','Gibraltar' union
select 'GIN','Guinea' union
select 'GLP','Guadeloupe' union
select 'GMB','Gambia' union
select 'GNB','Guinea-Bissau' union
select 'GNQ','Equatorial Guinea' union
select 'GRC','Greece' union
select 'GRD','Grenada' union
select 'GRL','Greenland' union
select 'GTM','Guatemala' union
select 'GUF','French Guiana' union
select 'GUM','Guam' union
select 'GUY','Guyana' union
select 'HKG','Hong Kong' union
select 'HMD','Heard Island and McDonald Islands' union
select 'HND','Honduras' union
select 'HRV','Croatia' union
select 'HTI','Haiti' union
select 'HUN','Hungary' union
select 'IDN','Indonesia' union
select 'IMN','Isle of Man' union
select 'IND','India' union
select 'IOT','British Indian Ocean Territory' union
select 'IRL','Ireland' union
select 'IRN','Iran, Islamic Republic of' union
select 'IRQ','Iraq' union
select 'ISL','Iceland' union
select 'ISR','Israel' union
select 'ITA','Italy' union
select 'JAM','Jamaica' union
select 'JEY','Jersey' union
select 'JOR','Jordan' union
select 'JPN','Japan' union
select 'KAZ','Kazakhstan' union
select 'KEN','Kenya' union
select 'KGZ','Kyrgyzstan' union
select 'KHM','Cambodia' union
select 'KIR','Kiribati' union
select 'KNA','Saint Kitts and Nevis' union
select 'KOR','Korea, Republic of' union
select 'KWT','Kuwait' union
select 'LAO','Lao People''s Democratic Republic' union
select 'LBN','Lebanon' union
select 'LBR','Liberia' union
select 'LBY','Libya' union
select 'LCA','Saint Lucia' union
select 'LIE','Liechtenstein' union
select 'LKA','Sri Lanka' union
select 'LSO','Lesotho' union
select 'LTU','Lithuania' union
select 'LUX','Luxembourg' union
select 'LVA','Latvia' union
select 'MAC','Macao' union
select 'MAF','Saint Martin (French part)' union
select 'MAR','Morocco' union
select 'MCO','Monaco' union
select 'MDA','Moldova, Republic of' union
select 'MDG','Madagascar' union
select 'MDV','Maldives' union
select 'MEX','Mexico' union
select 'MHL','Marshall Islands' union
select 'MKD','Macedonia, the former Yugoslav Republic of' union
select 'MLI','Mali' union
select 'MLT','Malta' union
select 'MMR','Myanmar' union
select 'MNE','Montenegro' union
select 'MNG','Mongolia' union
select 'MNP','Northern Mariana Islands' union
select 'MOZ','Mozambique' union
select 'MRT','Mauritania' union
select 'MSR','Montserrat' union
select 'MTQ','Martinique' union
select 'MUS','Mauritius' union
select 'MWI','Malawi' union
select 'MYS','Malaysia' union
select 'MYT','Mayotte' union
select 'NAM','Namibia' union
select 'NCL','New Caledonia' union
select 'NER','Niger' union
select 'NFK','Norfolk Island' union
select 'NGA','Nigeria' union
select 'NIC','Nicaragua' union
select 'NIU','Niue' union
select 'NLD','Netherlands' union
select 'NOR','Norway' union
select 'NPL','Nepal' union
select 'NRU','Nauru' union
select 'NZL','New Zealand' union
select 'OMN','Oman' union
select 'PAK','Pakistan' union
select 'PAN','Panama' union
select 'PCN','Pitcairn' union
select 'PER','Peru' union
select 'PHL','Philippines' union
select 'PLW','Palau' union
select 'PNG','Papua New Guinea' union
select 'POL','Poland' union
select 'PRI','Puerto Rico' union
select 'PRK','Korea, Democratic People''s Republic of' union
select 'PRT','Portugal' union
select 'PRY','Paraguay' union
select 'PSE','Palestine, State of' union
select 'PYF','French Polynesia' union
select 'QAT','Qatar' union
select 'REU','Réunion' union
select 'ROU','Romania' union
select 'RUS','Russian Federation' union
select 'RWA','Rwanda' union
select 'SAU','Saudi Arabia' union
select 'SDN','Sudan' union
select 'SEN','Senegal' union
select 'SGP','Singapore' union
select 'SGS','South Georgia and the South Sandwich Islands' union
select 'SHN','Saint Helena, Ascension and Tristan da Cunha' union
select 'SJM','Svalbard and Jan Mayen' union
select 'SLB','Solomon Islands' union
select 'SLE','Sierra Leone' union
select 'SLV','El Salvador' union
select 'SMR','San Marino' union
select 'SOM','Somalia' union
select 'SPM','Saint Pierre and Miquelon' union
select 'SRB','Serbia' union
select 'SSD','South Sudan' union
select 'STP','Sao Tome and Principe' union
select 'SUR','Suriname' union
select 'SVK','Slovakia' union
select 'SVN','Slovenia' union
select 'SWE','Sweden' union
select 'SWZ','Swaziland' union
select 'SXM','Sint Maarten (Dutch part)' union
select 'SYC','Seychelles' union
select 'SYR','Syrian Arab Republic' union
select 'TCA','Turks and Caicos Islands' union
select 'TCD','Chad' union
select 'TGO','Togo' union
select 'THA','Thailand' union
select 'TJK','Tajikistan' union
select 'TKL','Tokelau' union
select 'TKM','Turkmenistan' union
select 'TLS','Timor-Leste' union
select 'TON','Tonga' union
select 'TTO','Trinidad and Tobago' union
select 'TUN','Tunisia' union
select 'TUR','Turkey' union
select 'TUV','Tuvalu' union
select 'TWN','Taiwan, Province of China' union
select 'TZA','Tanzania, United Republic of' union
select 'UGA','Uganda' union
select 'UKR','Ukraine' union
select 'UMI','United States Minor Outlying Islands' union
select 'URY','Uruguay' union
select 'USA','United States' union
select 'UZB','Uzbekistan' union
select 'VAT','Holy See (Vatican City State)' union
select 'VCT','Saint Vincent and the Grenadines' union
select 'VEN','Venezuela, Bolivarian Republic of' union
select 'VGB','Virgin Islands, British' union
select 'VIR','Virgin Islands, U.S.' union
select 'VNM','Viet Nam' union
select 'VUT','Vanuatu' union
select 'WLF','Wallis and Futuna' union
select 'WSM','Samoa' union
select 'YEM','Yemen' union
select 'ZAF','South Africa' union
select 'ZMB','Zambia' union
select 'ZWE','Zimbabwe';
GO


---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[State]
(
	[State]		[dbo].[State]		NOT NULL,
	[Name]		[varchar](25)		NOT NULL,
	[TimeZone]	[char](4)			NOT NULL,
PRIMARY KEY (State),
FOREIGN KEY ([TimeZone]) REFERENCES [Legend].[TimeZone](TimeZone)
) ON [PRIMARY]
 GO

-- Put all the states into the legend table
INSERT [Legend].[State] (State, Name, TimeZone)
SELECT 'HI','Hawaii', 'HST' UNION
SELECT 'AK','Alaska', 'AKST' UNION
SELECT 'WA', 'Washington', 'PST' UNION
SELECT 'CA','California', 'PST' UNION
SELECT 'OR','Oregon', 'PST' UNION
SELECT 'NV','Nevada', 'PST' UNION
SELECT 'AZ','Arizona', 'MST' UNION
SELECT 'UT','Utah', 'MST' UNION
SELECT 'CO','Colorado', 'MST' UNION
SELECT 'NM','New Mexico', 'MST' UNION
SELECT 'MT','Montana', 'MST' UNION
SELECT 'WY','Wyoming', 'MST' UNION
SELECT 'ID','Idaho', 'MST' UNION
SELECT 'ND','North Dakota', 'CST' UNION
SELECT 'SD','South Dakota', 'CST' UNION
SELECT 'NE','Nebraska', 'CST' UNION
SELECT 'KS','Kansas', 'CST' UNION
SELECT 'OK','Oklahoma', 'CST' UNION
SELECT 'TX','Texas', 'CST' UNION
SELECT 'MN','Minnesota', 'CST' UNION
SELECT 'AL','Alabama', 'CST' UNION
SELECT 'IL','Illinois', 'CST' UNION
SELECT 'AR','Arkansas', 'CST' UNION
SELECT 'MO','Missouri', 'CST' UNION
SELECT 'IA','Iowa', 'CST' UNION
SELECT 'LA','Louisiana', 'CST' UNION
SELECT 'MS','Mississippi', 'CST' UNION
SELECT 'TN','Tennessee', 'CST' UNION
SELECT 'CT','Connecticut', 'EST' UNION
SELECT 'DE','Delaware', 'EST' UNION
SELECT 'FL','Florida', 'EST' UNION
SELECT 'GA','Georgia', 'EST' UNION
SELECT 'IN','Indiana', 'EST' UNION
SELECT 'KY','Kentucky', 'EST' UNION
SELECT 'ME','Maine', 'EST' UNION
SELECT 'MD','Maryland', 'EST' UNION
SELECT 'MA','Massachusetts', 'EST' UNION
SELECT 'MI','Michigan', 'EST' UNION
SELECT 'NH','New Hampshire', 'EST' UNION
SELECT 'NJ','New Jersey', 'EST' UNION
SELECT 'NY','New York', 'EST' UNION
SELECT 'NC','North Carolina', 'EST' UNION
SELECT 'OH','Ohio', 'EST' UNION
SELECT 'PA','Pennsylvania', 'EST' UNION
SELECT 'RI','Rhode Island', 'EST' UNION
SELECT 'SC','South Carolina', 'EST' UNION
SELECT 'VT','Vermont', 'EST' UNION
SELECT 'VA','Virginia', 'EST' UNION
SELECT 'WV','West Virginia', 'EST' UNION
SELECT 'WI','Wisconsin', 'EST' UNION
SELECT 'DC','Washington DC', 'EST' UNION
SELECT 'PR','Puerto Rico', 'EST' UNION
SELECT 'VI','U.S. Virgin Islands', 'EST'
;
GO
