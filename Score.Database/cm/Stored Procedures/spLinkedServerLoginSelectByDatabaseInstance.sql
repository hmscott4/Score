/****** Object:  StoredProcedure [cm].[spLinkedServerLoginSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spLinkedServerLoginSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[LinkedServerLogin] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT