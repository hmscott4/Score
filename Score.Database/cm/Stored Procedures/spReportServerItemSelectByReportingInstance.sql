CREATE PROC [cm].[spReportServerItemSelectByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerItem] 
	WHERE  ([ReportingInstanceGUID] = @reportingInstanceGUID AND [Active] >= @Active) 

	COMMIT
