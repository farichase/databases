USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'CulturalCenters2')
DROP DATABASE [CulturalCenters2]
GO


CREATE DATABASE CulturalCenters2
ON (
	NAME = CulturalCenters_DB, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CulturalCenters2.mdf',
	SIZE = 10MB,
	MAXSIZE = 1GB,
	FILEGROWTH = 5MB
)
LOG ON (
	NAME = Exhibition_DB_LOG, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CulturalCenters2.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
);
GO

USE CulturalCenters2;
GO

CREATE TABLE Exhibition_Table (
	ExhibitionId INT PRIMARY KEY NOT NULL,
	Adds CHAR(20) NOT NULL,
	DateOfTheExhibition DATE NOT NULL,
	Sponsor CHAR(20) NOT NULL,
	Phone CHAR(20) NOT NULL,
	Price INT NOT NULL
);
GO

ALTER DATABASE CulturalCenters 
ADD FILEGROUP CulturalCenters_FG;
GO

ALTER DATABASE CulturalCenters
ADD FILE (
	NAME = Exhibition_File,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\exhibition.ndf',
	SIZE = 10MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 5MB
) TO FILEGROUP CulturalCenters_FG
GO

ALTER DATABASE CulturalCenters
MODIFY FILEGROUP CulturalCenters_FG DEFAULT;
GO

CREATE TABLE Museum_Table (
	MuseumId INT,
	Adds CHAR(20) NOT NULL,
	Phone CHAR(20) NOT NULL,
	Price INT NOT NULL
);
GO

CREATE CLUSTERED INDEX PK_Museum_Table_MuseumId ON Museum_Table (MuseumId)   
    ON [PRIMARY]
GO

ALTER DATABASE CulturalCenters
MODIFY FILEGROUP [PRIMARY] DEFAULT;
GO


ALTER DATABASE CulturalCenters
REMOVE FILE Exhibition_File;
GO

ALTER DATABASE CulturalCenters
REMOVE FILEGROUP CulturalCenters_FG;
GO

CREATE SCHEMA schemaForDB
GO

ALTER SCHEMA schemaForDB TRANSFER Exhibition_Table
GO

ALTER SCHEMA dbo TRANSFER schemaForDB.Exhibition_Table
GO

DROP SCHEMA schemaForDB
GO


