CREATE PROC [cm].[spAnalysisInstanceSelectByServiceState] 
    @ServiceState nvarchar(128),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisInstance] 
	WHERE  ([ServiceState] = @ServiceState AND [Active] >= @Active)

	COMMIT
