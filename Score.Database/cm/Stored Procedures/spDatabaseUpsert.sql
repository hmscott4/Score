/****************************************************************
* Name: cm.spDatabaseUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @DatabaseID int,
    @RecoveryModel nvarchar(128),
    @Status nvarchar(128),
    @ReadOnly bit,
    @UserAccess nvarchar(128),
    @CreateDate datetime2(3),
    @Owner nvarchar(128),
    @LastFullBackup datetime2(3),
    @LastDiffBackup datetime2(3),
    @LastLogBackup datetime2(3),
    @CompatibilityLevel nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Database] AS target
	USING (SELECT @DatabaseID, @RecoveryModel, @Status, @ReadOnly, @UserAccess, @CreateDate, @Owner, @LastFullBackup, @LastDiffBackup, @LastLogBackup, @CompatibilityLevel, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DatabaseID] = @DatabaseID, [RecoveryModel] = @RecoveryModel, [Status] = @Status, [ReadOnly] = @ReadOnly, [UserAccess] = @UserAccess, [CreateDate] = @CreateDate, [Owner] = @Owner, [LastFullBackup] = @LastFullBackup, [LastDiffBackup] = @LastDiffBackup, [LastLogBackup] = @LastLogBackup, [CompatibilityLevel] = @CompatibilityLevel, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @DatabaseName, @DatabaseID, @RecoveryModel, @Status, @ReadOnly, @UserAccess, @CreateDate, @Owner, @LastFullBackup, @LastDiffBackup, @LastLogBackup, @CompatibilityLevel, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Database]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
