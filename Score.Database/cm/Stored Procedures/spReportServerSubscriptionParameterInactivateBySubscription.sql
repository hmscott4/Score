/****************************************************************
* Name: cm.spReportServerSubscriptionParameterInactivateBySubscription
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionParameterInactivateBySubscription] 
    @ReportServerSubscriptionGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[ReportServerSubscriptionParameter]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscriptionParameter]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
