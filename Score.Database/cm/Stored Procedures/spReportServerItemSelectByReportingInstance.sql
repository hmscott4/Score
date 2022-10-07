/****** Object:  StoredProcedure [cm].[spReportServerItemSelectByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spReportServerItemSelectByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerItem] 
	WHERE  ([ReportingInstanceGUID] = @ReportingInstanceGUID AND [Active] >= @Active) 

	COMMIT