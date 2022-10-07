/****** Object:  StoredProcedure [cm].[spLinkedServerUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @ID int,
    @Name nvarchar(255),
    @DataSource nvarchar(255),
    @Catalog nvarchar(255) = NULL,
    @ProductName nvarchar(255) = NULL,
    @Provider nvarchar(255) = NULL,
    @ProviderString nvarchar(1024) = NULL,
    @DistPublisher bit,
    @Distributor bit,
    @Publisher bit,
    @Subscriber bit,
    @Rpc bit,
    @RpcOut bit,
    @DataAccess bit,
    @DateLastModified datetime2(3),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[LinkedServer] AS target
	USING (SELECT @Name, @DataSource, @Catalog, @ProductName, @Provider, @ProviderString, @DistPublisher, @Distributor, @Publisher, @Subscriber, @Rpc, @RpcOut, @DataAccess, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [ID] = @ID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Name] = @Name, [DataSource] = @DataSource, [Catalog2] = @Catalog, [ProductName] = @ProductName, [Provider] = @Provider, [ProviderString] = @ProviderString, [DistPublisher] = @DistPublisher, [Distributor] = @Distributor, [Publisher] = @Publisher, [Subscriber] = @Subscriber, [Rpc] = @Rpc, [RpcOut] = @RpcOut, [DataAccess] = @DataAccess, [DateLastModified] = @DateLastModified, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @ID, @Name, @DataSource, @Catalog, @ProductName, @Provider, @ProviderString, @DistPublisher, @Distributor, @Publisher, @Subscriber, @Rpc, @RpcOut, @DataAccess, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT