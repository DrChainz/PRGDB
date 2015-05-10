-- exec [dbo].[up_MakeGoForte_DialSet]

-- truncate table [CarData].[GoForte_Extract];

-- select count(*) from [CarData].[GoForte_Extract];

USE [PrivateReserve]
GO

SELECT Listcode, Appnumber, Last, First, Middle, Address, City, State, Zip, Phone, VIN, Year, Model, Make, Odom
FROM [CarData].[GoForte_Extract]
ORDER BY Priority
