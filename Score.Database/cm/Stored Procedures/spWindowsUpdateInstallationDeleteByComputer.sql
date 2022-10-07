/****************************************************************
* Name: cm.spWindowsUpdateInstallationDeleteByComputer
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[WindowsUpdateInstallation]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT