/****** Object:  StoredProcedure [cm].[spReportingInstanceSelectByServiceState]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spReportingInstanceSelectByServiceState] 
    @ServiceState nvarchar(128),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportingInstance] 
	WHERE  ([ServiceState] = @ServiceState AND [Active] >= @Active)

	COMMIT