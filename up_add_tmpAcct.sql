USE [QSM];
GO

-- select * from [dbo].[tmpAcct];

-- select * into Acct.Acct_backup2 from Acct.Acct;

-- alter table Acct.Acct add ProfitAmt money 

select * from Acct.Acct


IF OBJECT_ID(N'up_add_tmpAcct') IS NOT NULL
	DROP PROC up_add_tmpAcct;
GO

CREATE PROC up_add_tmpAcct
AS
SET NOCOUNT ON;

DECLARE @Salesman			varchar(20),
		@AppNum				varchar(10),
		@Name				varchar(50),
		@Year				char(4),
		@Make				varchar(20),
		@AutoCd				varchar(20),
		@Coverage			varchar(20),
		@Trm				varchar(20),
		@Ded				varchar(20),
		@Surch				varchar(20),
		@Clss				varchar(20),
		@TotalPremiumAmt	money,
		@SellerCostAmt		money,
		@ProfitAmt			money,
		@FinSrc				varchar(20),
		@Admin				varchar(20);

-- select * from tmpAcct;

DECLARE tmp_cur CURSOR FOR SELECT Rep, AppNumber, Name, Year, Make, AutoCd, Coverage, Trm, Ded, Surch, Clss, CustmrCost, AdminstrCost, Profit, FinSrc, Admin FROM tmpAcct;

OPEN tmp_cur;

FETCH NEXT FROM tmp_cur INTO @Salesman,	@AppNum, @Name, @Year, @Make, @AutoCd, @Coverage, @Trm, @Ded, @Surch, @Clss, @TotalPremiumAmt, @SellerCostAmt, @ProfitAmt, @FinSrc, @Admin;

WHILE @@FETCH_STATUS = 0
BEGIN

	IF NOT EXISTS (SELECT 1 FROM Acct.Acct WHERE AppNum = @AppNum)
		INSERT Acct.Acct (AppNum)
		VALUES (@AppNum);

	UPDATE [Acct].[Acct] SET Salesman = @Salesman WHERE AppNum = @AppNum;

	UPDATE [Acct].[Acct] SET InsuredName = @Name WHERE AppNum = @AppNum and InsuredName IS NULL;

	UPDATE [Acct].[Acct] SET Year = @Year WHERE AppNum = @AppNum and Year IS NULL;

	UPDATE [Acct].[Acct] SET Make = @Make WHERE AppNum = @AppNum and Make IS NULL;

	UPDATE [Acct].[Acct] SET Model = @AutoCd WHERE AppNum = @AppNum and Model IS NULL;

	UPDATE [Acct].[Acct] SET Coverage = @Coverage WHERE AppNum = @AppNum and Coverage IS NULL;

	UPDATE [Acct].[Acct] SET PolicyTerm = substring(@Trm,1,2) WHERE AppNum = @AppNum and PolicyTerm IS NULL;
--	UPDATE [Acct].[Acct] SET Ded
--	UPDATE [Acct].[Acct] SET Surch
--	UPDATE [Acct].[Acct] SET Clss
	UPDATE [Acct].[Acct] SET TotalPremiumAmt = @TotalPremiumAmt WHERE AppNum = @AppNum and TotalPremiumAmt IS NULL;
	UPDATE [Acct].[Acct] SET SellerCostAmt = @SellerCostAmt WHERE AppNum = @AppNum and SellerCostAmt IS NULL;
	UPDATE [Acct].[Acct] SET ProfitAmt = @ProfitAmt WHERE AppNum = @AppNum and ProfitAmt IS NULL;
-- 	UPDATE [Acct].[Acct] SET FinSrc
	UPDATE [Acct].[Acct] SET Admin = @Admin WHERE AppNum = @AppNum and Admin IS NULL;


-- 	select @Salesman,	@AppNum, @Name, @Year, @Make, @AutoCd, @Coverage, @Trm, @Ded, @Surch, @Clss, @TotalPremiumAmt, @SellerCostAmt, @ProfitAmt, @FinSrc, @Admin;
    
	FETCH NEXT FROM tmp_cur INTO @Salesman,	@AppNum, @Name, @Year, @Make, @AutoCd, @Coverage, @Trm, @Ded, @Surch, @Clss, @TotalPremiumAmt, @SellerCostAmt, @ProfitAmt, @FinSrc, @Admin;
END

CLOSE tmp_cur
DEALLOCATE tmp_cur
GO

---------------------------------------
--
---------------------------------------
exec up_add_tmpAcct;
GO
-- select * from Acct.Acct

select salesman, count(*)
from Acct.Acct
group by salesman

select * from Acct.Acct

-- update Acct.Acct  set salesman = 'tawney' where salesman = 'pj3271'