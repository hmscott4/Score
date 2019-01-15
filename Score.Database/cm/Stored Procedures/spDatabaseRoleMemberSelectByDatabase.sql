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
