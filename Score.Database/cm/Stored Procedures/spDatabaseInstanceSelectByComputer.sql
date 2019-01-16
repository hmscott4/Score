/****** Object:  StoredProcedure [cm].[spDatabaseInstanceSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseInstanceSelectByComputer] 
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
	FROM   [cm].[DatabaseInstance] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByComputer] TO [adRead] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByComputer] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByComputer] TO [cmUpdate] AS [dbo]
GO
GRANT EXECUTE ON [cm].[spDatabaseInstanceSelectByComputer] TO [pmRead] AS [dbo]
GO
