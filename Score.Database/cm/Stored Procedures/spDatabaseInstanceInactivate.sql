/****** Object:  StoredProcedure [cm].[spDatabaseInstanceInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceInactivate
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceInactivate] 
    @DatabaseInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseInstance]
	SET [Active] = 0, ServiceState = N'Removed', dbLastUpdate = @dbLastUpdate
	WHERE ([objectGUID] = @DatabaseInstanceGUID) 

	IF @IncludeChildObjects = 1
	BEGIN

		UPDATE [cm].[Database]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

			UPDATE [cm].[DatabaseFile]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @DatabaseInstanceGUID) )

			UPDATE [cm].[DatabaseUser]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseInstanceGUID] = @databaseInstanceGUID)

			UPDATE [cm].[DatabaseRoleMember]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseInstanceGUID] = @databaseInstanceGUID) 

			UPDATE [cm].[DatabaseProperty]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @DatabaseInstanceGUID) )

		UPDATE [cm].[DatabaseInstanceProperty]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

		UPDATE [cm].[DatabaseInstanceLogin]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

		UPDATE [cm].[Job]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

		UPDATE [cm].[LinkedServer]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

			UPDATE [cm].[LinkedServerLogin]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Database]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT