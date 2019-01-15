/****************************************************************
* Name: cm.spComputerSharePermissionInactivateByShare
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSharePermissionInactivateByShare] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255),
    @dbLastUpdate datetime2(3)
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
	
	UPDATE [cm].[ComputerSharePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerShareGUID] = @computerShareGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerSharePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
