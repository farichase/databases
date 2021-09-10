USE CulturalCenters2;
GO

DROP TABLE IF EXISTS Jewelry;
GO
CREATE TABLE Jewelry (
	ID INT IDENTITY PRIMARY KEY, 
	JewelryId INT NOT NULL,
	Material CHAR(20) NOT NULL,
	Price INT NOT NULL,
	PercentageDiscount INT NOT NULL
);
DROP TABLE IF EXISTS Shop;
GO
INSERT INTO Jewelry 
	VALUES (1, 'gold', 7000, 10), 
		   (2, 'gold', 19000, 5),
		   (3, 'silver', 2500, 10),
		   (4, 'silver', 15000, 15),
		   (5, 'silver', 6500, 10);
GO

IF OBJECT_ID(N'dbo.GetPrice') IS NOT NULL
DROP FUNCTION dbo.GetPrice
GO
CREATE FUNCTION GetPrice(@price int, @percentagediscount int) RETURNS int
AS BEGIN
	RETURN @price * (100 - @percentagediscount) / 100;
END;
GO

IF OBJECT_ID(N'dbo.GetJewelry') IS NOT NULL
DROP FUNCTION dbo.GetJewelry
GO
CREATE FUNCTION GetJewelry() RETURNS TABLE
AS RETURN SELECT JewelryId, Price FROM Jewelry;
GO

IF OBJECT_ID(N'dbo.CalculateLevel') IS NOT NULL
DROP FUNCTION dbo.CalculateLevel
GO
CREATE FUNCTION CalculateLevel(@price INT) RETURNS CHAR(20)
AS BEGIN
	DECLARE @level CHAR(20)
	IF @price > 10000 SET @level = 'FIRSTLEVEL';
	ELSE SET @level = 'SECONDLEVEL';
	RETURN @level;
END;
GO
--1 & 2 & 3
IF OBJECT_ID(N'dbo.GetJewelryPrice') IS NOT NULL
DROP PROCEDURE dbo.GetJewelryPrice
GO
CREATE PROCEDURE GetJewelryPrice
	@res CURSOR VARYING OUTPUT
AS BEGIN
	SET @res = CURSOR SCROLL STATIC FOR
	SELECT JewelryId, dbo.GetPrice(Price, PercentageDiscount) FROM Jewelry 
	OPEN @res
END;
GO

IF OBJECT_ID(N'dbo.myProc') IS NOT NULL
DROP PROCEDURE dbo.myProc
GO
CREATE PROCEDURE myProc
AS BEGIN;
	DECLARE @curs CURSOR;
	EXEC GetJewelryPrice @res = @curs OUTPUT;
	DECLARE @msg CHAR(60), @id INT, @price INT, @level CHAR(20);
	SET @level = 'FIRSTLEVEL';

	FETCH NEXT FROM @curs INTO @id, @price;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN;
		IF (dbo.CalculateLevel(@price) = @level)
			BEGIN;
				SELECT @msg = 'Jewelry ID:' +  CAST(@id AS CHAR) + '| Price: '+ CAST(@price AS CHAR);
				PRINT @msg
			END;
		FETCH NEXT FROM @curs INTO @id, @price;
	END;
	CLOSE @curs; 
	DEALLOCATE @curs;
END;
GO

--4
IF OBJECT_ID(N'dbo.GetJewelryPrice2') IS NOT NULL
DROP PROCEDURE dbo.GetJewelryPrice2
GO
CREATE PROCEDURE GetJewelryPrice2
	@res2 CURSOR VARYING OUTPUT
AS BEGIN
	SET @res2 = CURSOR SCROLL STATIC FOR
	SELECT JewelryId, Price FROM dbo.GetJewelry() 
	OPEN @res2
END;
GO

IF OBJECT_ID(N'dbo.myProc2') IS NOT NULL
DROP PROCEDURE dbo.myProc2
GO
CREATE PROCEDURE myProc2
AS BEGIN;
	DECLARE @curs2 CURSOR;
	EXEC GetJewelryPrice2 @res2 = @curs2 OUTPUT;
	DECLARE @msg CHAR(60), @id INT, @price INT;

	FETCH NEXT FROM @curs2 INTO @id, @price;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN;
		SELECT @msg = 'Jewelry ID:' +  CAST(@id AS CHAR) + '| Price: '+ CAST(@price AS CHAR);
		PRINT @msg
		FETCH NEXT FROM @curs2 INTO @id, @price;
	END;
	CLOSE @curs2; 
	DEALLOCATE @curs2;
END;
GO


EXEC myProc;
GO
EXEC myProc2;
GO
