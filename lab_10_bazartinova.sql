USE CulturalCenters2;
GO
DROP TABLE IF EXISTS Jewel;
GO
CREATE TABLE Jewel(
	Id int PRIMARY KEY IDENTITY(1,1),
	Price int,
	Material CHAR(20)
)
GO

INSERT INTO Jewel(Price, Material) VALUES 
(70000, 'gold'),
(100000, 'gold'),
(30000, 'silver'),
(10000, 'gold'),
(42000, 'platinum'),
(6050, 'silver');
GO

-- Dirty read
-- T 1
BEGIN TRANSACTION;
    UPDATE Jewel SET Price = Price * 0.9 WHERE Material = 'silver';
    WAITFOR DELAY '00:00:15';
ROLLBACK;
SELECT * FROM Jewel;
GO


-- T 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION;
    SELECT * FROM Jewel;
COMMIT TRANSACTION;


--Non-repeatable read
-- T 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION;
	SELECT * FROM Jewel WHERE Id = 1;
	WAITFOR DELAY '00:00:05';
	SELECT * FROM Jewel WHERE Id = 1;
COMMIT;

--T 2
BEGIN TRANSACTION;
	UPDATE Jewel SET Price = 701000 WHERE Id = 1;
COMMIT TRANSACTION;

-- Phantom read
-- T 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
    SELECT * FROM Jewel
    WAITFOR DELAY '00:00:05'
    SELECT * FROM Jewel
COMMIT TRANSACTION

-- T 2
BEGIN TRANSACTION
    INSERT INTO Jewel VALUES (8000, 'platinum')
COMMIT TRANSACTION


-- T 1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION;
	SELECT * FROM Jewel;
	WAITFOR DELAY '00:00:10';
	SELECT * FROM Jewel;
	SELECT resource_type, resource_subtype, request_mode FROM
        sys.dm_tran_locks WHERE request_session_id = @@spid;
COMMIT TRANSACTION;
-- T 2
BEGIN TRANSACTION;
	INSERT INTO Jewel (price, material) VALUES(25000, 'gold')
	SELECT resource_type, resource_subtype, request_mode FROM sys.dm_tran_locks WHERE request_session_id = @@spid;
COMMIT TRANSACTION;
