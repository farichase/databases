USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Exhibitions')
DROP DATABASE [Exhibitions]
GO


CREATE DATABASE Exhibitions
ON (
	NAME = Exhibitions_DB, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Exhibitions.mdf',
	SIZE = 10MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 5MB
)
LOG ON (
	NAME = Exhibitions_LOG, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Exhibitions.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
);
GO

USE Exhibitions;
GO

DROP TABLE IF EXISTS Exhibition;
GO
CREATE TABLE Exhibition (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Adds CHAR(20) NOT NULL,
	ExhibitionDate DATE NOT NULL,
	Sponsor CHAR(20) NOT NULL,
	Theme CHAR(20) NOT NULL
);
GO

INSERT INTO Exhibition VALUES
('Lavrushinsky per., 10, Moscow', 2020-10-23, 'Romanov M. I.', 'Halloween'),
('Izmailovsky pr., 73, Moscow', 2020-11-23, 'Somov S. I.', 'Other world'),
('Lenina st., 15, Moscow', 2020-10-11, 'Krasnova U. F.', 'Alice in Wonderland');
GO

DROP TABLE IF EXISTS FieldOfActivity;
GO
CREATE TABLE FieldOfActivity (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	HallNumber CHAR(20) NOT NULL,
	Rent int NOT NULL,
);
GO

DROP TABLE IF EXISTS Stand;
GO
CREATE TABLE Stand (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Description CHAR(20),
);
GO

DROP TABLE IF EXISTS Artist;
GO
CREATE TABLE Artist (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	NumberOfStands int NOT NULL,
	Instagram CHAR(20) NOT NULL,
	Awards CHAR(20)
);
GO

DROP TABLE IF EXISTS Product;
GO
CREATE TABLE Product (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Price int NOT NULL,
	Material CHAR(20) NOT NULL,
	Packaging CHAR(20),
);
GO