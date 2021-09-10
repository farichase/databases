USE CulturalCenters2;
GO

/*
-- Dirty read
-- T 1
BEGIN TRANSACTION;
    UPDATE Jewel SET Price = Price * 0.9 WHERE Material = 'silver';
    WAITFOR DELAY '00:00:15';
ROLLBACK;
SELECT * FROM Jewel;
GO

--Non-repeatable read
-- T 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION;
	SELECT * FROM Jewel WHERE Id = 1;
	WAITFOR DELAY '00:00:05';
	SELECT * FROM Jewel WHERE Id = 1;
COMMIT;

-- Phantom read
-- T 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
    SELECT * FROM Jewel
    WAITFOR DELAY '00:00:05'
    SELECT * FROM Jewel
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
*/
