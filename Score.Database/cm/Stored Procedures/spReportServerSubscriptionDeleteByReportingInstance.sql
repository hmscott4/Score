/****************************************************************
* Name: cm.spReportServerSubscriptionDeleteByReportingInstance
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionDeleteByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ReportServerSubscription]
	WHERE  [ReportingInstanceGUID] = @ReportingInstanceGUID

	COMMIT
