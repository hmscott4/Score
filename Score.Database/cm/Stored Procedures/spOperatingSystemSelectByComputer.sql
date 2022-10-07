/****** Object:  StoredProcedure [cm].[spOperatingSystemSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spOperatingSystemSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [computerGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[OperatingSystem] 
	WHERE  ([computerGUID] = @computerGUID) 

	COMMIT