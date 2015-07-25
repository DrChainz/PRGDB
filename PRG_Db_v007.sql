USE MASTER;
GO

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'PRG'))
	DROP DATABASE [PRG];
GO

CREATE DATABASE [PRG];		-- likely oughta define size here
GO

USE [PRG];
GO

create table [dbo].[Tmp] ( LoadData char(1) NOT NULL );
INSERT [dbo].[Tmp] SELECT 'Y';
GO

---------------------------------------
-- Schemas
---------------------------------------
CREATE Schema [Legend];
GO

---------------------------------------
-- Rules
---------------------------------------
CREATE RULE [Legend].[DbAction]
AS
@Val IN ('UPDATE','DELETE','INSERT')
GO

CREATE RULE [Legend].[AreaCd] 
AS
@Val like '[0-9][0-9][0-9]'
GO

CREATE RULE [dbo].[State] 
AS
@Val like '[A-Z][A-Z]'
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

CREATE RULE [Legend].[SaleRole]
AS
@Val IN ('Open','Sale','TO')
GO


---------------------------------------
-- User Defined Types
---------------------------------------
CREATE TYPE [Legend].[DbAction] FROM [char](6) NOT NULL
GO

CREATE TYPE [Legend].[AreaCd] FROM [char](3) NOT NULL
GO

CREATE TYPE [dbo].[State] FROM [char](2) NOT NULL
GO

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

CREATE TYPE [Legend].[SaleRole] FROM [varchar](4) NOT NULL
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

sp_bindrule '[Legend].[SaleRole]', '[Legend].[SaleRole]';
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
-- select * from Legend.State
-----------------------------------------
CREATE TABLE [PRG].[Legend].[State]
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

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[AreaCdState]
(
	[AreaCd]	[Legend].[AreaCd]	NOT NULL	UNIQUE,
	[State]		[dbo].[State]		NOT NULL,
PRIMARY KEY (AreaCd),
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
)
GO

INSERT [Legend].[AreaCdState] (AreaCd, State)
SELECT AreaCd, State
FROM [PrivateReserve].[Legend].[StateAreaCd]
WHERE State IN (SELECT State FROM [Legend].[State]);
GO

---------------------------------------
-- drop table [Legend].[FirstName];
-----------------------------------------
CREATE TABLE [Legend].[FirstName]
(
	FirstName		[varchar](20)			NOT NULL,
	Gender			[Legend].[Gender]		NOT NULL,
	Cnt				[int]					NOT NULL,
	PercentWhole	[numeric](5,5)			NOT NULL
);

CREATE UNIQUE CLUSTERED INDEX PK_FirstName ON [Legend].[FirstName] (FirstName);
GO

-- truncate table [Legend].[FirstName];

-----------------------------------------
-- top 5000 are a bit more than 92%
-----------------------------------------
INSERT [Legend].[FirstName] (FirstName, Gender, Cnt, PercentWhole)
SELECT TOP 15000 [dbo].[udf_TitleCase] (rtrim(FirstName)), 'U' as Gender, Cnt, PercentWhole
FROM [Joe].[legend].[FirstName]
WHERE BadName = 'N'
  AND LEN(FirstName) <= 20
  AND Cnt >= 15
  and FirstName not in ('Accounting','Adm','Admin','Administrative','Advanced','Nguyen','The')
ORDER BY Cnt DESC;
GO


select top 1000 * from Car.Car
select * from Car.Contract

select * from Car.MakeInclude

select * from Legend.State

select * from dnc.State



/*
DELETE [Legend].[FirstName]
WHERE 
GO

select * from [Legend].[FirstName]
where Gender = 'U'
  and FirstName like '%a'
order by cnt desc

select Gender, sum(Cnt) SumCnt
from [Legend].[FirstName]
group by Gender
*/

-- select * from [Legend].[FirstName] where Gender = 'U' order by cnt desc;

-- select * from [Legend].[FirstName] where len(FirstName) = 2 order by cnt desc -- need to figure this one out
-- select * from [Legend].[FirstName] where len(FirstName) = 3 order by cnt desc -- need to figure this one out

update [Legend].[FirstName] SET Gender = 'M' WHERE FirstName in ('John','Mike','Mark','Matt','James','Jim','David','Robert','Richard','Steve','Paul','Thomas','Tom','Paul','Gary',
																 'Scott','Bill','Charles','Jeff','Michael','Bob','Brian','William','Larry','Joe','Kevin','Joseph','George',
																 'Dan','Steven','Dave','Peter','Tim','Don','Frank','Ron','Greg','Dennis','Jerry','Rick','Daniel','Stephen',
																 'Ken','Bruce','Eric','Donald','Terry','Jack','Edward','Randy','Ronald','Kenneth','Jeffrey','Ed',
																 'Doug','Keith','Roger','Alan','Patrick','Craig','Tony','Anthony','Jason','Fred','Todd','Wayne','Jay',
																 'Douglas','Christopher','Timothy','Carl','Lee','Brad','Andrew','Ray','Barry','Gregory','Chuck','Howard',
																 'Matthew','Martin','Gerald','Rob','Phil','Jon','Ralph','Al','Walter','Henry','Allen','Raymond','Philip','Lawrence',
																 'Art','Billy','Brent','Carlton','Sam','Dean','Andy','Ted','Harry','Harold','Roy','Joel','Ben','Bryan','Rich',
																 'Jonathan','Arthur','Louis','Nick','Alex','Marc','Sean','Russell','Phillip','Jose','Shawn','Ryan','Danny','Victor','Pete',
																 'Albert','Adam','Neil','Norman','Dick','Gordon','Charlie','Kent','Aaron','Stan','Kurt','Chad','Carlos',
																 'Randall','Eugene','Leonard','Rodney','Jimmy','Bobby','Stanley','Stuart','Allan','Samuel','Warren','Troy',
																 'Marty','Eddie','Marvin','Rod','Curtis','Vincent','Jeremy','Bernard','Earl','Brett','Russ','Karl','Juan',
																 'Kirk','Nicholas','Duane','Frederick','Justin','Darrell','Tommy','Nathan','Guy','Lance','Benjamin',
																 'Bradley','Leo','Luis','Lou','Ross','Micheal','Josh','Jesse','Ernest','Kyle','Edwin','Harvey',
																 'Mario','Jeffery','Gregg','Johnny','Ronnie','Lloyd','Max','Derek','Leon','Neal','Lois','Jerome','Herbert',
																 'Shane','Vince','Mitchell','Alfred','Lewis','Hugh','Jo','Ian','Will','Darren','Cliff','Brandon','Arnold',
																 'Travis','Dwight','Alexander','Curt','Mitch','Melvin','Les','Theodore','Kenny','Erik','Joshua','Gerry',
																 'Jorge','Wade','Darryl','Clark','Hal','Roland','Calvin','Grant','Marshall','Stewart','Clifford','Daryl',
																 'Nelson','Rex','Manuel','Gilbert','Oscar','Antonio','Ernie','Wesley','Maurice','Wes','Marcus','Simon',
																 'Byron','Clyde','Dwayne','Marion','Clay','Clarence','Gerard','Jacob','Alvin','Milton','Hank','Vernon','Bart',
																 'Bernie','Ali','Casey','Andre','Chip','Ira','Leroy','Herb','Floyd','Miguel','Morris','Ivan','Garry','Bud',
																 'Evan','Clint','Seth','Corey','Lonnie','Herman','Lyle','Fernando','Cory','Joey','Hector','Raul','Jaime',
																 'Jake','Lester','Blake','Norm','Ricardo','Colin','Mickey','Geoffrey','Sal','Edgar','Claude','Clayton','Roberto',
																 'Willie','Adrian','Bert','Rudy','Len','Derrick','Sheldon','Malcolm','Walt','Skip','Bret','Hans','Franklin','Luke',
																 'Dominic','Gus','Gil','Laurence','Ruben','Spencer','Geoff','Francisco','Mohammad','Murray','Javier','Mathew','Terrence',
																 'Buddy','Denis','Chester','Felix','Wallace','Ramon','Julio','Myron','Tyler','Vic','Lowell','Wilson','Jared','Sergio',
																 'Graham','Oliver','Marco','Ned','Toby','Eduardo','Pedro','Wendell','Trevor','Manny','Mohammed','Armando','Jesus',
																 'Sid','Robbie','Raj','Owen','Dustin','Damon','Wally','Elliot','Vern','Darrel','Edmund','Randolph','Eli','Rodger','Enrique',
																 'Benny','Tod','Omar','Dirk','Russel','Mick','Willard','Harris','Burt','Stephan','Alfredo','Angelo','Shaun','Jess',
																 'Abraham','Reginald','Lane','Preston','Nate','Monte','Conrad','Pierre','Trent','Terrance','Isaac','Miles','Austin',
																 'Ward','Reggie','Salvatore','Randal','Ty','Monty','Bo','Virgil','Mack','Elliott','Doyle','Erick','Terence',
																 'Boyd','Elmer','Bradford','Garrett','Cesar','Irving','Forrest','Duncan','Chet','Lenny','Brendan','Irwin','Blaine',
																 'Vance','Burton','Scot','Winston','Carter','Jerald','Sherman','Leland','Lindsey','Stefan','Dallas','Pablo','Saul','Reid',
																 'Julius','Trey','Nathaniel','Fredrick','Bryant','Ernesto','Abdul','Bryce','Archie','Abe','Lamar','Dominick','Harlan',
																 'Hugo','Bruno','Sanjay','Syed','Ravi','Woody','Homer','Gustavo','Freddie','Hubert','Dino','Boris',
																 'Cody','Alton','Roderick','Anderson','Erwin','Andres','Alejandro','Berry','Otto','Tyrone','Barney','Frederic',
																 'Ashok','Amir','Garth','Rudolph','Edmond','Luther','Fritz','Dewayne','Alfonso','Mason','Johnathan','Rocco','Dexter',
																 'Thom','Lionel','Lorenzo','Ethan','Robb','Mohamed','Noah','Norbert','Nigel','Tad','Emmanuel','Zachary','Otis','Taylor','Emil',
																 'Louie','Vijay','Ramesh','Heath','Ahmed','Dewey','Lars','Brain','Parker','Sterling','Lanny','Duke','Klaus','Marcel',
																 'Vladimir','Buck','Zack','Emilio','Stu','Wilbur','Salvador','Tomas','Roman','Orlando','Carlo','Jonathon','Harrison','Thad',
																 'Gavin','Philippe','Dudley','Gino','Damian','Gerardo','Cole','Rolf','Devin','Jed','Zach','Moses','Nicolas','Rolando',
																 'Daren','Alec','Irvin','Nolan','Reuben','Delbert','Collin','Freddy','Donn','Gill','Reza','Bennie','Hassan','Igor','Moe',
																 'Rajesh','Lucas','Nat','Emmett','Seymour','Robby','Diego','Felipe','Derick','Raphael','Mat','Clive','Wolfgang','Emanuel',
																 'Brant','Bryon','Marv','Marlon','Nell','Donovan','Charley','Charley','Riley','Quentin','Wilfred','Xavier','Jerrold','Rodolfo',
																 'Aldo','Zane','Cornelius','Kieth','Ford','Serge','Beau','Theo','Wright','Logan','Maury','Jeffry','Earnest','Nestor','Mitchel','Buzz','Newton',
																 'Hamid','Willy','Muhammad','Lincoln','Bharat','Norris','Orville','Santiago','Moshe','Marcelo','Cyrus','Dion','Rhett',
																 'Prakash','Hiroshi','Mo','Giovanni','Rakesh','Deepak','Quinn','Rodrigo','Phill','Grover','Franco','Forest','Sylvester',
																 'Rajiv','Markus','Rosario','Tucker','Jerold','Rubin','Malcom','Kraig','Jefferson','Leonardo','Fredric','Rufus','Brice','Merlin','Loyd',
																 'Everett','Cameron','Morgan','Reed','Clinton','Darrin','Miller','Sanford','Brady','Vaughn','Darwin','Lew','Hunter','Galen','Horace',
																 'Ahmad','Suresh','Gabe','Cedric','Amos','West','Solomon','Nima');


update [Legend].[FirstName] SET Gender = 'F' WHERE FirstName in ('Mary','Linda','Susan','Karen','Lisa','Barbara','Nancy','Carol','Kathy','Jennifer','Donna','Patricia','Sharon',
																 'Debbie','Diane','Michelle','Judy','Ann','Sandra','Laura','Elizabeth','Cindy','Julie','Amy','Kelly','Sue',
																 'Janet','Brenda','Lynn','Deborah','Cheryl','Lori','Pam','Debra','Jane','Cathy','Christine','Denise','Sandy',
																 'Kathleen','Maria','Betty','Beverly','Bridget','Joan','Cynthia','Margaret','Melissa','Jan','Carolyn','Stephanie',
																 'Pamela','Tracy','Connie','Angela','Joyce','Tammy','Rebecca','Beth','Teresa','Paula','Anne','Wendy','Janice','Leslie',
																 'Tina','Gail','Shirley','Sherry','Dawn','Jill','Jackie','Bonnie','Sarah','Peggy','Diana','Heather','Kimberly','Marilyn',
																 'Ruth','Martha','Becky','Andrea','Dana','Judith','Joanne','Catherine','Ellen','Helen','Theresa','Laurie',
																 'Marie','Vicki','Sheila','Suzanne','Patty','Anna','Shannon','Kay','Gloria','Sally','Rhonda','Renee','Dorothy','Rita',
																 'Jessica','Rose','Michele','Virginia','Katherine','Valerie','Nicole','Alice','Anita','Monica','Sara','Christina',
																 'Maureen','Francis','Phyllis','Stacy','Gina','Amanda','Darlene','Wanda','Jeanne','Angie','Carla','Holly','Rachel','Eileen',
																 'Liz','Joann','Kathryn','Carrie','Marsha','Melanie','Jenny','Marcia','Annette','Elaine','Colleen','Stacey','Joy','Victoria',
																 'Shelly','Penny','Charlotte','Julia','Jody','Carmen','Sylvia','Erin','Heidi','Norma','Deb','Patti','Doris','Emily',
																 'Dianne','Sheryl','Vickie','Louise','Yvonne','Christy','Claudia','Toni','Evelyn','Katie','Barb','April','Jacqueline','Frances','Dee',
																 'Irene','Roberta','Melinda','Gayle','Sherri','Vicky','Fran','Charlene','Kate','Grace','Caroline','June','Regina','Marlene','Crystal',
																 'Betsy','Lynne','Lauren','Arlene','Rosemary','Lorraine','Tracey','Alicia','Kristen','Allison','Tara','Rene','Veronica',
																 'Tanya','Kristin','Jodi','Tiffany','Audrey','Jeanette','Shelley','Sheri','Natalie','Glenda','Deanna',
																 'Tonya','Ashley','Tamara','Vivian','Danielle','Nina','Margie','Susie','Angel','Lucy','Marianne','Maryann','Loretta','Eva',
																 'Claire','Amber','Lynda','Erica','Marjorie','Megan','Molly','Maggie','Ginger','Loren','Vanessa','Ana','Alison',
																 'Yolanda','Annie','Melody','Noel','Kristi','Rosa','Julian','Trish','Shari','Belinda','Patsy','Cecil','Jeannie','Bobbie',
																 'Gale','Sonia','Joanna','Pauline','Esther','Faye','Roxanne','Kristine','Tricia','Cheri','Leah','Mona','Robyn',
																 'Gretchen','Courtney','Lydia','Mindy','Karla','Samantha','Dolores','Juanita','Eleanor','Georgia','Tami','Sonya',
																 'Delores','Kristy','Marla','Christie','Jana','Doreen','Brandy','Nora','Alberto','Edith','Paulette','Lillian','Candace','Darla',
																 'Shelly','Penny','Charlotte','Julia','Jody','Carmen','Sylvia','Erin','Heidi','Norma','Deb','Patti','Doris','Emily',
																 'Lana','Dianna','Priscilla','Sandi','Candy','Marge','Karin','Katrina','Nikki','Lynette','Cecilia','Florence','Yvette','Kelli',
																 'Lyn','Maxine','Traci','Sabrina','Kara','Sherrie','Misty','Edna','Mandy','Clara','Lorie','Meredith','Emma','Jennie',
																 'Trudy','Kristina','Joni','Josephine','Naomi','Erika','Judi','Nadine','Candice','Olga','Rochelle','Ronda','Trisha',
																 'Harriet','Janine','Ginny','Hope','Patrice','Elena','Debby','Carroll','Monique','Gladys','Lora','Iris','Krista','Adrienne',
																 'Leigh','Kari','Janie','Marcy','Kelley','Jen','Dina','Myra','Felicia','Bernadette','Brooke','Rosie','Vera','Jayne','Bernice',
																 'Alma','Margo','Wilma','Lindsay','Susanne','Kaye','Stella','Polly','Cassandra','Lucille','Faith','Francine','Shelia',
																 'Kerri','Kathie','Jodie','Maryanne','Cherie','Jeannette','Dena','Lesley','Jeanie','Cara','Thelma','Trina','Dora','Kellie',
																 'Laurel','Mildred','Ingrid','Ramona','Camille','Sonja','Celeste','Dixie','Shelby','Peg','Sunny','Madeline','Bev','Paige',
																 'Meg','Christi','Darcy','Barbra','Debi','Kathi','Jeanine','Beatrice','Rosemarie','Libby','Missy','Lea','Isabel','Hilda',
																 'Helene','Mimi','Kirsten','Hazel','Kristie','Josie','Christa','Marta','Kendra','Aimee','Tammie','Eve','Ida',
																 'Alexis','Noreen','Fay','Grady','Katy','May','Dottie','Millie','Keri','Cristina','Olivia','Marcie','Therese','Abby','Janette',
																 'Stacie','Cindi','Lauri','Rosalie','Rachael','Lorrie','Celia','Alexandra','Marci','Alisa','Whitney','Natasha','Lena',
																 'Lena','Aubrey','Israel','Elise','Desiree','Sophia','Ethel','Kitty','Marti','Elisa','Arnie','Mari','Rena','Tracie','Deana','Cyndi','Ellie',
																 'Leanne','Cathleen','Agnes','Leticia','Daisy','Sondra','Brandi','Jocelyn','Jeannine','Antoinette','Coleen','Ilene','Amelia',
																 'Adriana','Clare','Jacquelyn','Terrie','Lily','Elsa','Lupe','Johanna','Lourdes','Corinne','Suzie','Marybeth','Suzy','Raquel','Suzette',
																 'Daphne','Marylou','Bethany','Lara','Deanne','Margarita','Hillary','Debora','Lola','Rachelle','Lucia','Marguerite','Rosanne','Elisabeth',
																 'Lucinda','Shauna','Luz','Mia','Jenifer','Liza','Hannah','Dona','Nicki','Debbi','Ursula','Jenna','Staci','Lorena','Helena','Claudette',
																 'Marcella','August','Kimberley','Leona','Page','Karyn','Dominique','Suzan','Clair','Dolly','Shiela','Tasha','Cathie','Stefanie',
																 'Cassie','Janelle','Marina','Donnie','Marian','Ruby','Bobbi','Leann','Silvia','Shawna','Adele','Cherry','Ella','Bertha','Pearl','Sharron',
																 'Lila','Sister','Tammi','Nanette','Marisa','Nichole','Hilary','Jacque','Marissa','Jules','Bridgette','Mara','Ming','Lindy','Chandra',
																 'Cecelia','Deirdre','Shana','Ivy','Armand','Jude','Caryn','Shanna','Sheree','Lilly','Janna','Glenna','Deena','Dot','Gigi','Pattie','Loraine',
																 'Freda','Nellie','Wendi','Margret','Violet','Ariel','Angelica','Velma','Mercedes','Miranda','Penelope','Ester','Mina','Lorri','Flora',
																 'Rebekah','Valarie','Chrissy','Carolina','Roseann','Vikki','Saundra','Melisa','Roseanne','Winnie','Tabitha','Nicky','Lilian','Juliet',
																 'Cristy','Brigitte','Debrah','Jeniffer','Charity','Erma','Rosalyn','Susana','Katharine','Maryellen','Lesa','Niki','Dorthy','Shanon',
																 'Tori','Cathryn','Estelle','Bridgett','Charmaine','Bettie','Zoe','Lynnette','Isabelle','Susanna','Virgina','Kasey','Jasmine','Krystal','Leeann',
																 'Lina','Greta','Ladonna','Nadia','Genevieve','Allyson','Sallie','Angelina','Deann','Simone','Mellisa','Gabrielle','Sophie','Li','Robbin',
																 'Carrol','Corrine','Justine','Cleo','Tia','Geneva','Cecile','Gaye','Juli','Deidre','Summer','Alyssa','Julianne','Rhoda','Patrica',
																 'Carey','Geraldine','Blair','Laverne','Elsie','Bonita','Antonia','Verna','Bea','Ava','Gayla','Gena','Garcia','Hanna','Tonia','Alisha','Audra',
																 'Luisa','Irina','Krishna','Reba','Benita','Alana','Leila','Monika','Tana','Elissa','Serena','Georgina','Petra','Eugenia','Dara','Nicola',
																 'Alissa','Alberta','Gabriela','Tamra','Juliana','Rhea','Leanna','Henrietta','Francesca','Karina','Rosanna','Edwina','Ezra','Shea','Vonda',
																 'Danna','Louisa','Ericka','Mayra','Carmela','Kayla','Mahendra','Thea','Charla','Camilla','Bettina','Dayna','Fiona','Maya','Lidia','Helga',
																 'Keisha','Gilda','Natalia','Nola','Della','Chelsea','Tisha','Selena','Daniela','Sofia','Mellissa','Marva','Lilia','Sasha','Elva',
																 'Tera','Rona','Juana','Madonna','Liliana','Marita','Minerva','Elvira','Malinda','Athena','Marcela','Terra','Akira','Jeanna','Tamera',
																 'Deidra','Lela','Lela','Althea','Roxanna','Jena','Tatiana','Sheena','Eliza','Fatima','Lia','Donita','Angelia','Twila','Gisela','Dorothea',
																 'Sabina','Tessa','Anastasia','Selina','Sharla','Melva','Teressa','Andra','Asa','Frieda','Estella','Lolita','Bella','Asha','Selma','Valeria',
																 'Alexandria','Mira','Rebeca','Suzanna','Kira','Adela','Lita','Roma','Babara','Freida','Roxana','Josefina','Felecia','Cinthia','Valencia',
																 'Twyla','Zina','Uma','Veena','Laila','Larisa','Paulina','Sunita','Pricilla','Mika','Corinna','Magdalena','Irena','Rosetta','Chanda','Shonda',
																 'Lida','Tressa','Isabella','Daniella','Katina','Venessa','Lula','Odessa','Rebbeca','Alexia','Augusta','Cecila','Terresa','Samatha','Rosana',
																 'Zelma','Carola','Leda','Rosella');

/*
select max(len(FirstName)) from [Legend].[FirstName]
select FirstName from [Legend].[FirstName] where len(FirstName) = 11
select * from [Legend].[FirstName];
*/

-- select * from [Legend].[FirstName];

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Legend].[Day]
(
	[Dt]			[smalldatetime]			NOT NULL,
	[WeekDayNum]	[tinyint]				NOT NULL,
 	[WeekDay]		[Legend].[WeekDay]		NOT NULL,
	[Payday]		[Legend].[YesNo]		NOT NULL,
	[PayPeriod]		[tinyint]				NOT NULL,
	[Week]			[smallint]				NOT NULL,
	[Year]			[Legend].[Year]			NOT NULL,
	[Month]			[tinyint]				NOT NULL,
	[YearMonth]		[Legend].[YearMonth]	NOT NULL,
	[Qtr]			[Legend].[Qtr]			NOT NULL,
PRIMARY KEY (Dt)
) ON [PRIMARY]
GO


IF OBJECT_ID(N'Legend.up_MakeDay') IS NOT NULL
	DROP PROC [Legend].[up_MakeDay]
 GO

-----------------------------------------------------------------
-- Proc used to populate all the days of the year passed
-- called when done to put every day in current year into table
-- so have something to reference for reporting 
-----------------------------------------------------------------
CREATE PROC [Legend].[up_MakeDay]
	@Year	char(4) = NULL
AS
SET NOCOUNT ON;

	IF @Year IS NULL
		SET @Year = datepart(year,getdate());


	DECLARE @Days TABLE
	(
		Dt			smalldatetime	NULL,
		WeekDayNum	tinyint			NULL,
		WeekDay		varchar(9)		NULL,
		Payday		char(1)			NULL,
		PayPeriod	tinyint			NULL,
		Week		smallint		NULL,
		Year		char(4)			NULL,
		Month		tinyint			NULL,
		YearMonth	char(6)			NULL,
		Qtr			tinyint			NULL
	);

	DECLARE @Dt smalldatetime = convert(smalldatetime,@Year+'-1-1');
	DECLARE @EndDt smalldatetime = convert(smalldatetime,@Year+'-12-31');
	DECLARE @YearMonth char(6);
	DECLARE @Month	tinyint = 0;

	WHILE (@Dt <= @EndDt)
	BEGIN
		SET @Month = DATEPART(m,@Dt);

		IF (@Month < 10)
			SET @YearMonth = @Year + '0' + convert(char(1), @Month);
		ELSE 
			SET @YearMonth = @Year + convert(char(2), @Month);

		INSERT @Days (Dt, Payday, YearMonth)
		VALUES (@Dt, 'N',  @YearMonth);

		SET @Dt += 1;
	END

	UPDATE @Days
	SET Qtr = ( CASE
				WHEN DATEPART(m,Dt) BETWEEN 1 AND 3 THEN 1
				WHEN DATEPART(m,Dt) BETWEEN 4 AND 6 THEN 2
				WHEN DATEPART(m,Dt) BETWEEN 7 AND 9 THEN 3
				WHEN DATEPART(m,Dt) BETWEEN 10 AND 12 THEN 4
				END );
	
	update @Days set Year = datepart(Year, Dt);

	update @Days set Month = datepart(Month, Dt);

	update @Days set Week = DATEPART(wk,Dt);

	update @Days set WeekDayNum = datepart(weekday, Dt);

	update @Days set WeekDay = datename(weekday,Dt);

	update @Days set Payday = 'Y'
	where WeekDay = 'Friday' and (Week % 2) = 0;

-- 	DECLARE @Dt smalldatetime;
	DECLARE @Payday char(1);
	DECLARE @PayPeriod tinyint = 1;

	DECLARE pay_period_cursor CURSOR FOR
	SELECT Dt, Payday
	FROM @Days FOR UPDATE;

	OPEN pay_period_cursor
	FETCH NEXT FROM pay_period_cursor INTO @Dt, @Payday

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
       UPDATE @Days SET PayPeriod = @PayPeriod WHERE CURRENT OF pay_period_cursor;

       FETCH NEXT FROM pay_period_cursor INTO @Dt, @Payday

	   IF (@Payday = 'Y')
			SET @PayPeriod += 1;
	END   

	CLOSE pay_period_cursor
	DEALLOCATE pay_period_cursor

	INSERT [Legend].[Day] ( Dt, WeekDayNum, WeekDay, Payday, PayPeriod, Week, Year, Month, YearMonth, Qtr )
	SELECT Dt, WeekDayNum, WeekDay, Payday, PayPeriod, Week, Year, Month, YearMonth, Qtr
	FROM @Days
	WHERE Dt NOT IN (select Dt FROM [Legend].[Day])
	;
 GO

DECLARE @MakeDayYear smallint = 2015;
DECLARE @chYear CHAR(4);
WHILE (@MakeDayYear < 2045)
BEGIN
	SET @chYear = CAST(@MakeDayYear AS CHAR(4));
	EXEC [Legend].[up_MakeDay] @chYear;
	SET @MakeDayYear += 1;
END
GO

---------------------------------------
--	Call Disposition Codes and their meanings
-----------------------------------------
/*
CREATE TABLE [Legend].[Disp]
(
	[DispCd]		[char](4)		NOT NULL,
	[DispDesc]		[varchar](50)	NOT NULL,
PRIMARY KEY ([DispCd])
) ON [PRIMARY]
-- GO
*/

/*
INSERT [Legend].[Disp] (DispCd, DispDesc)
SELECT 'DNC','Do Not Call' UNION
SELECT 'NI', 'Not Interested' UNION
SELECT 'NOC', 'Doesn''t Own Car' UNION
SELECT 'WN', 'Wrong Number' UNION
SELECT 'AA', 'Answering Machine Auto' UNION
SELECT 'ADC', 'Disconnected Number Auto'; 
-- GO
*/


---------------------------------------
-- use prg;
-----------------------------------------
/*
CREATE TABLE [Legend].[FirstName]
(
	[FirstName]		[varchar](50)		NOT NULL UNIQUE,
	[Cnt]			[int]				NULL,
	[BadName]		[Legend].[YesNo]	NOT NULL
) ON [PRIMARY]
-- GO
*/
-- save time while testing
/*
DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [Legend].[FirstName] (FirstName, Cnt, BadName)
	SELECT [dbo].[udf_TitleCase] (FirstName), Cnt, BadName
	FROM [QSM].[Legend].[FirstName]
	WHERE BadName = 'N'
	  AND Cnt >= 15;

/*	select count(*) FROM [QSM].[Legend].[FirstName]
	select * FROM [QSM].[Legend].[FirstName] where BadName = 'N' and Cnt > 15 order by Cnt asc;
	select [PRG].[dbo].[udf_TitleCase] ('Tina-marie');
*/
END
-- GO
*/

-- Figure out how to create the SIC tables correctly.
-- this also likely oughta have a log entry associated with it such that we know
-- the last time the data was updated.

--***************************************
--
--***************************************
CREATE Schema [Core];
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Core].[Permission]
(
	[PermId]			[int]			NOT NULL	IDENTITY(0,1),
	[Permission]		[varchar](20)	NOT NULL	UNIQUE,
PRIMARY KEY ([PermId])
);

