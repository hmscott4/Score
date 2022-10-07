/****** Object:  StoredProcedure [cm].[spLinkedServerSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spLinkedServerSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[LinkedServer] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT