/****************************************************************
* Name: cm.spLinkedServerInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerInactivateByDatabaseInstance]  
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[LinkedServer]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