SET IDENTITY_INSERT [Core].[Permission] ON;
INSERT [Core].[Permission] (PermId, Permission)
SELECT 0, 'Permission' UNION
SELECT 1, 'Role' UNION
SELECT 2, 'Usr';
SET IDENTITY_INSERT [Core].[Permission] OFF;

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Core].[Role]
(
	[RoleId]			[int]			NOT NULL	IDENTITY(0,1),
	[Role]				[varchar](30)	NOT NULL	UNIQUE,
PRIMARY KEY ([RoleId])
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Core].[Role] ON;
INSERT [Core].[Role] (RoleId, Role)
SELECT 0, 'root' UNION
SELECT 1, 'Admin' UNION
SELECT 2, 'Manager' UNION
SELECT 3, 'Closer';
SET IDENTITY_INSERT [Core].[Role] OFF;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Core].[RolePermission]
(
	[RoleId]			[int]			NOT NULL,
	[PermId]			[int]			NOT NULL
);

CREATE UNIQUE INDEX PK_RolePermission ON [Core].[RolePermission] (RoleId, PermId);

INSERT [Core].[RolePermission] (RoleId, PermId)
SELECT 0, 0 UNION
SELECT 0, 1 UNION
SELECT 0, 2;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Core].[Usr]
(
	[UsrId]				[int]				NOT NULL	IDENTITY(0,1),
	[Usr]				[varchar](10)		NOT NULL	UNIQUE,
	[RoleId]			[int]				NOT NULL,
	[Disabled]			[Legend].[YesNo]	NOT NULL,
PRIMARY KEY ([UsrId]),
FOREIGN KEY ([RoleId]) REFERENCES [Core].[Role] (RoleId)
);

SET IDENTITY_INSERT [Core].[Usr] ON;
INSERT [Core].[Usr] (UsrId, Usr, RoleId)
SELECT 0, 'root', 0	UNION
SELECT 1, 'Matt', 1 UNION
SELECT 2, 'PJ', 1 UNION
SELECT 3, 'Katelynn', 2 UNION
SELECT 4, 'Dan', 3 UNION
SELECT 5, 'Ramos', 3;
SET IDENTITY_INSERT [Core].[Usr] OFF;

GO

--***************************************
--
--***************************************
CREATE Schema [Employee];
GO

CREATE RULE [Employee].[SSN] 
AS
@SSN like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
GO

CREATE TYPE [Employee].[SSN] FROM [char](11) NOT NULL
GO

sp_bindrule '[Employee].[SSN]', '[Employee].[SSN]';
GO


--------------------------------------------------------------------------------------------
--  don't know if this pay rate hour thing is going to be used - maybe a modeling excercise
--------------------------------------------------------------------------------------------
CREATE TABLE [Employee].[HrRate]
(
	[HrRateId]	[int]			NOT NULL	IDENTITY(1,1),
	[Name]		[varchar](30)	NOT NULL	UNIQUE,
	[HrPayAmt]	[money]			NOT NULL
PRIMARY KEY ([HrRateId])
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Employee].[HrRate] ON;
INSERT [Employee].[HrRate] (HrRateId, Name, HrPayAmt)
SELECT 1, 'Probation', 10 UNION
SELECT 2, 'Serf', 11 UNION
SELECT 3, 'Peasant', 12 UNION
SELECT 4, 'Knight', 13 UNION
SELECT 5, 'Manager/Lord/Noble', 14
SET IDENTITY_INSERT [Employee].[HrRate] OFF;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Employee].[Role]
(
	[RoleId]			[int]			NOT NULL	IDENTITY(1,1),
	[Role]				[varchar](30)	NOT NULL	UNIQUE,
	[DefaultHrRateId]	[int]			NULL
PRIMARY KEY ([RoleId])
FOREIGN KEY ([DefaultHrRateId]) REFERENCES [Employee].[HrRate] (HrRateId)
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Employee].[Role] ON;
INSERT [Employee].[Role] (RoleId, Role, DefaultHRRateId)
SELECT 1, 'Screener', 1 UNION
SELECT 2, 'Manager', 5 UNION
SELECT 3, 'Closer', NULL UNION
SELECT 4, 'T.O.', NULL
SET IDENTITY_INSERT [Employee].[Role] OFF;
GO

CREATE TABLE [Employee].[TaxClass]
(
	[TaxClass]			[varchar](10)		NOT NULL UNIQUE,
PRIMARY KEY ([TaxClass])
);
GO

INSERT [Employee].[TaxClass] (TaxClass)
select 'W2' UNION
select '1099';
GO

---------------------------------------
-- drop TABLE [Employee].[Employee]
-----------------------------------------
CREATE TABLE [Employee].[Employee]
(
	[EmployeeId]		[int]				NOT NULL	IDENTITY(1,1),
	[SSN]				[Employee].[SSN]	NOT NULL	UNIQUE,
	[TaxClass]			[varchar](10)		NOT NULL,
	[RoleId]			[int]				NOT NULL,
	[HrRateId]			[int]				NOT NULL,
	[HireDt]			[smalldatetime]		NOT NULL,
	[FirstName]			[varchar](20)		NOT NULL,
	[LastName]			[varchar](30)		NULL,
	[Phone]				[Legend].[Phone]	NULL,
	[Address]			[varchar](50)		NULL,
	[Address2]			[varchar](50)		NULL,
	[City]				[varchar](30)		NULL,
	[State]				[State]				NULL,
	[Zip]				[varchar](10)		NULL,
PRIMARY KEY ([EmployeeId]),
FOREIGN KEY ([TaxClass]) REFERENCES [Employee].[TaxClass] (TaxClass),
FOREIGN KEY ([RoleId]) REFERENCES [Employee].[Role] (RoleId),
FOREIGN KEY ([HrRateId]) REFERENCES [Employee].[HrRate] (HrRateId),
FOREIGN KEY ([HireDt]) REFERENCES [Legend].[Day] (Dt)
);
GO

SET IDENTITY_INSERT [Employee].[Employee] ON;
INSERT [Employee].[Employee] (EmployeeId, SSN, TaxClass, RoleId, HrRateId, FirstName, HireDt)
select 0, '000-00-0000', '1099', 3, 5, 'House',  '2015-04-01' union
select 1, '123-45-6789', '1099', 3, 5, 'Tawney', '2015-04-01' union
select 2, '234-12-3456', '1099', 1, 1, 'Guz Jr', '2015-04-01' union
SELECT 3, '566-89-8469', '1099', 2, 5, 'Chainz', '2015-04-01' union
select 4, '123-45-6798', 'W2', 1, 2, 'Prego', '2015-04-01' union
select 5, '455-89-4567', '1099', 3, 5, 'Dan', '2015-04-01' -- union
SET IDENTITY_INSERT [Employee].[Employee] OFF;

-- select * from [Employee].[Employee]

/*
select e.FirstName, o.Role, r.Name
from [Employee].[Employee] r, [Employee].[Role] o, [Employee].[HrRate] r
where v.RateId = r.RateId
  and v.RoleId = o.RoleId
*/

---------------------------------------
-- drop table [Employee].[Day]
-----------------------------------------
CREATE TABLE [Employee].[EmployeeAlias]
(
	[Alias]				[varchar](30)		NOT NULL UNIQUE,
	[EmployeeId]		[int]				NOT NULL,
FOREIGN KEY ([EmployeeId]) REFERENCES [Employee].[Employee] (EmployeeId)
)
GO

DECLARE	@EmployeeId_House int = 0,
		@EmployeeId_Dan int = 5;

insert [Employee].[EmployeeAlias] (Alias, EmployeeId)
select 'Dan Phillips', @EmployeeId_Dan union
select 'Joe Starr', 0 union
select 'John Hillegas', 0 union
select 'Josiah Saunders', 0 union
select 'Justin Ramos', 0 union
select 'Kaitlyn Reyes', @EmployeeId_House union
select 'Melinda Russell', 0 union
select 'PJ Ghaneian', @EmployeeId_House union
select 'Tawney Verano', @EmployeeId_House union
select 'Wayne White', 0
;

-- select * from [Employee].[EmployeeAlias];
-- select * from [Employee].[Employee];

/*
select Salesman, count(*)
from PrivateReserve.Acct.Acct
group by Salesman

select max(len(Salesman))
from PrivateReserve.Acct.Acct

select * from PrivateReserve.Acct.Acct
where Salesman = 'Wayne Whit'

*/

---------------------------------------
-- drop table [Employee].[Day] -- may be superflourious
-----------------------------------------
CREATE TABLE [Employee].[Day]
(
	[EmployeeId]		[int]				NOT NULL,
	[RoleId]			[int]				NOT NULL,
	[Dt]				[smalldatetime]		NOT NULL,
	[StartTm]			[smalldatetime]		NOT NULL,
	[EndTm]				[smalldatetime]		NULL,
	[TransferCnt]		[smallint]			NULL,
	[CloseCnt]			[smallint]			NULL
FOREIGN KEY ([EmployeeId]) REFERENCES [Employee].[Employee] (EmployeeId),
FOREIGN KEY ([Dt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([RoleId]) REFERENCES [Employee].[Role] (RoleId)
);
GO

--------------------------------------------------------------------------------
-- An employee can be/play/work as one or more roles in a day
--------------------------------------------------------------------------------
CREATE UNIQUE INDEX PK_EmployeeDay ON [Employee].[Day] ([EmployeeId], [RoleId], [Dt])
GO



--*******************************************************
-- Acct Schema -- related to all accounting functionality
--*******************************************************
CREATE Schema [Acct];
GO

-- select * from acct.acct

CREATE RULE [Acct].[Qtr]
AS
@Val like '[1-2][0-9][0-9][0-9]Q[1-4]'
GO


CREATE RULE [Acct].[Type] 
AS
@Val IN ('Liability','Asset','Equity')
GO

-- Just easier than building table to keep track of at the moment as only supporting USD
/*
CREATE RULE [Acct].[Currency] 
AS
@Val IN ('USD')
GO
*/


CREATE TYPE [Acct].[Type] FROM [varchar](9) NOT NULL
GO

CREATE TYPE [Acct].[Currency] FROM [char](3) NOT NULL
GO

CREATE TYPE [Acct].[Qtr] FROM [char](6) NOT NULL
GO


---------------------------------------
-- Bind the rules the types
---------------------------------------
sp_bindrule '[Acct].[Type]', '[Acct].[Type]';
GO

-- sp_bindrule '[Acct].[Currency]', '[Acct].[Currency]';
-- GO

sp_bindrule '[Acct].[Qtr]', '[Acct].[Qtr]';
GO

-----------------------------------------------------------
-- DROP TABLE [Acct].[Acct];
-----------------------------------------------------------
CREATE TABLE [Acct].[Currency]
(
	Currency		[Acct].[Currency]			NOT NULL,
PRIMARY KEY ([Currency])
);

INSERT [Acct].[Currency] (Currency)
SELECT 'USD';
GO

-----------------------------------------------------------
-- DROP TABLE [Acct].[Acct];
-----------------------------------------------------------
CREATE TABLE [Acct].[Acct]
(
	AcctId			[int]				NOT NULL IDENTITY (-1,1),
	ParentAcctId	[int]				NULL,
	AcctNum			[varchar](20)		NULL,
	Name			[varchar](50)		NOT NULL,
	Shares			[int]				NULL,
	AppNum			[varchar](20)		NULL,						-- probably oughta setup referncial integrity against Contract
	Type			[Acct].[Type]		NOT NULL,
	CreateDt		[smalldatetime]		NOT NULL,
	IsClosed		[Legend].[YesNo]	NOT NULL,
	ClosedDt		[smalldatetime]		NULL
PRIMARY KEY ([AcctId]),
FOREIGN KEY ([ParentAcctId]) REFERENCES [Acct].[Acct] (AcctId),
FOREIGN KEY ([CreateDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([ClosedDt]) REFERENCES [Legend].[Day] (Dt)
);

CREATE UNIQUE INDEX PK_Acct_Name ON [Acct].[Acct] (Name);

-- truncate table [Acct].[Acct];

SET IDENTITY_INSERT [Acct].[Acct] ON;

DECLARE @Day0	smalldatetime	= '2015-02-17';
DECLARE @Day1	smalldatetime	= '2015-03-15';
DECLARE @Day2	smalldatetime	= '2015-05-1';

INSERT [Acct].[Acct] ( AcctId, ParentAcctId, AcctNum, Name, Type, CreateDt, Shares, AppNum )
SELECT -1, NULL,	'A00280',		'Cash - ACH',	'Asset',	@Day1,	NULL, NULL UNION
SELECT 0, -1,		'PR',			'P Reserve',	'Asset',	@Day1,	NULL, NULL UNION

SELECT 1, NULL,		'P',			'P',			'Equity',	@Day1,	800000, NULL UNION
SELECT 2, NULL,		'CZ',			'Chainz',		'Equity',	@Day1,	100000, NULL UNION
SELECT 3, NULL,		'MZ',			'Marco',		'Equity',	@Day1,	100000, NULL UNION

SELECT 5, NULL,		'Labor',		'Employee Labor Expense',		'Liability',@Day1,	NULL, NULL UNION
SELECT 7, NULL,		'TN',			'TransNational',		'Asset',	@Day1,	NULL, NULL UNION
SELECT 8, NULL,		'OMNI',			'OmniSure - Reserve',	'Asset',	@Day1,	NULL, NULL UNION

SELECT 9, NULL,		'QR',			'Q Reserve',			'Liability',@Day1,	NULL, NULL UNION
SELECT 10, 9,		'dans',			'Dan',					'Liability',@Day1,	NULL, NULL UNION
SELECT 11, NULL,	'VOIP',			'VOIP Minutes',			'Liability',@Day1,	NULL, NULL UNION
SELECT 12, 11,		'Alcazarnet',	'Alcazarnet',			'Liability',@Day1,	NULL, NULL UNION
SELECT 13, 11,		'Interstate',	'Interstate',			'Liability',@Day1,	NULL, NULL UNION
SELECT 14, NULL,	'Internet',		'Internet - Cox',		'Liability',@Day1,	NULL, NULL UNION
SELECT 15, 9,		'Mel',			'Mel',					'Liability',@Day1,	NULL, NULL UNION
SELECT 16, 9,		'Ramos',		'Ramos',				'Liability',@Day2,	NULL, NULL UNION 

SELECT 17, 0,		'Admins',		'Admins',				'Asset',	@Day1,	NULL, NULL UNION
SELECT 18, 17,		'G00021',		'American Auto Shield',	'Asset',	@Day1,	NULL, NULL UNION

SELECT 19, 17,		'G00003',		'Royal Administration Services',	'Asset',	@Day1,	NULL, NULL UNION
SELECT 20, 17,		'',				'Sentinel',							'Asset',	@Day1,	NULL, NULL UNION
SELECT 21, 17,		'G00039',		'SunPath Ltd.',			'Asset',	@Day1,	NULL, NULL UNION
SELECT 22, 17,		'',				'Omega',				'Asset',	@Day1,	NULL, NULL UNION
SELECT 23, 17,		'G00041',		'Ensurety Inc.',		'Asset',	@Day1,	NULL, NULL UNION

SELECT 24, 0,		'CUST',			'Customer Accounts',		'Asset',	@Day1,	NULL, NULL UNION

SELECT 25, 24,		'1043-4725099',	'NANCY GUENTHER - RCW001001', 'Asset',	@Day1, NULL, '9737447054' -- outta be date finance company is paid and does thing

-- select * from Acct.Acct


-- A00280 - Auto Protection Services
-- G00003 - Royal Administration Services
-- G00021 - American Auto Shield
-- G00039 - SunPath Ltd.
-- G00041 - Ensurety Inc.


SET IDENTITY_INSERT [Acct].[Acct] OFF;

-- select * from Acct.Acct

-----------------------------------------------
--  is the one who closes the period by creating the journal entry.
-----------------------------------------------
CREATE TABLE [Acct].[Journal]
(
	[JournalId]			[int]				NOT NULL IDENTITY (1,1),
	[ParentJournalId]	[int]				NULL,
	[Dt]				[smalldatetime]		NOT NULL,
	[EmployeeId]		[int]				NOT NULL,
	[Qtr]				[Acct].[Qtr]		NOT NULL,
	[Week]				[smallint]			NOT NULL,					-- represents the week range 
PRIMARY KEY ([JournalId]),
FOREIGN KEY ([ParentJournalId]) REFERENCES [Acct].[Journal] ( JournalId ),
FOREIGN KEY ([Dt]) REFERENCES [Legend].[Day] ( Dt ),
FOREIGN KEY ([EmployeeId]) REFERENCES [Employee].[Employee] ( EmployeeId )
);

-----------------------------------------------
--
-----------------------------------------------
CREATE TABLE [Acct].[Tx]
(
	[TxId]				[int]				NOT NULL IDENTITY (1,1),
	[TxDt]				[date]				NOT NULL,
	[UsrId]				[int]				NOT NULL,
	[JournalId]			[int]				NULL,			-- when assigned to a journal entry
PRIMARY KEY ([TxId]),
FOREIGN KEY ([UsrId]) REFERENCES [Core].[Usr] ( UsrId ),
FOREIGN KEY ([JournalId]) REFERENCES [Acct].[Journal] ( JournalId )
);



-----------------------------------------------
--
-----------------------------------------------
CREATE TABLE [Acct].[Ledger]
(
	[LedgerId]			[int]				NOT NULL IDENTITY (1,1),
	[TxId]				[int]				NOT NULL,
	[AcctId]			[int]				NOT NULL,
	[Debit]				[money]				NOT NULL,
	[Credit]			[money]				NOT NULL,
	[Currency]			[Acct].[Currency]	NOT NULL,
PRIMARY KEY ([LedgerId]),
FOREIGN KEY ([TxId]) REFERENCES [Acct].[Tx] ( TxId ),
FOREIGN KEY ([AcctId]) REFERENCES [Acct].[Acct] ( AcctId ),
FOREIGN KEY ([Currency]) REFERENCES [Acct].[Currency] ( Currency ),
);
GO

-----------------------------------------------
--
-----------------------------------------------
CREATE TABLE [Acct].[LedgerChange]
(
	[DbAction]			[Legend].[DbAction]	NOT NULL,
	[LedgerId]			[int]				NOT NULL,
	[TxId]				[int]				NOT NULL,
	[Dt]				[smalldatetime]		NOT NULL,
	[AcctId]			[int]				NOT NULL,
	[Debit]				[money]				NOT NULL,
	[Credit]			[money]				NOT NULL,
	[Currency]			[Acct].[Currency]	NOT NULL,
FOREIGN KEY ([Dt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([AcctId]) REFERENCES [Acct].[Acct] ( AcctId ),
FOREIGN KEY ([Currency]) REFERENCES [Acct].[Currency] ( Currency )
);
GO

CREATE TRIGGER LedgerUpdate
ON [Acct].[Ledger]
FOR UPDATE
AS
	INSERT [Acct].[LedgerChange] (DbAction, LedgerId, TxId, Dt, AcctId, Debit, Credit, Currency)
	SELECT 'UPDATE', LedgerId, TxId, GETDATE(), AcctId, Debit, Credit, Currency
	FROM inserted;
GO

CREATE TRIGGER LedgerDelete
ON [Acct].[Ledger]
FOR DELETE
AS
	INSERT [Acct].[LedgerChange] (DbAction, LedgerId, TxId, Dt, AcctId, Debit, Credit, Currency)
	SELECT 'DELETE', LedgerId, TxId, GETDATE(), AcctId, Debit, Credit, Currency
	FROM deleted;
GO

-----------------------------------------------
--
-----------------------------------------------
CREATE TABLE [Acct].[DisbMethod]
(
	DisbMethod		varchar(15)		NOT NULL UNIQUE,
PRIMARY KEY ([DisbMethod])
);

INSERT [Acct].[DisbMethod] (DisbMethod)
SELECT 'ACH' UNION
SELECT 'Check' UNION
SELECT 'Reserve' UNION
SELECT 'Transfer';
GO

----------------------------------------------------------
-- Not yet clear why / how this is different than ledger
-- enter thou assume this keeps track of distrubutions to
-- be made that haven't been yet - which likely means that
-- some are not real and/or are uncommited / can change
----------------------------------------------------------
CREATE TABLE [Acct].[Disb]
(
	[DisbId]			[int]				NOT NULL IDENTITY (1,1),
	[DisbDt]			[smalldatetime]		NOT NULL,
	[DisbMethod]		[varchar](15)		NOT NULL,
	[AcctNum]			[varchar](20)		NOT NULL,					-- This is the account tied to the contract
	[DisbAcctNum]		[varchar](10)		NOT NULL,					-- This needs to be researched
	[DisbPayee]			[varchar](50)		NOT NULL,
	[DisbMade]			[Legend].[YesNo]	NOT NULL,					-- need to determine if / how this is used
	[PaidAmt]			[money]				NOT NULL,					
	[UnpaidAmt]			[money]				NOT NULL,
PRIMARY KEY ([DisbId]),
FOREIGN KEY ([DisbMethod]) REFERENCES [Acct].[DisbMethod] ( DisbMethod )
);
GO

--***************************************
--
--***************************************
CREATE Schema [Car];
GO

CREATE TYPE [Car].[VIN] FROM [char](17) NOT NULL
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[Year]
(
	Year		[Legend].[Year]		NOT NULL UNIQUE
);
GO

INSERT [Car].[Year] (Year)
SELECT '2000' UNION
SELECT '2001' UNION
SELECT '2002' UNION
SELECT '2003' UNION
SELECT '2004' UNION
SELECT '2005' UNION
SELECT '2006' UNION
SELECT '2007' UNION
SELECT '2008' UNION
SELECT '2009' UNION
SELECT '2010' UNION
SELECT '2011' UNION
SELECT '2012' UNION
SELECT '2013' UNION
SELECT '2014' UNION
SELECT '2015' UNION
SELECT '2016'
;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[StateExclude]
(
	[State]	[dbo].[State]	NOT NULL UNIQUE
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
)
 GO

-- put in the current states we're excluding
INSERT [Car].[StateExclude] (State)
SELECT State
FROM [PrivateReserve].[Legend].[ExcludeState]
GO


---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[Make]
(
	[Make]								[varchar](20)	NOT NULL,
	[FactoryWarrantyBasic_Yr]			[tinyint]		NULL,
	[FactoryWarrantyBasic_Miles]		[int]			NULL,
	[FactoryWarrantyDrivetrain_Yr]		[tinyint]		NULL,
	[FactoryWarrantyDrivetrain_Miles]	[int]			NULL,
PRIMARY KEY ([Make])
) ON [PRIMARY]
GO

INSERT [Car].[Make] ( Make, FactoryWarrantyBasic_Yr, FactoryWarrantyBasic_Miles, FactoryWarrantyDrivetrain_Yr, FactoryWarrantyDrivetrain_Miles )
SELECT UPPER(Make), FactoryWarrantyBasic_Yr, FactoryWarrantyBasic_Miles, FactoryWarrantyDrivetrain_Yr, FactoryWarrantyDrivetrain_Miles
FROM [PrivateReserve].[Car].[Make]
GO

/*
delete [PrivateReserve].[Car].[Make] where Make = 'INFINITY'
delete [Car].[Make] where Make = 'INFINITY'

-- update Car.Make set Make = upper(Make)
select * from Car.Make
where Make not in (select Make from car.MakeExclude)

select * from Car.Year
select * from Car.StateExclude
select * from DNC.AreaCd

*/


---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[MakeErr]
(
	[MakeErr]		[varchar](30) NOT NULL UNIQUE,
	[Make]			[varchar](20) NOT NULL,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
) ON [PRIMARY]
GO

INSERT [Car].[MakeErr] ( MakeErr, Make )
SELECT MakeErr, Make
FROM [PrivateReserve].[Car].[MakeErr]
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[MakeInclude]
(
	Make		[varchar](20)	NOT NULL UNIQUE,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
)
GO

DECLARE @MakeExclude TABLE ( Make varchar(20) NOT NULL );

-- INSERT  [Car].[MakeExclude] (Make)
INSERT @MakeExclude (Make)
select 'ASTON MARTIN' UNION
select 'ALFA ROMEO' UNION
select 'BENTLEY' UNION
select 'RANGE ROVER' UNION
select 'GEM' UNION
select 'FERRARI' UNION
select 'HONDA MOTORCYCLE' UNION
select 'Harley-Davidson' UNION
select 'LAMBORGHINI' UNION
select 'LOTUS' UNION
select 'Sterling' UNION
select 'MASERATI' UNION
select 'MAYBACH' UNION
select 'ROLLS-ROYCE' UNION
select 'TESLA' UNION
select 'SMART' UNION
select 'FISKER' UNION
select 'GEM';

INSERT [Car].[MakeInclude] (Make)
SELECT UPPER(Make) from Car.Make WHERE Make NOT IN (SELECT Make FROM @MakeExclude);
GO

--------------------------------------------------------
--  Anything not included is automatically excluded
--------------------------------------------------------
CREATE VIEW [Car].[MakeExclude]
AS
	SELECT Make FROM [Car].[Make] WHERE Make NOT IN (SELECT Make FROM [Car].[MakeInclude]);
GO

-- select * from [Car].[MakeExclude]
-- select * from [Car].[MakeInclude]

--------------------------------------------------------
-- What are all the valid Makes
--------------------------------------------------------
/*	-- test
select *
from [Car].[Make]
where Make not in (select Make from [Car].[MakeExclude])
  and Make not in (select MakeErr from [Car].[MakeErr])
*/

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[ModelType]
(
	[ModelType]		[varchar](20)	NOT NULL,
	[Definition]	[varchar](255)	NULL,
PRIMARY KEY (ModelType) 
);

INSERT [Car].[ModelType] (ModelType, Definition)
select 'Car', 'Default' UNION
select 'CUV', 'Crossover Utility Vehicle' UNION
select 'MPV', 'Multi-Purpose Vehicle' UNION			-- minivan
select 'Sedan', '' UNION
select 'Sport', '' UNION
select 'Sport Sedan', '' UNION
select 'SUV', 'Sport Utility Vehicle' UNION
select 'Truck', '' UNION
select 'Van', ''

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[ModelLevel]
(
	[ModelLevel]	[varchar](20)	NOT NULL,
PRIMARY KEY (ModelLevel) 
);

insert [Car].[ModelLevel] (ModelLevel)
select 'Unknown' union
select 'Entry' union
select 'Luxury' union
select 'Up Scale'

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[MakeModel]
(
	[Make]			[varchar](20)	NOT NULL,
	[Model]			[varchar](30)	NOT NULL,
	[ClassSeries]	[varchar](30)	NULL,
	[ModelType]		[varchar](20)	NOT NULL,
	[ModelLevel]	[varchar](20)	NOT NULL,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make),
FOREIGN KEY ([ModelType]) REFERENCES [Car].[ModelType](ModelType),
FOREIGN KEY ([ModelLevel]) REFERENCES [Car].[ModelLevel](ModelLevel)
) ON [PRIMARY]
GO

CREATE UNIQUE INDEX PK_MakeModel ON [Car].[MakeModel] ([Make], [Model])
GO

INSERT [Car].[MakeModel] ( Make, Model, ModelType, ModelLevel )
SELECT Make, Model, 'Car', 'Unknown'
FROM [QSM].[CarData].[MakeModel]
GO

UPDATE [Car].[MakeModel] SET ClassSeries = o.ClassSeries, ModelType = o.Type
FROM [Car].[MakeModel] m, [QSM].[CarData].[MakeModelOfficial] o
WHERE m.Make = o.Make
  AND m.Model = o.Model;

UPDATE [Car].[MakeModel] SET ModelLevel = o.Level
FROM [Car].[MakeModel] m, [QSM].[CarData].[MakeModelOfficial] o
WHERE m.Make = o.Make
  AND m.Model = o.Model
  AND o.Level IS NOT NULL;

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[ModelErr]
(
	[ModelErr]	[varchar](30) NOT NULL,
	[Make]		[varchar](20) NOT NULL,
	[Model]		[varchar](30) NOT NULL,
FOREIGN KEY ([Make]) REFERENCES [Car].[Make](Make)
) ON [PRIMARY]
GO

INSERT [Car].[ModelErr] ( ModelErr, Make, Model )
SELECT ModelErr, Make, Model
FROM [QSM].[CarData].[ModelErr]
GO

--------------------------------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE [Car].[Car]
(
	[VIN]			[Car].[VIN]			NOT NULL,
	[Make]			[varchar](20)		NOT NULL,
	[Model]			[varchar](30)		NOT NULL,
	[Year]			[Legend].[Year]		NOT NULL,
	[IsHybrid]		[Legend].[YesNo]	NOT NULL,
	[Phone]			[Legend].[Phone]	NULL,
	[FirstName]		[varchar](20)		NULL,
	[LastName]		[varchar](30)		NULL,
	[Address]		[varchar](50)		NULL,
	[Address2]		[varchar](50)		NULL,
	[City]			[varchar](30)		NULL,
	[State]			[dbo].[State]		NOT NULL,
	[Zip]			[varchar](10)		NULL,
	[Odom]			[varchar](20)		NULL,
	[Wireless]		[Legend].[YesNo]	NOT NULL,
	[AddDt]			[smalldatetime]		NOT NULL,
	[Exclude]		[Legend].[YesNo]	NOT NULL,
	[AnswerMachine]	[Legend].[YesNo]	NOT NULL,

PRIMARY KEY ([VIN]),
FOREIGN KEY ([Make]) REFERENCES [Car].[Make] ( Make ),
FOREIGN KEY ([Year]) REFERENCES [Car].[Year] ( Year ),
FOREIGN KEY ([State]) REFERENCES [Legend].[State] ( State )
);
GO

/*

select count(*) from [Car].[Car]

select Wireless, count(*)
from [Car].[Car]
--where Exclude = 'N'
group by Wireless

select * from car.year

select Make, count(*)
from [QSM].[CarData].[Car]
where Make not in (select Make from [Car].[Make])
group by Make
*/

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [Car].[Car] (VIN, Make, Model, Year, IsHybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address, Address2, City, State, Zip, Odom, AddDt)
	select VIN, Make, Model, Year, Hybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address1, Address2, City, State, Zip, Odom, AddDt
	from [QSM].[CarData].[Car]
	where Make in (SELECT [Make] FROM [PRG].[Car].[Make])	-- necessary
	  and Year in (SELECT Year FROM [PRG].[Car].[Year])
	  and State in (SELECT State FROM [PRG].[Legend].[State])
-- 	  and Exclude = 'N'
	  and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	  -- Model in (SELECT Model FROM [QSM].[CarData].[Car] group by Model having count(*) > 5);  -- unncessary

	INSERT [Car].[Car] (VIN, Make, Model, Year, IsHybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address, Address2, City, State, Zip, AddDt)
	select VIN, Make, Model, Year, Hybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address1, Address2, City, State, Zip, AddDt
	from [QSM].[CarData].[Car]
	where Model in (SELECT Model FROM [QSM].[CarData].[Car] group by Model having count(*) > 5)
	  and Make in (SELECT [Make] FROM [PRG].[Car].[Make])
	  and Year in (SELECT Year FROM [PRG].[Car].[Year])
	  and State in (SELECT State FROM [PRG].[Legend].[State])
-- 	  and Exclude = 'N'
	  and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	  and vin in ('1FMEU75847UB32730','19UUA8F20BA000150')
	  and vin not in (select Vin from [PRG].[Car].[Car]);


	INSERT [Car].[Car] (VIN, Make, Model, Year, IsHybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address, Address2, City, State, Zip, AddDt)
	select VIN, Make, Model, Year, Hybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address1, Address2, City, State, Zip, AddDt
	from [QSM].[CarData].[Car]
	where Model in (SELECT Model FROM [QSM].[CarData].[Car] group by Model having count(*) > 5)
	  and Make in (SELECT [Make] FROM [PRG].[Car].[Make])
	  and Year in (SELECT Year FROM [PRG].[Car].[Year])
	  and State in (SELECT State FROM [PRG].[Legend].[State])
-- 	  and Exclude = 'N'
	  and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	  and vin in (select Vin from [PrivateReserve].[Acct].[Acct])
	  and vin not in (select Vin from [PRG].[Car].[Car]);

	-- wrong but just to get the thing going
	update [PrivateReserve].[Acct].[Acct] set State = 'CA' where State IS NULL;

	update [PrivateReserve].[Acct].[Acct] set Phone2 = substring(Phone,1,3) + substring(Phone,5,3) + substring(Phone,9,4)
	where Phone2 LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]';

	INSERT [Car].[Car] (VIN, Make, Model, Year, IsHybrid, Phone, Wireless, Exclude, AnswerMachine, FirstName, LastName, Address, Address2, City, State, Zip, AddDt)
	select VIN, Make, Model, Year, 'N' Hybrid, Phone2, 'N' Wireless, 'N' Exclude, 'N' AnswerMachine, FirstName, LastName, Address, '' Address2, City, State, Zip,
	cast(floor(cast(GETDATE() as float)) as smalldatetime) AddDt
	from [PrivateReserve].[Acct].[Acct]
	where vin not in (select Vin from [Car].[Car]);
	
/*	
	where Model in (SELECT Model FROM [QSM].[CarData].[Car] group by Model having count(*) > 5)
	  and Make in (SELECT [Make] FROM [PRG].[Car].[Make])
	  and Year in (SELECT Year FROM [PRG].[Car].[Year])
	  and State in (SELECT State FROM [PRG].[Legend].[State])
-- 	  and Exclude = 'N'
	  and Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	  and vin in (select Vin from [PrivateReserve].[Acct].[Acct])
	  and vin not in (select Vin from [PRG].[Car].[Car]);
*/

-- likely need to alter the Exclude flag 
--	  and Make = 'KIA' -- test 
END
GO

--------------------------------------------------------------------------------------------------------------------
--  This table is only to be used to put data into so that it can be extracted in the correct format to be loaded
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE [Car].[GoForte_Extract]
(
	[Listcode]		[varchar](20)		NOT NULL,
	[Appnumber]		[char](10)			NOT NULL	UNIQUE,		-- phone number
	[Last]			[varchar](30)		NULL,
	[First]			[varchar](30)		NULL,
	[Middle]		[char](1)			NULL,
	[Address]		[varchar](50)		NULL,
	[City]			[varchar](30)		NULL,
	[State]			[dbo].[State]		NOT NULL,
	[Zip]			[char](5)			NULL,
	[Phone]			[Legend].[Phone]	NOT NULL,
	[VIN]			[Car].[Vin]			NOT NULL,
	[Make]			[varchar](20)		NOT NULL,
	[Model]			[varchar](30)		NOT NULL,
	[Year]			[Legend].[Year]		NOT NULL,
	[Odom]			[varchar](10)		NULL,
FOREIGN KEY ([VIN]) REFERENCES [Car].[Car](VIN),
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
) ON [PRIMARY]
GO

-------------------------------------------------------
-- drop table [Car].[ContractSale];
-------------------------------------------------------
CREATE TABLE [Car].[ContractSale]
(
	[Vin]			[Car].[VIN]			NOT NULL UNIQUE,
	[Make]			varchar(20)			NOT NULL,
	[Model]			varchar(30)			NOT NULL,
	[Year]			char(4)				NOT NULL,
	[State]			[dbo].[State]		NULL
);

-- alter table [Car].[ContractSale] add State [dbo].[State]		NULL


/*
select c.Vin, c.State
FROM QSM.CarData.Car c, [Car].[ContractSale] s
where c.Vin = s.Vin
  and c.State not in (select State from Legend.State)
*/

-- select * from Legend.State


INSERT [Car].[ContractSale] ( Vin, Make, Model, Year)
SELECT DISTINCT Vin, UPPER(Make), Model, Year
FROM [QSM].[CarData].[SaleCar]
WHERE Vin <> '' ;

INSERT [Car].[ContractSale] ( Vin, Make, Model, Year)
select Vin, Make, Model, Year
from [PrivateReserve].[Acct].[Acct]
where Vin not in (select Vin from [Car].[ContractSale])
  and Vin <> ''
  and Vin IS NOT NULL;
GO

update [Car].[ContractSale] set State = c.State
FROM QSM.CarData.Car c, [Car].[ContractSale] s
where c.Vin = s.Vin
  and c.State in (select State from Legend.State)

update [Car].[ContractSale] set Make = 'MERCEDES-BENZ' where Make = 'MERCEDES BENZ';
GO

/*
select State, count(*)
from [Car].[ContractSale]
group by State
order by count(*) desc;
*/

/*
select Make, Model, count(*)
from [Car].[ContractSale]
-- where Make not in (select Make from Car.Make)
group by Make, Model;
*/


--***************************************
--
--***************************************
CREATE Schema [Call];
GO

CREATE TABLE [Call].[Disp]
(
	DispCd		varchar(6)				NOT NULL	UNIQUE,
	Definition	varchar(30)				NOT NULL,
	SaysHello	[Legend].[YesNo]		NOT NULL
PRIMARY KEY (DispCd)
)
GO

INSERT [Call].[Disp] (DispCd, Definition, SaysHello)
SELECT 'NEW','New Lead', 'N' UNION
SELECT 'QUEUE','Lead To Be Called', 'N' UNION
SELECT 'INCALL','Lead Being Called', 'N' UNION
SELECT 'DROP','Agent Not Available', 'N' UNION
SELECT 'XDROP','Agent Not Available IN', 'N' UNION
SELECT 'NA','No Answer AutoDial', 'N' UNION
SELECT 'CALLBK','Call Back', 'Y' UNION
SELECT 'CBHOLD','Call Back Hold', 'Y' UNION
SELECT 'AA','Answering Machine Auto', 'N' UNION
SELECT 'AM','Answering Machine SentToMesg', 'N' UNION
SELECT 'AL','Answering Machine Msg Played', 'N' UNION
SELECT 'AFAX','Fax Machine Auto', 'N' UNION
SELECT 'AB','Busy Auto', 'N' UNION
SELECT 'B','Busy', 'N' UNION
SELECT 'DC','Disconnected Number', 'N' UNION
SELECT 'ADC','Disconnected Number Auto', 'N' UNION
SELECT 'DNC','DO NOT CALL', 'Y' UNION
SELECT 'DNCL','DO NOT CALL Hopper Sys Match', 'N' UNION
SELECT 'DNCC','DO NOT CALL Hopper Camp Match', 'N' UNION
SELECT 'N','No Answer', 'N' UNION
SELECT 'NI','Not Interested', 'Y' UNION
SELECT 'NP','No Pitch No Price', 'N' UNION
SELECT 'PU','Call Picked Up', 'N' UNION
SELECT 'PM','Played Message', 'N' UNION
SELECT 'XFER','Call Transferred', 'Y' UNION
SELECT 'ERI','Agent Error', 'N' UNION
SELECT 'SVYEXT','Survey sent to Extension', 'N' UNION
SELECT 'SVYVM','Survey sent to Voicemail', 'N' UNION
SELECT 'SVYHU','Survey Hungup', 'N' UNION
SELECT 'SVYREC','Survey sent to Record', 'N' UNION
SELECT 'QVMAIL','Queue Abandon Voicemail Left', 'N' UNION
SELECT 'RQXFER','Re-Queue', 'N' UNION
SELECT 'TIMEOT','Inbound Queue Timeout Drop', 'N' UNION
SELECT 'AFTHRS','Inbound After Hours Drop', 'N' UNION
SELECT 'NANQUE','Inbound No Agent No Queue Drop', 'N' UNION
SELECT 'PDROP','Outbound Pre-Routing Drop', 'N' UNION
SELECT 'IVRXFR','Outbound drop to Call Menu', 'N' UNION
SELECT 'SVYCLM','Survey sent to Call Menu', 'N' UNION
SELECT 'MLINAT','Multi-Lead auto-alt set inactv', 'N' UNION
SELECT 'MAXCAL','Inbound Max Calls Drop', 'N' UNION
SELECT 'LRERR','Outbound Local Channel Res Err', 'N' UNION
SELECT 'QCFAIL','QC_FAIL_CALLBK', 'N' UNION
SELECT 'ADCT','Disconnected Number Temporary', 'N' UNION
SELECT 'LSMERG','Agent lead search old lead mrg', 'N' UNION
SELECT 'NOC','', 'N' UNION
SELECT 'WN','Wrong Number', 'Y'
;
GO


--***************************************
--
--***************************************
CREATE Schema [DNC];
GO

CREATE TABLE [DNC].[State]
(
	[State]		[dbo].[State]	NOT NULL	UNIQUE,
FOREIGN KEY ([State]) REFERENCES [Legend].[State](State)
);
GO

INSERT [DNC].[State] (State)
SELECT State FROM [PrivateReserve].[DNC].[State]
WHERE State IN(select State from [Legend].[State]);
GO

INSERT [DNC].[State] (State)
select 'XX'

select * from Legend.State

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[AreaCd]
(
	[AreaCd]	[Legend].[AreaCd] NOT NULL	UNIQUE,
FOREIGN KEY ([AreaCd]) REFERENCES [Legend].[AreaCdState](AreaCd)
) ON [PRIMARY]
 GO

------------------------------------------
-- move area codes we already purchased
------------------------------------------
INSERT [DNC].[AreaCd] (AreaCd)
SELECT AreaCd
FROM [PrivateReserve].[Dnc].[AreaCd]
 GO

/*
SELECT AreaCd
FROM [PrivateReserve].[Dnc].[AreaCd]
where areacd not in (select AreaCd from [Legend].[AreaCdState])
*/
/*
select State, count(*)
from qsm.CarData.Car
where Wireless = 'N'
  and substring(Phone,1,3) = '930'
group by State
order by count(*) desc;
*/

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[DNC]
(
	[Phone]		[Legend].[Phone]	NOT NULL UNIQUE,
	[DispCd]	[varchar](6)		NOT NULL,
	[CallTm]	[datetime]			NULL,
FOREIGN KEY ([DispCd]) REFERENCES [Call].[Disp](DispCd)
) ON [PRIMARY];
 GO

------------------------------------------
-- move some data into here to get started
------------------------------------------
DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [DNC].[DNC] (Phone, DispCd, CallTm)
	SELECT Phone, DispCd, CallTm
	FROM [PrivateReserve].[Dnc].[Dnc];

	-- Unsure why this is here - do some investigation as think depreciated
	INSERT [DNC].[DNC] (Phone, DispCd, CallTm)
	SELECT DISTINCT Phone, 'DNC', GETDATE()
	FROM [PrivateReserve].[CarData].[Dnc_Preexisting]
	WHERE Phone NOT IN (SELECT Phone FROM [DNC].[DNC])
	  AND Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]';
END
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[DNC_Log]
(
	[Dt]		[smalldatetime] NOT NULL,
	[Cnt]		[int] NOT NULL,
	[Cnt_DNC]	[int] NOT NULL,
	[Cnt_NI]	[int] NOT NULL,
	[Cnt_WN]	[int] NOT NULL
) ON [PRIMARY];
GO

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [DNC].[DNC_Log] (Dt, Cnt, Cnt_DNC, Cnt_NI, Cnt_WN)
	SELECT Dt, Cnt, Cnt_DNC, Cnt_NI, Cnt_WN
	FROM [PrivateReserve].[DNC].[dnc_log] order by Dt desc
END

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[WirelessBlocks]
(
	[NPA] [char](3) NOT NULL,
	[NXX] [char](3) NOT NULL,
	[X] [char](1) NOT NULL,
	[CATEGORY] [varchar](10) NOT NULL,
	[PhoneBegin] [char](7) NULL
) ON [PRIMARY]
 GO



---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[WirelessToLandline]
(
	[Phone]		[Legend].[Phone] NOT NULL	UNIQUE
) ON [PRIMARY]
GO


---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[LandlineToWireless]
(
	[Phone]		[Legend].[Phone] NOT NULL	UNIQUE
) ON [PRIMARY]
 GO

DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	INSERT [DNC].[WirelessBlocks] ( NPA, NXX, X, CATEGORY, PhoneBegin )
	SELECT  NPA, NXX, X, CATEGORY, PhoneBegin
	FROM [PrivateReserve].[DNC].[WirelessBlocks];

	INSERT [DNC].[WirelessToLandline] (Phone)
	SELECT Phone
	FROM [PrivateReserve].[DNC].[WirelessToLandline];

	INSERT [DNC].[LandlineToWireless] (Phone)
	SELECT Phone
	FROM [PrivateReserve].[DNC].[LandlineToWireless];
END
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [DNC].[Wireless_LoadLog]
(
	[Dt]					[smalldatetime] NOT NULL UNIQUE,
	[WirelessBlockCnt]		[int]			NOT NULL,
	[WirelessToLandlineCnt] [int]			NOT NULL,
	[LandlineToWirelessCnt] [int]			NOT NULL,
FOREIGN KEY ([Dt]) REFERENCES [Legend].[Day] (Dt)
) ON [PRIMARY]
GO

INSERT [Dnc].[Wireless_LoadLog] (Dt, WirelessBlockCnt, WirelessToLandlineCnt, LandlineToWirelessCnt )
SELECT LoadDt, WirelessCnt, WirelessToLandlineCnt, LandlineToWirelessCnt
FROM [PrivateReserve].[Dnc].[Wireless_LoadLog];
GO


--***************************************
--
--***************************************
CREATE Schema [Contract];
GO

---------------------------------------
--  at least three differenct types of companies involved: Administrators, Finnance and Merchant
-----------------------------------------
CREATE TABLE [Contract].[Admin]
(
-- 	[AdminId]			[int]				NOT NULL	IDENTITY(1,1),
	[Admin]				[varchar](10)		NOT NULL	UNIQUE,
	[Name]				[varchar](30)		NOT NULL,
	[AcctId]			[int]				NOT NULL
PRIMARY KEY ([Admin]),
FOREIGN KEY ([AcctId]) REFERENCES [Acct].[Acct] ( AcctId )
);
GO

INSERT [Contract].[Admin] (Admin, Name, AcctId )
SELECT 'AASB', 'American Auto Shield', 18 UNION
SELECT 'AASBF', 'American Auto Shield', 18 UNION		-- not sure if its really the same admin as AASB
SELECT 'ROYSHD', 'Royal Shield', 19 UNION
SELECT 'ROYSEN', 'Sentinel', 20  UNION
SELECT 'SUNPATH', 'SunPath', 21 UNION
SELECT 'OMEGA', 'Omega', 22
;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Contract].[Finance]
(
	[FinanceId]			[int]				NOT NULL	IDENTITY(1,1),
	[Name]				[varchar](30)		NOT NULL	UNIQUE,
	[AcctId]			[int]				NOT NULL,
	[DefaultProfit]		[money]				NOT NULL,	-- this is just here as default to assist when entering a contract
PRIMARY KEY ([FinanceId]),
FOREIGN KEY ([AcctId]) REFERENCES [Acct].[Acct] ( AcctId )
);
GO

SET IDENTITY_INSERT [Contract].[Finance] ON;
INSERT [Contract].[Finance] (FinanceId, Name, AcctId, DefaultProfit)
SELECT 1, 'OmniSure', 8, 1500;
SET IDENTITY_INSERT [Contract].[Finance] OFF;

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Contract].[NumPayment]
(
	[NumPayment]		[smallint]			NOT NULL	UNIQUE,
PRIMARY KEY (NumPayment)
);
GO

INSERT [Contract].[NumPayment] (NumPayment)
SELECT 0 UNION
SELECT 3 UNION
SELECT 6 UNION
SELECT 9 UNION
SELECT 12 UNION
SELECT 15 UNION
SELECT 18 UNION
SELECT 24;
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Contract].[FinanceNumPayment]
(
	[FinanceId]		[int]			NOT NULL,
	[NumPayment]	[smallint]		NOT NULL,
	[AdvanceRate]	[numeric](3,2)	NOT NULL,
	[DiscountFee]	[numeric](4,4)	NOT NULL,
	[MinFee]		money			NOT NULL,
FOREIGN KEY ([FinanceId]) REFERENCES [Contract].[Finance] (FinanceId),
FOREIGN KEY ([NumPayment]) REFERENCES [Contract].[NumPayment] (NumPayment)
);

