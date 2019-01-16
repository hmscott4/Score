/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberSelectByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseRoleMemberSelectByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseRoleMember] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)

	COMMIT
GO
GRANT EXECUTE ON [cm].[spDatabaseRoleMemberSelectByDatabase] TO [adRead] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseRoleMemberSelectByDatabase] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseRoleMemberSelectByDatabase] TO [cmUpdate] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseRoleMemberSelectByDatabase] TO [pmRead] AS [dbo]
GO
