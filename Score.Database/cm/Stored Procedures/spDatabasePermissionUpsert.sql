/****************************************************************
* Name: cm.spDatabasePermissionUpsert
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @PermissionSource nvarchar(32),
    @PermissionState nvarchar(128),
    @PermissionType nvarchar(128),
    @Grantor nvarchar(128),
    @ObjectName nvarchar(128),
    @Grantee nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabasePermission] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID]=@DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND PermissionSource=@PermissionSource AND [PermissionState]=@PermissionState AND [PermissionType]=@PermissionType AND [Grantor]=@Grantor AND [ObjectName] = @ObjectName AND [Grantee]=@Grantee)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @DatabaseName, @PermissionSource, @PermissionState, @PermissionType, @Grantor, @ObjectName, @Grantee, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
