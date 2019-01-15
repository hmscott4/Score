CREATE PROC [cm].[spDatabaseUserSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseUser] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
