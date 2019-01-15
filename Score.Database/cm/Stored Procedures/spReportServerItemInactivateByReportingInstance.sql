/****************************************************************
* Name: cm.spReportServerItemInactivateByReportingInstance
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerItemInactivateByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[ReportServerItem]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ReportingInstanceGUID] = @reportingInstanceGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerItem]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
