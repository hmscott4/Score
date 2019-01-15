/****************************************************************
* Name: cm.spDatabaseInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[Database]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([databaseInstanceGUID] = @databaseInstanceGUID) 

	IF @IncludeChildObjects = 1
	BEGIN
		UPDATE [cm].[DatabaseFile]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([databaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @databaseInstanceGUID) )

		UPDATE [cm].[DatabaseProperty]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @databaseInstanceGUID) )
	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Database]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
