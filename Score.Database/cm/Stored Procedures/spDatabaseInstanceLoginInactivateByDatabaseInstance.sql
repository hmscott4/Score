/****************************************************************
* Name: cm.spDatabaseInstanceLoginInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceLoginInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseInstanceLogin]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceLogin]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