CREATE UNIQUE INDEX PK_Contract_FinanceNumPayment ON [Contract].[FinanceNumPayment] (FinanceId, NumPayment);

INSERT [Contract].[FinanceNumPayment] (FinanceId, NumPayment, AdvanceRate, DiscountFee, MinFee)
SELECT 1, 6, .75, .06, 180 UNION
SELECT 1, 9, .75, .06, 180 UNION
SELECT 1, 12, .75, .06, 180 UNION
SELECT 1, 15, .70, .07, 190 UNION
SELECT 1, 18, .65, .09, 200 UNION
SELECT 1, 24, .60, .1275, 250;

-- select * from [Contract].[FinanceTerm]

---------------------------------------
-- drop table [Contract].[PayPlan]
-----------------------------------------
CREATE TABLE [Contract].[PayPlan]
(
	[PayPlanId]		[int]			NOT NULL	IDENTITY(1,1),
	[Name]			varchar(30)		NOT NULL	UNIQUE,
	[RoleId]		[int]			NOT NULL
PRIMARY KEY (PayPlanId),
FOREIGN KEY ([RoleId]) REFERENCES [Employee].[Role] (RoleId)
);
GO

DECLARE @RoleId_Closer int = (SELECT RoleId FROM [Employee].[Role] WHERE Role = 'Closer');
SET IDENTITY_INSERT [Contract].[PayPlan] ON;
INSERT [Contract].[PayPlan] (PayPlanId, Name, RoleId)
SELECT 1, 'Bizkit', @RoleId_Closer ;
SET IDENTITY_INSERT [Contract].[PayPlan] OFF;
GO

