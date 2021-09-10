USE ShoppingCenter1;

DROP TABLE IF EXISTS TheShop;
GO
CREATE TABLE TheShop (
	ShopId INT PRIMARY KEY,
	Director INT UNIQUE NOT NULL, --F
	ShopName CHAR(20) UNIQUE NOT NULL
)
INSERT INTO TheShop VALUES (1, 101, 'Zara'),(2, 102, 'TopShop')
SELECT * FROM TheShop;
GO

USE ShoppingCenter2;

DROP TABLE IF EXISTS Director;
GO
CREATE TABLE Director (
	DirectorId INT PRIMARY KEY,
	DirectorName CHAR(20) UNIQUE NOT NULL,
)
INSERT INTO Director VALUES (101, 'Randall Pirson'), (102, 'Kate Young');
GO
SELECT * FROM Director;
GO

USE ShoppingCenter1
DROP VIEW IF EXISTS ShopView
GO
CREATE VIEW ShopView AS
	SELECT a.ShopId, a.ShopName, d.DirectorId, d.DirectorName
        FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop a
        INNER JOIN [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Director d
        ON a.Director = d.DirectorId
GO
SELECT * FROM ShopView;
GO

USE ShoppingCenter1;
-- Triggers for foreign key

DROP TRIGGER IF EXISTS ShopFK
GO
CREATE OR ALTER TRIGGER ShopFK ON TheShop
    AFTER INSERT, UPDATE AS BEGIN
        IF (ROWCOUNT_BIG() = 0)
            RETURN;
        IF (
            (SELECT COUNT(*) FROM inserted)
            != 
            (SELECT COUNT(*) FROM inserted t1 INNER JOIN [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Director t2 
                ON t1.Director = t2.DirectorId)
        ) BEGIN
            RAISERROR ('Error in foreign key constraint', 15, 1);
        END
    END
GO
USE ShoppingCenter2;

DROP TRIGGER IF EXISTS DirectorFK
GO
CREATE OR ALTER TRIGGER DirectorFK ON Director
    AFTER DELETE AS BEGIN
        IF (ROWCOUNT_BIG() = 0)
            RETURN;
        IF EXISTS (
            SELECT * FROM deleted t1 
                INNER JOIN [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop t2
                ON t1.DirectorId = t2.Director
        ) BEGIN
            RAISERROR ('Error in foreign key constraint (NO_ACTION)', 15, 1);
        END
    END
GO

USE ShoppingCenter1;
-- Triggers for view
DROP TRIGGER IF EXISTS InsTrigger1
GO

CREATE TRIGGER InsTrigger1 ON ShopView
    INSTEAD OF INSERT AS BEGIN;
        INSERT INTO [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Director(DirectorId, DirectorName)
            SELECT DirectorId, DirectorName FROM inserted
            WHERE DirectorId NOT IN (
                SELECT DirectorId FROM [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Director tt
                WHERE inserted.DirectorId = tt.DirectorId
            );
        INSERT INTO [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop(ShopId, Director, ShopName)
            SELECT ShopId, DirectorId, ShopName FROM inserted
            WHERE ShopId NOT IN (
                SELECT ShopId FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop tt
                WHERE inserted.ShopId = tt.ShopId
            );
    END;
GO

DROP TRIGGER IF EXISTS DelTrigger1
GO
CREATE TRIGGER DelTrigger1 ON ShopView
    INSTEAD OF DELETE AS BEGIN;
        DELETE FROM [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop
            WHERE ShopId IN ( SElECT ShopId FROM deleted );
    END;
GO

DROP TRIGGER IF EXISTS UpdTrigger1
GO
CREATE TRIGGER UpdTrigger1 ON ShopView
    INSTEAD OF UPDATE AS BEGIN;
        IF (UPDATE(ShopId))
            RAISERROR ('You cannot update ShopId', 15, 1);
        ELSE BEGIN
            IF (UPDATE(ShopName))
                UPDATE [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop SET ShopName = t.ShopName
                    FROM ( SELECT ShopId, ShopName FROM INSERTED ) AS t
                    WHERE TheShop.ShopId = t.ShopId
            IF (UPDATE(DirectorName))
                UPDATE [LAPTOP-FA0KK77B].ShoppingCenter2.dbo.Director SET DirectorName = t.DirectorName
                    FROM ( SELECT DirectorId, DirectorName FROM INSERTED ) AS t
                    WHERE Director.DirectorId = t.DirectorId
            IF (UPDATE(DirectorId)) BEGIN;
                UPDATE [LAPTOP-FA0KK77B].ShoppingCenter1.dbo.TheShop SET Director = t.DirectorId
                    FROM ( SELECT ShopId, DirectorId FROM INSERTED ) AS t
                    WHERE TheShop.ShopId = t.ShopId
            END;
        END
    END;
GO

INSERT INTO ShopView(ShopId, ShopName, DirectorId, DirectorName) VALUES
(3, 'Monkey' , 103,'James Chase'); 
GO
UPDATE ShopView SET ShopName = 'Lilu' WHERE ShopId = 1;


DELETE FROM ShopView WHERE ShopId = 2;
GO
SELECt * FROM ShopView;
GO

