/****************************************************************
* Name: cm.spComputerSharePermissionDeleteByShare
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSharePermissionDeleteByShare] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255)
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

	DELETE
	FROM   [cm].[ComputerSharePermission]
	WHERE  [ComputerShareGUID] = @computerShareGUID

	COMMIT