/*
CREATE TABLE [Acct].[Acct]
(
	[AppNum]				[char](10)			NOT NULL,
	[AcctNum]				[char](15)			NULL,
	[ContractNum]			[varchar](10)		NULL,
	[SaleDt]				[smalldatetime]		NULL,
	[RateDt]				[smalldatetime]		NULL,
	[Vin]					[char](17)			NULL,
	[Make]					[varchar](20)		NULL,
	[Model]					[varchar](30)		NULL,
	[Year]					[char](4)			NULL,
	[NewOrUsed]				[char](1)			NULL,
	[FirstName]				[varchar](20)		NULL,
	[LastName]				[varchar](30)		NULL,
	[InsuredName]			[varchar](50)		NULL,
	[Address]				[varchar](50)		NULL,
	[City]					[varchar](30)		NULL,
	[State]					[char](2)			NULL,
	[Zip]					[varchar](10)		NULL,
	[Phone]					[varchar](10)		NULL,
	[Phone2]				[varchar](10)		NULL,
	[Email]					[varchar](50)		NULL,
	[Salesman]				[varchar](10)		NULL,
	[Admin]					[varchar](10)		NULL,
	[CoverageType]			[varchar](10)		NULL,
	[Coverage]				[varchar](10)		NULL,
	[TermMonth]				[smallint]			NULL,
	[TermMiles]				[int]				NULL,
	[Deduct]				[money]				NULL,
	[Class]					[varchar](10)		NULL,
	[PurchOdom]				[int]				NULL,
	[ExpOdom]				[int]				NULL,
	[TotalPremiumAmt]		[money]				NULL,
	[SalesTaxAmt]			[money]				NULL,
	[PayPlan]				[varchar](10)		NULL,
	[FinanceFeeAmt]			[money]				NULL,
	[PaymentAmt]			[money]				NULL,
	[NumPayments]			[smallint]			NULL,
	[DownPaymentAmt]		[money]				NULL,
	[FinanceCompany]		[varchar](10)		NULL,
	[FinanceNum]			[varchar](10)		NULL,
	[FinancedAmt]			[money]				NULL,
	[FirstBillDt]			[smalldatetime]		NULL,
	[GrossProfitAmt]		[money]				NULL,
	[NetProfitAmt]			[money]				NULL,
	[ReleaseDt]				[smalldatetime]		NULL,
	[ContractCostAmt]		[money]				NULL,
	[DiscountAmt]			[money]				NULL,
	[DisbursementAmt]		[money]				NULL,
	[FundingToEntityAmt]	[money]				NULL,
	[ReserveAmt]			[money]				NULL,
	[EffectiveDt]			[smalldatetime]		NULL,
	[ExpireDt]				[smalldatetime]		NULL,
	[Cancelled]				[char](1)			NULL,
	[CancelDt]				[smalldatetime]		NULL,
	[InstallmentsMade]		[smallint]			NULL,
	[LastPaymentRcvdDt]		[smalldatetime]		NULL
) ON [PRIMARY]
-- GO
*/

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Car].[Contract]
(
	[ContractId]			[int]				NOT NULL	IDENTITY(1,1),
	[AppNum]				[varchar](20)		NOT NULL,	-- likely oughta be unique
	[ContractNum]			[varchar](20)		NULL,	-- value that isn't always there
	[EmployeeId_Open]		[int]				NULL,
	[EmployeeId_Sale]		[int]				NULL,
	[EmployeeId_TO]		[int]				NULL,
	[EmployeeId_TA]		[int]				NULL,
	[InsuredName]			[varchar](50)		NULL,
	[FirstName]				[varchar](30)		NULL,
	[LastName]				[varchar](30)		NULL,
	[Address]				[varchar](50)		NULL,
	[City]					[varchar](30)		NULL,
	[State]					[dbo].[State]		NULL,
	[Zip]					[varchar](10)		NULL,
	[Phone]					[Legend].[Phone]	NULL,
	[Phone2]				[Legend].[Phone]	NULL,
	[Email]					[varchar](50)		NULL,
	[SaleDt]				[smalldatetime]		NULL,
	[RateDt]				[smalldatetime]		NULL,
	[Vin]					[Car].[VIN]			NULL,
	[Make]					[varchar](20)		NULL,
	[Model]					[varchar](30)		NULL,
	[Year]					[Legend].[Year]		NULL,
	[NewOrUsed]				[char](1)			NULL,
	[Coverage]				[varchar](20)		NULL,		-- likely shorter than this as appears to be a code
	[Term]					[varchar](10)		NULL,
	[TermMonth]				[smallint]			NULL,		-- likely to be shorter as also a code like 72/70
	[TermMiles]				[int]				NULL,
	[DeductAmt]				[money]				NULL,
	[Class]					[varchar](10)		NULL,		-- also some kind of code
	[Admin]					[varchar](10)		NULL,	-- SunPath
	[CoverageType]			[varchar](30)		NULL,	-- like some set of values need to discover ('Exclusion')
	[FinanceId]				[int]				NULL,	-- omnisure
	[PurchOdom]				[int]				NULL,
	[ExpOdom]				[int]				NULL,	-- figure this has to be a value cannot be nothing.
	[ExpireDt]				[smalldatetime]		NULL,
	[TotalPremiumAmt]		[money]				NULL,
	[SalesTaxAmt]			[money]				NULL,
	[PayPlan]				[varchar](10)		NULL,
	[FinanceFeeAmt]			[money]				NULL,
	[PaymentAmt]			[money]				NULL,
	[NumPayment]			[smallint]			NULL,
	[DownPaymentAmt]		[money]				NULL,
	[FinanceCompany]		[varchar](10)		NULL,
	[FinanceNum]			[varchar](10)		NULL,
	[FinancedAmt]			[money]				NULL,
	[FirstBillDt]			[smalldatetime]		NULL,
	[ContractCostAmt]		[money]				NULL,
	[DiscountAmt]			[money]				NULL,
	[DisbursementAmt]		[money]				NULL,
	[FundingToEntityAmt]	[money]				NULL,
	[ReserveAmt]			[money]				NULL,
	[EffectiveDt]			[smalldatetime]		NULL,
	[InstallmentsMade]		[smallint]			NULL,
	[LastPaymentRcvdDt]		[smalldatetime]		NULL,
	[RetailPlusPlusAmt]		[money]				NULL,
	[RetailAmt]				[money]				NULL,
	[CustomerCostAmt]		[money]				NULL,
	[IsPaidInFull]			[Legend].[YesNo]	NOT NULL,
	[PayPlanType]			[varchar](30)		NULL,	-- Finnance or pay in full ????
	[GrossProfitAmt]		[money]				NULL,
	[NetProfitAmt]			[money]				NULL,
	[ReleaseDt]				[smalldatetime]		NULL,
	[IsCancelled]			[Legend].[YesNo]	NOT NULL,
	[CancelDt]				[smalldatetime]		NULL,
	[CancelReturnAmt]		[money]				NULL,
PRIMARY KEY ([ContractId]),
FOREIGN KEY ([Admin]) REFERENCES [Contract].[Admin] (Admin),
FOREIGN KEY ([EmployeeId_Open]) REFERENCES [Employee].[Employee] (EmployeeId),
FOREIGN KEY ([EmployeeId_Sale]) REFERENCES [Employee].[Employee] (EmployeeId),
FOREIGN KEY ([EmployeeId_TO]) REFERENCES [Employee].[Employee] (EmployeeId),
FOREIGN KEY ([EmployeeId_TA]) REFERENCES [Employee].[Employee] (EmployeeId),
-- FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] (PayPlanId),
FOREIGN KEY ([Vin]) REFERENCES [Car].[Car] (Vin),
FOREIGN KEY ([SaleDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([RateDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([FirstBillDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([CancelDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([NumPayment]) REFERENCES [Contract].[NumPayment] (NumPayment)
);
GO

-------------------------------------------------------------------------------------------
--  Move the data loaded into [PrivateReserve].[Acct].[Acct]
-------------------------------------------------------------------------------------------
DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN

	DECLARE @AppNum				varchar(10),
			@AcctNum			varchar(15),
			@ContractNum		varchar(10),
			@SaleDt				smalldatetime,
			@RateDt				smalldatetime,
			@Vin				varchar(17),
			@Make				varchar(20),
			@Model				varchar(30),
			@Year				char(4),
			@NewOrUsed			char(1),
			@FirstName			varchar(20),
			@LastName			varchar(30),
			@InsuredName		varchar(50),
			@Address			varchar(50),
			@City				varchar(30),
			@State				char(2),
			@Zip				varchar(10),
			@Phone				char(10),
			@Phone2				char(10),
			@Email				varchar(50),
			@Salesman			varchar(10),
			@Admin				varchar(10),
			@CoverageType		varchar(10),
			@Coverage			varchar(10),
			@TermMonth			smallint,
			@TermMiles			int,
			@DeductAmt			money,
			@Class				varchar(10),
			@PurchOdom			int,
			@ExpOdom			int,
			@ExpireDt			smalldatetime,
			@TotalPremiumAmt	money,
			@SalesTaxAmt		money,
			@PayPlan			varchar(10),
			@FinanceFeeAmt		money,
			@PaymentAmt			money,
			@NumPayments		smallint,
			@DownPaymentAmt		money,
			@FinanceCompany		varchar(10),
			@FinanceNum			varchar(10),
			@FinancedAmt		money,
			@FirstBillDt		smalldatetime,
			@GrossProfitAmt		money,
			@NetProfitAmt		money,
			@ReleaseDt			smalldatetime,
			@ContractCostAmt	money,
			@DiscountAmt		money,
			@DisbursementAmt	money,
			@FundingToEntityAmt	money,
			@ReserveAmt			money,
			@EffectiveDt		smalldatetime,
			@Cancelled			char(1),
			@CancelDt			smalldatetime,
			@InstallmentsMade	smallint,
			@LastPaymentRcvdDt	smalldatetime;

----------------------------
-- variables nto defined 
DECLARE @EmployeeId_Open	int = 1,
		@EmployeeId_Sale	int = 1,
		@EmployeeId_TO		int = 1,
		@EmployeeId_TA		int = 1,
		@FinanceId			int	= 1;

	DECLARE Contract_cursor CURSOR FOR
	
	SELECT 	AppNum, AcctNum, ContractNum, SaleDt, RateDt, Vin, Make, Model, Year,
	NewOrUsed, FirstName, LastName, InsuredName, Address, City, State, Zip, Phone,
	Phone2, Email, Salesman, Admin, CoverageType, Coverage, TermMonth, TermMiles,
	Deduct, Class, PurchOdom, ExpOdom, TotalPremiumAmt, SalesTaxAmt, PayPlan,
	FinanceFeeAmt,	PaymentAmt, NumPayments, DownPaymentAmt, FinanceCompany, FinanceNum, FinancedAmt,
	FirstBillDt, GrossProfitAmt, NetProfitAmt, ReleaseDt, ContractCostAmt, DiscountAmt, DisbursementAmt,
	FundingToEntityAmt, ReserveAmt, EffectiveDt, ExpireDt, Cancelled, CancelDt, InstallmentsMade,
	LastPaymentRcvdDt
	FROM [PrivateReserve].[Acct].[Acct];

	OPEN Contract_cursor;
	
	FETCH NEXT FROM Contract_cursor INTO
	@AppNum, @AcctNum, @ContractNum, @SaleDt, @RateDt, @Vin, @Make, @Model, @Year,
	@NewOrUsed, @FirstName, @LastName, @InsuredName, @Address, @City, @State, @Zip, @Phone,
	@Phone2, @Email, @Salesman,	@Admin, @CoverageType, @Coverage, @TermMonth, @TermMiles,
	@DeductAmt, @Class,	@PurchOdom,	@ExpOdom, @TotalPremiumAmt,	@SalesTaxAmt, @PayPlan,
	@FinanceFeeAmt,	@PaymentAmt, @NumPayments, @DownPaymentAmt,	@FinanceCompany, @FinanceNum, @FinancedAmt,
	@FirstBillDt, @GrossProfitAmt, @NetProfitAmt, @ReleaseDt, @ContractCostAmt, @DiscountAmt, @DisbursementAmt,
	@FundingToEntityAmt, @ReserveAmt, @EffectiveDt,	@ExpireDt, @Cancelled, @CancelDt, @InstallmentsMade,
	@LastPaymentRcvdDt;

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
		-- ContractId,

	INSERT [Car].[Contract] (
	AppNum, ContractNum, EmployeeId_Open, EmployeeId_Sale, EmployeeId_TO, EmployeeId_TA, InsuredName, FirstName, LastName,
	Address, City, State, Zip, Phone, Phone2, Email, SaleDt, RateDt, Vin, Make, Model, Year, NewOrUsed,
	Coverage, Term, TermMonth, TermMiles, DeductAmt, Class, Admin, CoverageType, FinanceId, PurchOdom, ExpOdom,
	ExpireDt, TotalPremiumAmt, SalesTaxAmt,	PayPlan, FinanceFeeAmt,
	PaymentAmt, NumPayment, DownPaymentAmt,
	FinanceCompany, FinanceNum, FinancedAmt, FirstBillDt, ContractCostAmt,
	DiscountAmt, DisbursementAmt, FundingToEntityAmt, ReserveAmt, EffectiveDt,
	InstallmentsMade, LastPaymentRcvdDt, 
	IsCancelled, CancelDt )

-- RetailPlusPlusAmt,RetailAmt, CustomerCostAmt,
-- PaidInFull, PayPlanType, GrossProfitAmt, NetProfitAmt, ReleaseDt,  CancelReturnAmt)
-- @AcctNum

	VALUES ( @AppNum, @ContractNum, @EmployeeId_Open, @EmployeeId_Sale, @EmployeeId_TO, @EmployeeId_TA, @InsuredName, @FirstName, @LastName,
			@Address, @City, @State, @Zip, @Phone, @Phone2, @Email,	@SaleDt, @RateDt, @Vin, @Make, @Model, @Year, @NewOrUsed,
			@Coverage, 'Term', @TermMonth, @TermMiles, @DeductAmt, @Class, @Admin, @CoverageType, @FinanceId, @PurchOdom, @ExpOdom,
			@ExpireDt, @TotalPremiumAmt, @SalesTaxAmt, @PayPlan, @FinanceFeeAmt,
			@PaymentAmt, @NumPayments, @DownPaymentAmt,
			@FinanceCompany, @FinanceNum, @FinancedAmt, @FirstBillDt, @ContractCostAmt,
			@DiscountAmt, @DisbursementAmt, @FundingToEntityAmt, @ReserveAmt, @EffectiveDt,
			@InstallmentsMade, @LastPaymentRcvdDt, 
			@Cancelled, @CancelDt );

IF NOT EXISTS (SELECT * FROM [Car].[Car] WHERE Vin = @Vin)
	Print @Vin;
			
/*
			 @DeductAmt,

			@Salesman,
		     	  
		 @GrossProfitAmt, @NetProfitAmt, @ReleaseDt,   
		  	 
		)
*/

	FETCH NEXT FROM Contract_cursor INTO
	@AppNum, @AcctNum, @ContractNum, @SaleDt, @RateDt, @Vin, @Make, @Model, @Year,
	@NewOrUsed, @FirstName, @LastName, @InsuredName, @Address, @City, @State, @Zip, @Phone,
	@Phone2, @Email, @Salesman,	@Admin, @CoverageType, @Coverage, @TermMonth, @TermMiles,
	@DeductAmt, @Class,	@PurchOdom,	@ExpOdom, @TotalPremiumAmt,	@SalesTaxAmt, @PayPlan,
	@FinanceFeeAmt,	@PaymentAmt, @NumPayments, @DownPaymentAmt,	@FinanceCompany, @FinanceNum, @FinancedAmt,
	@FirstBillDt, @GrossProfitAmt, @NetProfitAmt, @ReleaseDt, @ContractCostAmt, @DiscountAmt, @DisbursementAmt,
	@FundingToEntityAmt, @ReserveAmt, @EffectiveDt,	@ExpireDt, @Cancelled, @CancelDt, @InstallmentsMade,
	@LastPaymentRcvdDt;

	END   

	CLOSE Contract_cursor;
	DEALLOCATE Contract_cursor;

END

-- select * from Car.Contract

-- select * from [PrivateReserve].[Acct].[Acct]





-- select * from [Car].[Contract]

-- select * from [Contract].[PayPlanTerm]

-- sp_help '[Contract].[PayPlanTerm]'

-- we deal with the pay plan aspect of this 
-- CREATE UNIQUE INDEX UK_Contract_EmplId_ClosingDt_SaleCnt ON [Car].[Contract] ([Sale_EmplId], [ClosingDt], [SaleCnt] );
-- GO


--------------------------------------------------------------------------
-- Doubt this is how we do the thing going forward - thou an idea for now
--------------------------------------------------------------------------
-- CREATE TABLE [


/*
insert [PRG].[Car].[Contract] ( AppNum, EmplId_Open, EmplId_Sale, EmplId_TO, FirstName, LastName, Address, City, State, Zip,
								Phone, Phone2, Email, SaleDt, RateDt, 
								Vin, Make, Model, Year, Odom,
								Coverage, Term, Deductable, Class,
								AdminId, CoverageType, FinanceId, ExpDt, ExpOdom, FirstBillDt,
								VehiclePrice, RetailPlusPlus, Retail, CustomerCost, PayPlanType,
								PayPlanTerm, DownPayment, MonthPayment )

select  'HZF036979' as AppNum, @EmplId_Open as Open_EmplId, @EmplId_Dan as Sale_EmplId, @EmplId_TO as TO_EmplId,
		'Douglas' as FirstName, 'Melendez' as LastName, 
		'1210 Hudson St' as Address, 'Hoboken' as City, 'NJ' as State, '07030-5411' as Zip,
		'2012227502' as Phone, '2019145597' as Phone2, '' as Email,
		'5/21/2015' as SaleDt, '5/21/2015' as RateDt,
		'KNDMB233786198405' as Vin, 'KIA' as Make, 'Sedona' as Model, '2008' as Year, 7200 as Odom, 
		'SPHDN' as Coverage, '72/70' as Term, 100 as Deductable, '0001' as Class,
		@AdminId_SunPath as AdminId, 'Exclusion' as CoverageType, @FinanceId_Omni as FinanceId,
		'06/19/2021' as ExpDt, 71000 as ExpOdom, 
		'6/21/2015' as FirstBillDt,
		0 as VehiclePrice, 3733 as RetailPlusPlus, 2800 as Retail, 2200 CustomerCost, 'Finance' as PayPlanType,
		18 as PayPlanTerm, 295 DownPayment, 105.83 as MonthPayment
*/

---------------------------------------
-- drop table [Contract].[Payment]
-----------------------------------------
CREATE TABLE [Contract].[Payment]
(
	[PaymentId]			[int]				NOT NULL	IDENTITY(1,1),
	[ContractId]		[int]				NOT NULL,
	[PaymentDt]			[smalldatetime]		NOT NULL,
	[Payment]			[money]				NOT NULL,
FOREIGN KEY ([ContractId]) REFERENCES [Car].[Contract] (ContractId),
FOREIGN KEY ([PaymentDt]) REFERENCES [Legend].[Day] (Dt),

);
GO

CREATE TABLE [Contract].[AdminAdvance]
(
	[AdvanceId]				[int]				NOT NULL	IDENTITY(1,1),
	[Admin]					[varchar](10)		NOT NULL,
	[WeekNum]				[smallint]			NOT NULL,
	[BeginDt]				[smalldatetime]		NOT NULL,
	[EndDt]					[smalldatetime]		NOT NULL,
PRIMARY KEY (AdvanceId),
FOREIGN KEY ([Admin]) REFERENCES [Contract].[Admin] (Admin),
FOREIGN KEY ([BeginDt]) REFERENCES [Legend].[Day] (Dt),
FOREIGN KEY ([EndDt]) REFERENCES [Legend].[Day] (Dt),
);
GO

---------------------------------------
-- All the Contracts tied to the advance
-----------------------------------------
CREATE TABLE [Contract].[AdminAdvanceContract]
(
	[AdvanceId]				[int]				NOT NULL,
	[ContractId]			[int]				NOT NULL,
FOREIGN KEY ([AdvanceId]) REFERENCES [Contract].[AdminAdvance] (AdvanceId),
FOREIGN KEY ([ContractId]) REFERENCES [Car].[Contract] (ContractId)
);
GO

CREATE UNIQUE INDEX PK_AdminAdvanceContract ON [Contract].[AdminAdvanceContract] (AdvanceId, ContractId);
GO

---------------------------------------
-- drop table [Contract].[Advance]
-----------------------------------------
/*
CREATE TABLE [Contract].[AdminAdvanceWeek]
(
	[AdminId]				[int]				NOT NULL,
	[WeekNum]				[smallint]			NOT NULL,

FOREIGN KEY ([AdminId]) REFERENCES [Contract].[Admin] (AdminId),		
);
*/

/* --------------------------------------------------------------------------------------------------------

select top 100 * from car.car
select Make, count(*) from car.car group by Make
-------------------------------------------------------------------------------------------------------- */

--******************************************
-- Pay Schema
--******************************************
CREATE Schema [Pay];
GO

---------------------------------------
-- drop table [Pay].[Sale]
-----------------------------------------
CREATE TABLE [Pay].[Sale]
(
	[PayPlanId]		[int]			NOT NULL,
	[Cnt]			[tinyint]		NOT NULL,
	[Multiplier]	[money]			NOT NULL,
	[Gravy]			[money]			NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] ( PayPlanId )
)
GO

CREATE UNIQUE INDEX PK_Pay_Sale ON [Pay].[Sale] ( [PayPlanId], [Cnt] );
GO

INSERT [Pay].[Sale] (PayPlanId, Cnt, Multiplier, Gravy)
select 1, 1,  90, 250 union
select 1, 2,  95, 250 union
select 1, 3, 115, 250 union
select 1, 4, 130, 250 union
select 1, 5, 150, 250 union
select 1, 6, 150, 250 -- need to figure out what the software does for sales beyond this - i.e., only keep the last number or 
GO

---------------------------------------
--
-----------------------------------------
CREATE TABLE [Pay].[SalePIF]
(
	[PayPlanId]		[int]			NOT NULL,
	[Discount]		[money]			NOT NULL,
	[Bonus]			[money]			NOT NULL,
FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] ( PayPlanId )
);
GO

CREATE UNIQUE INDEX PK_SalePIF ON [Pay].[SalePIF] (PayPlanId, Discount);
GO

INSERT [Pay].[SalePIF] (PayPlanId, Discount, Bonus)
select 1,   0, 450 union
select 1, 100, 440 union
select 1, 200, 420 union
select 1, 300, 380 union
select 1, 400, 340 union
select 1, 500, 300 union
select 1, 600, 260 union
select 1, 700, 230 union
select 1, 800, 210
;
GO

--------------------------------------------------
-- drop table [].[GravyMod_Downpayment]
--------------------------------------------------
CREATE TABLE [Pay].[GravyMod_DownPayment]
(
	[PayPlanId]		[int]		NOT NULL,
	[DownPayment]	[money]		NOT NULL,
	[Subtract]		[money]		NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] (PayPlanId)
)
GO

CREATE UNIQUE INDEX PK_GravyMod_DownPayment ON [Pay].[GravyMod_DownPayment] ( [PayPlanId], [DownPayment] );
GO

INSERT [Pay].[GravyMod_DownPayment] (PayPlanId, DownPayment, Subtract )
select 1, 995,  0 union
select 1, 895, 10 union
select 1, 795, 20 union
select 1, 695, 30 union
select 1, 595, 40 union
select 1, 495, 50 union
select 1, 395, 60 union
select 1, 295, 70 union
select 1, 195, 80;
go

---------------------------------------
--  This is the amonth that is discounted from the retail price
-----------------------------------------
CREATE TABLE [Pay].[GravyMod_Retail]
(
	[PayPlanId]			[int]		NOT NULL,
	[Discount]			[money]		NOT NULL,
	[Subtract]			[money]		NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] (PayPlanId)
);
GO

CREATE UNIQUE INDEX PK_GravyMod_Retail ON [Pay].[GravyMod_Retail] ( [PayPlanId], [Discount] );
GO

INSERT [Pay].[GravyMod_Retail] ( PayPlanId, Discount, Subtract )
select 1, 100, 5 union
select 1, 200, 15 union
select 1, 300, 35 union
select 1, 400, 55 union
select 1, 500, 75 union
select 1, 600, 95 union
select 1, 700, 115 union
select 1, 800, 130
;
GO

-- select * from [Pay].[GravyMod_Retail];

---------------------------------------
-- drop table [].[GravyMod_Term]
-----------------------------------------

CREATE TABLE [Pay].[GravyMod_PayPlanNumPayment]
(
	[PayPlanId]			[int]		NOT NULL,
	[NumPayment]		[smallint]	NOT NULL,
	[Subtract]			[money]		NOT NULL
FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] (PayPlanId),
-- FOREIGN KEY ([PayPlanTerm]) REFERENCES [Contract].[Term] (Months)
FOREIGN KEY ([NumPayment]) REFERENCES [Contract].[NumPayment] (NumPayment)
);
GO

CREATE UNIQUE INDEX PK_GravyMod_PayPlanNumPayment ON [Pay].[GravyMod_PayPlanNumPayment] ( [PayPlanId], [NumPayment] );
GO

INSERT [Pay].[GravyMod_PayPlanNumPayment] ( PayPlanId, NumPayment, Subtract )
SELECT 1, 0,   0 union
SELECT 1, 6,   0 union
SELECT 1, 9,  10 union
SELECT 1, 12, 20 union
SELECT 1, 15, 30 union
SELECT 1, 18, 40 union
SELECT 1, 24, 40;
GO


------------------------------------------
-- 
------------------------------------------
CREATE TABLE [Contract].[EmployeePay]
(
	[ContractId]		[int]					NOT NULL,
	[EmployeeId]		[int]					NOT NULL,
	[SaleRole]			[Legend].[SaleRole]		NOT NULL,
	[PayPlanId]			[int]					NOT NULL,
	[TransId]			[int]					NULL,
FOREIGN KEY ([ContractId]) REFERENCES [Car].[Contract] (ContractId),
FOREIGN KEY ([EmployeeId]) REFERENCES [Employee].[Employee] (EmployeeId),
FOREIGN KEY ([PayPlanId]) REFERENCES [Contract].[PayPlan] (PayPlanId),
FOREIGN KEY ([TransId]) REFERENCES [Acct].[Tx] (TxId)
);

CREATE UNIQUE INDEX PK_ContractEmployeeSaleRole ON [Contract].[EmployeePay] ( ContractId, SaleRole );

/*
select * from [Policy].[PayPlan];
select * from [Pay].[GravyMod_Payment];
select * from [Pay].[GravyMod_Retail];
select * from [Pay].[GravyMod_Term];
select * from [Pay].[SalePIF];
select * from [Pay].[Sale]
*/
-- select * from pay.salebase


--*********************************************************************************************
-- Put some sample in to get us going.
--*********************************************************************************************
/*

-------------------------
-- Hire some screeners
-------------------------
select * from Employee.Employee

DECLARE @RoleId int = (SELECT RoleId from [Employee].[Role] WHERE Role = 'Screener')
DECLARE @RateId int = (SELECT RateId from [Employee].[Rate] WHERE Name = 'Probation')

INSERT [Employee].[Employee] (RoleId, RateId, FirstName, HireDt)
select @RoleId, @RateId, 'Kitty', '2015-04-15' union
select @RoleId, @RateId, 'Chad', '2015-04-15' union
select @RoleId, @RateId, 'Smith', '2015-04-15' union
select @RoleId, @RateId, 'Julie', '2015-04-15' union
select @RoleId, @RateId, 'Kelly', '2015-04-15'
GO

*/

/*
select * from Policy.Policy
select * from Employee.Employee
select * from Employee.day
*/

-- add housrs worked
/*
-- truncate table [Employee].[Day];
select * from Employee.Day

select * from Employee.Employee
select * from Employee.Role
*/
GO


--****************
-- ** Start Here
--****************
DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN
	DECLARE @RoleId_Screener int = (SELECT RoleId from [Employee].[Role] WHERE Role = 'Screener');
	DECLARE @RoleId_Closer int = (SELECT RoleId from [Employee].[Role] WHERE Role = 'Closer');
	---------------------------------------------------------------------------------------------
	--  Chainz Works as a screener
	---------------------------------------------------------------------------------------------
	DECLARE @EmployeeId_Chainz int = (SELECT EmployeeId from [Employee].[Employee] WHERE FirstName = 'Chainz');
	insert [Employee].[Day] (EmployeeId, RoleId, Dt, StartTm, EndTm, TransferCnt, CloseCnt)
	select @EmployeeId_Chainz, @RoleId_Screener, '2015-03-26', '2015-03-26 9:45am', '2015-03-26 6:00pm', 2, 0 union
	select @EmployeeId_Chainz, @RoleId_Screener, '2015-03-27', '2015-03-27 9:45am', '2015-03-27 6:00pm', 3, 1 union
	select @EmployeeId_Chainz, @RoleId_Screener, '2015-03-30', '2015-03-30 10:20am', '2015-03-30 6:00pm', 1, 0 union
	select @EmployeeId_Chainz, @RoleId_Screener, '2015-03-31', '2015-03-31 11:00am', '2015-03-30 6:00pm', 0, 0 -- union
	;

	---------------------------------------------------------------------------------------------
	--  GuzJr Works as a screener
	---------------------------------------------------------------------------------------------
	DECLARE @EmployeeId_GuzJr int = (SELECT EmployeeId from [Employee].[Employee] WHERE FirstName = 'Guz Jr');
	insert [Employee].[Day] (EmployeeId, RoleId, Dt, StartTm, EndTm, TransferCnt, CloseCnt)
	select @EmployeeId_GuzJr, @RoleId_Screener, '2015-03-26', '2015-03-26 9:45am', '2015-03-26 6:00pm', 1, 0 union
	select @EmployeeId_GuzJr, @RoleId_Screener, '2015-03-27', '2015-03-27 9:45am', '2015-03-27 6:00pm', 1, 0 union
	select @EmployeeId_GuzJr, @RoleId_Screener, '2015-03-30', '2015-03-30 10:20am', '2015-03-30 6:00pm', 0, 0 union
	select @EmployeeId_GuzJr, @RoleId_Screener, '2015-03-31', '2015-03-31 11:00am', '2015-03-30 6:00pm', 0, 0 -- union
	;

	---------------------------------------------------------------------------------------------
	--  Prego Works as a screener
	---------------------------------------------------------------------------------------------
	DECLARE @EmployeeId_Prego int = (SELECT EmployeeId from [Employee].[Employee] WHERE FirstName = 'Prego');
	insert [Employee].[Day] (EmployeeId, RoleId, Dt, StartTm, EndTm, TransferCnt, CloseCnt)
	select @EmployeeId_Prego, @RoleId_Screener, '2015-03-26', '2015-03-26 9:45am', '2015-03-26 6:00pm', 4, 0 union
	select @EmployeeId_Prego, @RoleId_Screener, '2015-03-27', '2015-03-27 9:45am', '2015-03-27 6:00pm', 3, 0 union
	select @EmployeeId_Prego, @RoleId_Screener, '2015-03-30', '2015-03-30 10:20am', '2015-03-30 6:00pm', 2, 0 union
	select @EmployeeId_Prego, @RoleId_Screener, '2015-03-31', '2015-03-31 11:00am', '2015-03-30 6:00pm', 2, 0 -- union
	;

	---------------------------------------------------------------------------------------------
	--  Tawney Works as a screener
	---------------------------------------------------------------------------------------------
	DECLARE @EmployeeId_Tawney int = (SELECT EmployeeId from [Employee].[Employee] WHERE FirstName = 'Tawney');
	insert [Employee].[Day] (EmployeeId, RoleId, Dt, StartTm, EndTm, TransferCnt, CloseCnt)
	select @EmployeeId_Tawney, @RoleId_Screener, '2015-03-26', '2015-03-26 9:45am', '2015-03-26 6:00pm', 1, 0 union
	select @EmployeeId_Tawney, @RoleId_Screener, '2015-03-27', '2015-03-27 9:45am', '2015-03-27 6:00pm', 1, 0 union
	select @EmployeeId_Tawney, @RoleId_Screener, '2015-03-30', '2015-03-30 10:20am', '2015-03-30 6:00pm', 0, 0 union
	select @EmployeeId_Tawney, @RoleId_Screener, '2015-03-31', '2015-03-31 11:00am', '2015-03-30 6:00pm', 0, 0 -- union
	;

	---------------------------------------------------------------------------------------------
	--  Tawney Works as a Closer
	---------------------------------------------------------------------------------------------
	insert [Employee].[Day] (EmployeeId, RoleId, Dt, StartTm, EndTm, TransferCnt, CloseCnt)
	select @EmployeeId_Tawney, @RoleId_Closer, '2015-03-27', '2015-03-27 12:45am', '2015-03-27 1:00pm', 0, 1 -- union
	;
END
GO

-- select * from Employee.day

---------------------------------------------------------------------------------------------
--  Write some policies
---------------------------------------------------------------------------------------------
/*
DECLARE @LoadData char(1) = (SELECT LoadData FROM [dbo].[Tmp]);
IF (@LoadData = 'Y')
BEGIN

SET IDENTITY_INSERT [Car].[Contract] ON;

-- select top 100 * from car.car where year = '2011'

DECLARE @AdminId_Sunpath int = (SELECT AdminId FROM [Contract].[Admin] WHERE Name = 'SunPath');
DECLARE @AdminId_AAC int = (SELECT AdminId FROM [Contract].[Admin] WHERE Name = 'American Auto Shield');
DECLARE @AdminId_Royal int = (SELECT AdminId FROM [Contract].[Admin] WHERE Name = 'Royal');
DECLARE @AdminId_Sentinel int = (SELECT AdminId FROM [Contract].[Admin] WHERE Name = 'Sentinel');

-- select * from [Contract].[Admin]

DECLARE @PayPlanId int = (SELECT PayPlanId from [Contract].[PayPlan] WHERE Name = 'Bizkit');
DECLARE @EmplId_Tawny int = (SELECT EmplId from [Employee].[Employee] WHERE FirstName = 'Tawney');
DECLARE @EmplId_Chainz int = (SELECT EmplId from [Employee].[Employee] WHERE FirstName = 'Chainz');
--  select @EmplId_Chainz

-- select * from Policy.Policy

INSERT [Car].[Contract] (	ContractId, AdminId, AdminContractNum, Front_EmplId, Sale_EmplId, PayPlanId, Vin, ClosingDt, SaleCnt, PaidInFull, Retail, [RetailPlusPlus], Discount,
							TotalCost, AdminCost, GrossProfit, FirstPaymentDt, Months ) -- , PaymentFrequency )

SELECT	1 as ContractId, @AdminId_Sunpath as CompanyId, 'ABC123' as CompanyPolicyNum, @EmplId_Chainz, @EmplId_Tawny as EmplId, @PayPlanId, '1FMEU75847UB32730' as VIN, '2015-03-27' as ClosingDt, 1 as SaleCnt, 'Y' as PaidInFull,
		2105 as Retail, 2600 as [RetailPlusPlus], 500 as Discount, 1605 as TotalCost, 595 as AdminCost, 1010 as GrossProfit,
		'2015-03-27' as FirstPaymentDt, 0 as Months  -- , 0 as PaymentFrequency
;

INSERT [Car].[Contract] (	ContractId, AdminId, AdminContractNum, Front_EmplId, Sale_EmplId, PayPlanId, Vin, ClosingDt, SaleCnt, PaidInFull,
							DownPayment, Retail, [RetailPlusPlus], Discount,
							TotalCost, AdminCost, GrossProfit, FirstPaymentDt, Months ) -- , PaymentFrequency )

SELECT	2 as ContractId, @AdminId_Sunpath as CompanyId, 'ABC124' as CompanyPolicyNum, @EmplId_Chainz, @EmplId_Tawny as EmplId, @PayPlanId, '19UUA8F20BA000150' as VIN,
		'2015-03-27' as ClosingDt, 2 as SaleCnt, 'N' as PaidInFull, 295 as DownPayment,
		2300 as Retail, 2800 as [RetailPlusPlus], 200 as Discount, 2100 as TotalCost, 795 as AdminCost, 1305 as GrossProfit,
		'2015-03-27' as FirstPaymentDt, 12 as Months  -- , 0 as PaymentFrequency
;
SET IDENTITY_INSERT [Car].[Contract] OFF;

END
 GO
*/

------------------------------------------------------------------
-- Real Data that we figure out.
------------------------------------------------------------------
/*

select * from [PRG].[Contract].[Finance]

declare @FinanceId_Omni int = (select FinanceId from [PRG].[Contract].[Finance] where Name = 'OmniSure');

declare @Admin_SunPath varchar(10) = (select Admin from [PRG].[Contract].[Admin] where Name = 'Sunpath');
-- select @AdminId;
declare @EmplId_Open int = 1;
declare @EmplId_TO int = NULL;
declare @EmplId_Dan int = 3;


insert [PRG].[Car].[Contract] ( AppNum, EmplId_Open, EmplId_Sale, EmplId_TO, FirstName, LastName, Address, City, State, Zip,
								Phone, Phone2, Email, SaleDt, RateDt, 
								Vin, Make, Model, Year, Odom,
								Coverage, Term, Deductable, Class,
								AdminId, CoverageType, FinanceId, ExpDt, ExpOdom, FirstBillDt,
								VehiclePrice, RetailPlusPlus, Retail, CustomerCost, PayPlanType,
								PayPlanTerm, DownPayment, MonthPayment )

*/

/*
select  'HZF036979' as AppNum, @EmplId_Open as Open_EmplId, @EmplId_Dan as Sale_EmplId, @EmplId_TO as TO_EmplId,
		'Douglas' as FirstName, 'Melendez' as LastName, 
		'1210 Hudson St' as Address, 'Hoboken' as City, 'NJ' as State, '07030-5411' as Zip,
		'2012227502' as Phone, '2019145597' as Phone2, '' as Email,
		'5/21/2015' as SaleDt, '5/21/2015' as RateDt,
		'KNDMB233786198405' as Vin, 'KIA' as Make, 'Sedona' as Model, '2008' as Year, 7200 as Odom, 
		'SPHDN' as Coverage, '72/70' as Term, 100 as Deductable, '0001' as Class,
		@AdminId_SunPath as AdminId, 'Exclusion' as CoverageType, @FinanceId_Omni as FinanceId,
		'06/19/2021' as ExpDt, 71000 as ExpOdom, 
		'6/21/2015' as FirstBillDt,
		0 as VehiclePrice, 3733 as RetailPlusPlus, 2800 as Retail, 2200 CustomerCost, 'Finance' as PayPlanType,
		18 as PayPlanTerm, 295 DownPayment, 105.83 as MonthPayment



select	'8037988912' as AppNum, 'ABF193699' as SomeKey, @EmplId_Tawny, 'Reed' as LastName, 'Earl' as FirstName,
		'900 Betsy Dr' as Address, 'Columbia' as City, 'SC' as State, '29210-7804' as Zip,
		'8037988912' as Phone, '' as Phone2, 'reed_earl@bellsouth.net' as Email,
		'1G2ZH361194107134' as Vin, 

select * from QSM.CarData.Car where Vin = '1G2ZH361194107134'
select * from QSM.CarData.Car where Vin = 'KNDMB233786198405'


update 

*/





-- select * from Policy.Policy
/*
select *
from Legend.Day
where Payday = 'Y'
and Dt = '2015-04-17'
*/

--*****************************
-- Clean Up
--*****************************
GO

DROP TABLE [dbo].[Tmp];


--------------------------------------------------------------------------------------
-- Test what we are playing with here
--------------------------------------------------------------------------------------
-- select * from Acct.Acct
-- select * from Contract.FinanceTerm


--**************************************************
-- STORED PROCS
--**************************************************


------------------------------------------------------------------------------------
-- Test some stuff
------------------------------------------------------------------------------------
/*

select Exclude, AnswerMachine, count(*)
from Car.Car
group by Exclude, AnswerMachine

select * from Legend.AreaCdState

select * from 

update Car.Make set Make = upper(Make);

select * from Car.make
select * from Car.MakeInclude
select * from Car.MakeExclude

select * from Car.MakeErr

select * from Car.MakeModel where Make = 'CHEVROLET'


select * from [Car].[ModelErr]
where Make = 'CHEVROLET'
  and Model like '%SILVERADO%'


SILVERADO 1500 CLASSIC

select * from [Car].[ContractSale];
select * from [Car].[ContractSale];

select Make, count(*) from [Car].[ContractSale]
group by Make
order by count(*) desc

*/
