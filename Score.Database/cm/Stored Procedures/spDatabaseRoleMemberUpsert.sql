/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseRoleMemberUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @RoleName nvarchar(128),
    @RoleMember nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseRoleMember] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND [RoleName] = @RoleName AND [RoleMember] = @RoleMember)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ( [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate])
		VALUES ( @DatabaseInstanceGUID, @DatabaseName, @RoleName, @RoleMember, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseRoleMember]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT