USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ShoppingCenter1')
DROP DATABASE [ShoppingCenter1]
GO

CREATE DATABASE ShoppingCenter1
ON (
	NAME = ShoppingCenter1_DAT, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ShoppingCenter1.mdf',
	SIZE = 10MB,
	MAXSIZE = 1GB,
	FILEGROWTH = 5MB
)
LOG ON (
	NAME = ShoppingCenter1_LOG, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ShoppingCenter1.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
);
GO

USE ShoppingCenter1;
GO
DROP TABLE IF EXISTS Shop;
GO
CREATE TABLE Shop (
	Id INT PRIMARY KEY CHECK (Id BETWEEN 0 AND 99),
	ShopLocation CHAR(20),
	ShopName CHAR(20) UNIQUE
);
INSERT INTO Shop VALUES 
(1, 'first floor', 'Zara'),
(2, 'first floor', 'H&M'),
(3, 'second floor', 'TopShop'),
(4, 'second floor', 'Bershka'),
(5, 'second floor', 'Pull&Bear');
GO
SELECT * FROM Shop;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ShoppingCenter2')
DROP DATABASE [ShoppingCenter2]
GO

CREATE DATABASE ShoppingCenter2
ON (
	NAME = ShoppingCenter2_DAT, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ShoppingCenter2.mdf',
	SIZE = 10MB,
	MAXSIZE = 1GB,
	FILEGROWTH = 5MB
)
LOG ON (
	NAME = ShoppingCenter2_LOG, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ShoppingCenter2.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
);
GO

USE ShoppingCenter2;
GO
DROP TABLE IF EXISTS Shop;
GO
CREATE TABLE Shop (
	Id INT PRIMARY KEY CHECK (Id BETWEEN 100 AND 199),
	ShopLocation CHAR(20),
	ShopName CHAR(20) UNIQUE
);
INSERT INTO Shop VALUES 
(101, 'first floor', 'Monkey'),
(102, 'first floor', 'Adidas'),
(103, 'second floor', 'Zarina'),
(104, 'second floor', 'Quicksilver'),
(105, 'second floor', 'Stradivarius');
GO
SELECT * FROM Shop;
GO

USE ShoppingCenter1;

DROP VIEW IF EXISTS HorizontalView;
GO

CREATE VIEW HorizontalView AS
    SELECT * FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.Shop
    UNION ALL
    SELECT * FROM [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Shop
	WITH CHECK OPTION
GO

INSERT INTO HorizontalView VALUES (6, 'first floor', 'Letual');
GO

DELETE FROM HorizontalView  WHERE ShopName = 'TopShop';  
GO

UPDATE HorizontalView SET ShopLocation = 'second floor' WHERE ShopName = 'Adidas';
SELECT * FROM HorizontalView;
GO