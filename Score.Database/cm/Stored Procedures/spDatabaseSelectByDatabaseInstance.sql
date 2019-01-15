CREATE PROC [cm].[spDatabaseSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Database] 
	WHERE  ([databaseInstanceGUID] = @databaseInstanceGUID AND [Active] >= @Active) 

	COMMIT
