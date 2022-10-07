/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionSelectByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spReportServerSubscriptionSelectByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerSubscription] 
	WHERE  ([ReportingInstanceGUID] = @ReportingInstanceGUID AND [Active] = @Active) 

	COMMIT