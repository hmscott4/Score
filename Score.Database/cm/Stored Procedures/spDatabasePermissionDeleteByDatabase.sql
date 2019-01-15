/****************************************************************
* Name: cm.spDatabasePermissionDeleteByDatabase
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionDeleteByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabasePermission]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName) 

	COMMIT
