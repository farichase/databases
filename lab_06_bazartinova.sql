USE CulturalCenters2;
GO
DROP TABLE IF EXISTS Guest;
GO
CREATE TABLE Guest(
	GuestId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	GuestName CHAR(20) NOT NULL,
	Phone CHAR(20) UNIQUE CHECK(Phone !='') NOT NULL
)
ALTER TABLE Guest
ADD Age INT DEFAULT 18 CHECK ((Age >= 18) AND (SIGN(AGE) = 1)) NOT NULL;
GO

INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Kevin', 37, '89871111111');  -- OK
INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Tessa', 47, '89872111111');  -- OK
INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Ann', 27, '89873111111');  -- OK
--INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Dara', 37, '89871111111');  -- NOT OK
--INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Pam', 37, '');  -- NOT OK
--INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Randall', 17, '89871111111');  -- NOT OK
--INSERT INTO Guest (GuestName, Age, Phone) VALUES ('Kate', -37, '89871111111');  -- NOT OK
GO
SELECT * FROM Guest;
GO

SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY];  
GO  
SELECT @@IDENTITY AS [@@IDENTITY];  
GO
SELECT * FROM Guest;
GO

DROP TABLE IF EXISTS Artist;
GO
CREATE TABLE Artist (
	ArtistId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Instagram CHAR(30) NOT NULL
)
GO
INSERT INTO Artist (Instagram) VALUES ('liluhem');
GO

DROP TABLE IF EXISTS Product;
GO
CREATE TABLE Product(
	ProductID int PRIMARY KEY NOT NULL,
	Material CHAR(30) NOT NULL
)
GO

DROP SEQUENCE IF EXISTS CountBy1;
GO
CREATE SEQUENCE CountBy1
	START WITH 1
	INCREMENT BY 2;
GO

INSERT Product (ProductID, Material) VALUES (NEXT VALUE FOR CountBy1, 'Silver');
INSERT Product (ProductID, Material) VALUES (NEXT VALUE FOR CountBy1, 'Gold') ;
INSERT Product (ProductID, Material) VALUES (NEXT VALUE FOR CountBy1, 'Gold') ;
GO
SELECT * FROM Product;
GO
DROP TABLE IF EXISTS Picture;
GO
DROP TABLE IF EXISTS Stand;
GO
CREATE TABLE Stand(
	StandId int PRIMARY KEY,
	StandLocation CHAR(20),
	Destination CHAR(20)
)
GO

CREATE TABLE Picture(
	PictureId int,
	Canvas CHAR(20),
	DrawingTool CHAR(20),
	StandId int,
	Number int,
	CONSTRAINT key1 FOREIGN KEY (PictureId) REFERENCES Stand (StandId) ON DELETE CASCADE
)
GO

INSERT Stand (StandId, StandLocation, Destination) VALUES (1, 'first hall', 'pictures'), (2, 'first hall', 'candles'), (3,'second hall', 'jewelry'), (4,'third hall', 'dishes');
GO
INSERT Picture (PictureId, Canvas, DrawingTool, StandId, Number) VALUES (1, 'silk', 'oil paints', 1, 12), (2, 'linen', 'oil paints', 2, 13), (3, 'cotton', 'oil paints', 4, 14), (4, 'silk', 'oil paints', 3, 15);
GO
SELECT * FROM Stand;
SELECT * FROM Picture;


