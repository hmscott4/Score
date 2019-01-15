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
