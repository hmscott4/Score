/****************************************************************
* Name: cm.spReportServerItemDeleteByReportingInstance
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerItemDeleteByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ReportServerItem]
	WHERE  [ReportingInstanceGUID] = @reportingInstanceGUID 

	COMMIT
