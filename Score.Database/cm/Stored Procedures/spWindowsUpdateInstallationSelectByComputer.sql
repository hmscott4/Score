/****************************************************************
* Name: cm.spWindowsUpdateInstallationSelectByComputer
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WindowsUpdateInstallation] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT