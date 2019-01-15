/****************************************************************
* Name: cm.spDatabaseInstancePermissionInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePermissionInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabasePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [PermissionSource] = 'SERVER_PERMISSION') 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
