CREATE PROC [cm].[spReportServerSubscriptionParameterSelectBySubscription] 
    @ReportServerSubscriptionGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerSubscriptionParameter] 
	WHERE  [ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID AND [Active] >= @Active

	COMMIT
