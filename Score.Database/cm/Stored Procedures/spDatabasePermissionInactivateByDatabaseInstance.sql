﻿/****** Object:  StoredProcedure [cm].[spDatabasePermissionInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePermissionInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabasePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [PermissionSource] IN (N'DATABASE_PERMISSION', N'SERVER_PERMISSION') )
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT