CREATE PROC [cm].[spDatabasePermissionSelectByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabasePermission] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName) 

	COMMIT
