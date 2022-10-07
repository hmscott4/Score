/****************************************************************
* Name: cm.spWindowsUpdateInstallationInactivateByComputer
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[WindowsUpdateInstallation]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @ComputerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdateInstallation]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT