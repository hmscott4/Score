/****** Object:  StoredProcedure [cm].[spDatabaseInstanceSelectByServiceState]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spDatabaseInstanceSelectByServiceState] 
    @ServiceState nvarchar(128),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseInstance] 
	WHERE  ([ServiceState] = @ServiceState AND [Active] >= @Active ) 

	COMMIT
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByServiceState] TO [adRead] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByServiceState] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByServiceState] TO [cmUpdate] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByServiceState] TO [pmRead] AS [dbo]
GO
