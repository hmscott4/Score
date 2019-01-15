CREATE PROC [cm].[spOperatingSystemSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[OperatingSystem] 
	WHERE  ([ComputerGUID] = @computerGUID) 

	COMMIT
