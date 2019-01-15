/****************************************************************
* Name: cm.spReportServerSubscriptionInactivateByReportingInstance
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionInactivateByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[ReportServerSubscription]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ReportingInstanceGUID] = @ReportingInstanceGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscription]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
