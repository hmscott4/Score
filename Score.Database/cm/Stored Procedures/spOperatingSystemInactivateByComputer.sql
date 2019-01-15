/****************************************************************
* Name: cm.spOperatingSystemInactivateByComputer
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spOperatingSystemInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[OperatingSystem]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @computerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[OperatingSystem]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
