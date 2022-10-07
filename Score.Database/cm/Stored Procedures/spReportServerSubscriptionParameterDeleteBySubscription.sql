/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterDeleteBySubscription]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionParameterDeleteBySubscription
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionParameterDeleteBySubscription]
    @ReportServerSubscriptionGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ReportServerSubscriptionParameter]
	WHERE  [ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID

	COMMIT