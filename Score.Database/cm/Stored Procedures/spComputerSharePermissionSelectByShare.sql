CREATE PROC [cm].[spComputerSharePermissionSelectByShare] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ComputerShareGUID uniqueidentifier
	SELECT @ComputerShareGUID = [objectGUID]
	FROM [cm].[ComputerShare]
	WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @ShareName

	SELECT [objectGUID], [ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ComputerSharePermission] 
	WHERE  ([ComputerShareGUID] = @computerShareGUID AND [Active] >= @Active) 

	COMMIT
