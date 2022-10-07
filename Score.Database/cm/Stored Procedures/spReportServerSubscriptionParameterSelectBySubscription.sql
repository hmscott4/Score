/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterSelectBySubscription]    Script Date: 1/16/2019 8:32:48 AM ******/
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