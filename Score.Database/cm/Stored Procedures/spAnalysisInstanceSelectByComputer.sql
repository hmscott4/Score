CREATE PROC [cm].[spAnalysisInstanceSelectByComputer]  
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

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisInstance] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active)

	COMMIT
