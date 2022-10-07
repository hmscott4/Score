/****** Object:  StoredProcedure [cm].[spDatabaseUserUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUserUpsert
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128),
    @UserName nvarchar(128),
    @Login nvarchar(128),
    @UserType nvarchar(128),
    @LoginType nvarchar(128),
    @HasDBAccess bit,
    @CreateDate datetime2(3),
	@DateLastModified datetime2(3),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseUser] AS target
	USING (SELECT @Login, @UserType, @LoginType, @HasDBAccess, @CreateDate, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND [UserName] = @UserName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Login] = @Login, [UserType] = @UserType, [LoginType] = @LoginType, [HasDBAccess] = @HasDBAccess, [CreateDate] = @CreateDate, [DateLastModified] = @DateLastModified, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [DatabaseName], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @DatabaseName, @UserName, @Login, @UserType, @LoginType, @HasDBAccess, @CreateDate, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseUser]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT