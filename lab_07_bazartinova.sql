USE CulturalCenters2;
GO

DROP VIEW IF EXISTS GuestView;
GO
CREATE VIEW GuestView AS
	SELECT * FROM Guest WHERE Age > 30;
GO
SELECT * FROM GuestView;
GO


DROP VIEW IF EXISTS Stand_PictureView;
GO
CREATE VIEW Stand_PictureView AS
	SELECT s.StandId, s.StandLocation, p.PictureId
FROM Stand s JOIN Picture p ON s.StandId = p.StandId
GO
SELECT * FROM Stand_PictureView;

DROP INDEX IF EXISTS PictureIND ON Picture
GO
CREATE INDEX PictureIND
	ON Picture (Number)
	INCLUDE (Canvas)
GO
SELECT Number, Canvas
FROM Picture WITH (INDEX(PictureIND)) WHERE Canvas = 'silk'
GO


DROP VIEW IF EXISTS IndView
GO
CREATE VIEW IndView WITH SCHEMABINDING AS
	SELECT Number, Canvas, DrawingTool FROM dbo.Picture WHERE Canvas = 'silk'
GO
CREATE UNIQUE CLUSTERED INDEX ind_view ON IndView (Number, Canvas);
GO
SELECT * FROM IndView
GO