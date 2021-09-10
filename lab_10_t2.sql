USE CulturalCenters2;
GO

/*
-- Dirty read
-- T 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION;
    SELECT * FROM Jewel;
COMMIT TRANSACTION;


--Non-repeatable read
--T 2
BEGIN TRANSACTION;
	UPDATE Jewel SET Price = 701000 WHERE Id = 1;
COMMIT TRANSACTION;

-- Phantom read
-- T 2
BEGIN TRANSACTION
    INSERT INTO Jewel VALUES (8000, 'platinum')
COMMIT TRANSACTION

*/
-- T 2
BEGIN TRANSACTION;
	INSERT INTO Jewel (price, material) VALUES(25000, 'gold')
	SELECT resource_type, resource_subtype, request_mode FROM sys.dm_tran_locks WHERE request_session_id = @@spid;
COMMIT TRANSACTION;

