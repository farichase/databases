USE ShoppingCenter1;

DROP TABLE IF EXISTS Artist;
GO
CREATE TABLE Artist (
	Id INT PRIMARY KEY,
	Instagram CHAR(20) UNIQUE NOT NULL
)
INSERT INTO Artist VALUES (1, 'liluhem'), (2, 'chase')

USE ShoppingCenter2;

DROP TABLE IF EXISTS Artist;
GO
CREATE TABLE Artist (
	Id INT PRIMARY KEY,
	FirstName CHAR(20) UNIQUE NOT NULL,
	LastName CHAR(20) UNIQUE NOT NULL
)
INSERT INTO Artist VALUES (1, 'Lili','Simons'), (2, 'James', 'Chase');
GO
USE ShoppingCenter1
DROP VIEW IF EXISTS VerticalView
GO
CREATE VIEW VerticalView AS
    SELECT a.Id, a.Instagram, b.FirstName, b.LastName
    FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.Artist a
    JOIN [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Artist b
    ON a.Id = b.Id
GO
SELECT * FROM VerticalView;
GO

DROP TRIGGER IF EXISTS VerticalView_Insert
GO
CREATE TRIGGER VerticalView_Insert
ON VerticalView
INSTEAD OF INSERT
AS BEGIN; 
	INSERT INTO [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.Artist (Id, Instagram)
		SELECT Id, Instagram FROM inserted;
	INSERT INTO [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Artist (Id, FirstName, LastName)
		SELECT Id, FirstName, LastName FROM inserted;
END;
GO

DROP TRIGGER IF EXISTS VerticalView_Delete
GO
CREATE TRIGGER VerticalView_Delete
ON VerticalView
INSTEAD OF DELETE
AS 
DELETE FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.Artist WHERE Id IN (SELECT Id FROM deleted);
DELETE FROM [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Artist WHERE Id IN (SELECT Id FROM deleted);
GO

DROP TRIGGER IF EXISTS VerticalView_Update
GO
CREATE TRIGGER VerticalView_Update
ON VerticalView
INSTEAD OF UPDATE
AS BEGIN; 
	IF UPDATE(Instagram) or UPDATE(FirstName) or UPDATE(LastName)
	BEGIN;
		UPDATE [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.Artist SET Instagram = a.Instagram
		FROM (SELECT Id, Instagram FROM inserted) AS a 
		WHERE (Artist.Id = a.Id)

		UPDATE [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Artist  
		SET 
			FirstName = (SELECT FirstName FROM inserted WHERE Artist.Id = inserted.Id), 
			LastName = (SELECT LastName FROM inserted WHERE Artist.Id = inserted.Id)
		WHERE Id In (SELECT Id FROM inserted WHERE Artist.Id = inserted.Id)
	END;
	ELSE RAISERROR ('You cannot update ID', -1, 1);
END;
GO
UPDATE VerticalView SET Instagram = 'the_real_Tommy' WHERE Id = 1;
GO
DELETE FROM VerticalView WHERE Id = 2;
GO
INSERT INTO VerticalView (Id, Instagram, FirstName, LastName) VALUES
(3, 'firstJack', 'Jack', 'Hill'), 
(4, 'littlegirl', 'Abby', 'Clark');
GO

SELECT * FROM VerticalView;
GO

SELECT * FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.Artist;
GO
SELECT * FROM [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Artist;
GO
