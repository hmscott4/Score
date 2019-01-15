CREATE PROC [cm].[spReportingInstanceSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportingInstance] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
