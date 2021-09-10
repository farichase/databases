USE CulturalCenters2;
GO
DROP TABLE IF EXISTS Teacher;
GO
DROP TABLE IF EXISTS TheArtist;
GO
CREATE TABLE TheArtist(
	Id int PRIMARY KEY IDENTITY(1,1),
	Instagram CHAR(20) UNIQUE
)
GO

CREATE TABLE Teacher(
	Id int PRIMARY KEY,
	FirstName CHAR(20),
	LastName CHAR(20),
	CONSTRAINT keyTAr FOREIGN KEY (Id) REFERENCES TheArtist (Id) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

DROP VIEW IF EXISTS ArtistWithPicture_View;
GO
CREATE VIEW ArtistWithPicture_View AS
	SELECT a.Id, a.Instagram, t.FirstName, t.LastName
FROM TheArtist a JOIN Teacher t ON a.Id = t.Id
GO

DROP TRIGGER IF EXISTS ArtistWithPicture_View_Insert
GO
CREATE TRIGGER ArtistWithPicture_View_Insert
ON ArtistWithPicture_View
INSTEAD OF INSERT
AS BEGIN; 
	DECLARE @t Table (Id int, Instagram CHAR(20))
	INSERT INTO TheArtist (Instagram)
		OUTPUT inserted.Id, inserted.Instagram INTO @t
		SELECT Instagram FROM inserted;
	INSERT INTO Teacher SELECT t1.Id, t2.FirstName, t2.LastName
	FROM @t t1 JOIN inserted t2 ON t1.Instagram = t2.Instagram;
END;
GO

INSERT INTO ArtistWithPicture_View (Instagram, FirstName, LastName) VALUES
('firstJack', 'Jack', 'Hill'), 
('littlegirl', 'Abby', 'Clark'), 
('qwerty', 'Kevin', 'Pearson'), 
('beth22', 'Bethany', 'Lewis'), 
('real_Tom', 'Tom', 'Scott');
GO

SELECT * FROM ArtistWithPicture_View;
GO

DROP TRIGGER IF EXISTS ArtistWithPicture_View_Delete
GO
CREATE TRIGGER ArtistWithPicture_View_Delete
ON ArtistWithPicture_View
INSTEAD OF DELETE
AS 
DELETE FROM TheArtist WHERE Id IN (SELECT Id FROM deleted);
GO

DELETE FROM ArtistWithPicture_View WHERE Id > 3;
GO

SELECT * FROM ArtistWithPicture_View;
GO 

DROP TRIGGER IF EXISTS ArtistWithPicture_View_Update
GO
CREATE TRIGGER ArtistWithPicture_View_Update
ON ArtistWithPicture_View
INSTEAD OF UPDATE
AS BEGIN; 
	IF UPDATE(Instagram) or UPDATE(FirstName) or UPDATE(LastName)
	BEGIN;
		UPDATE TheArtist SET Instagram = a.Instagram
		FROM (SELECT Id, Instagram FROM inserted) AS a 
		WHERE (TheArtist.Id = a.Id)

		UPDATE Teacher  
		SET 
			FirstName = (SELECT FirstName FROM inserted WHERE Teacher.Id = inserted.Id), 
			LastName = (SELECT LastName FROM inserted WHERE Teacher.Id = inserted.Id)
		WHERE Id In (SELECT Id FROM inserted WHERE Teacher.Id = inserted.Id)
	END;
	ELSE RAISERROR ('You cannot update ID', -1, 1);
END;
GO

UPDATE ArtistWithPicture_View SET Instagram = 'the_real_Tommy' WHERE Id = 1;
GO

SELECT * FROM ArtistWithPicture_View;
GO

CREATE TRIGGER Trigger_Insert ON TheArtist
	AFTER INSERT AS
	PRINT 'Trigger_Insert works';
GO

CREATE TRIGGER Trigger_Delete ON TheArtist
	AFTER DELETE AS
	PRINT 'Trigger_Delete works';
GO

CREATE TRIGGER Trigger_Update ON TheArtist
	INSTEAD OF UPDATE AS
	RAISERROR ('Trigger_Update works', -1, 1);
GO

INSERT INTO TheArtist VALUES ('secondJack');
GO
UPDATE TheArtist SET Instagram = '' WHERE Id = 1;
GO
DELETE TheArtist WHERE Id = 4;
GO
SELECT * FROM TheArtist;
GO