/****** Object:  StoredProcedure [cm].[spOperatingSystemUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spOperatingSystemUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spOperatingSystemUpsert] 
    @dnsHostName nvarchar(255),
    @IPV4Address nvarchar(128) = NULL,
    @Manufacturer nvarchar(255) = NULL,
    @OSArchitecture nvarchar(128) = NULL,
    @OSType nvarchar(128) = NULL,
    @OperatingSystem nvarchar(128) = NULL,
    @Description nvarchar(1024) = NULL,
    @Version nvarchar(128) = NULL,
    @ServicePack nvarchar(128) = NULL,
    @ServicePackMajorVersion int = NULL,
    @ServicePackMinorVersion int = NULL,
    @BootDevice nvarchar(255) = NULL,
    @SystemDevice nvarchar(255) = NULL,
    @WindowsDirectory nvarchar(255) = NULL,
    @SystemDirectory nvarchar(255) = NULL,
    @TotalVisibleMemorySize bigint = NULL,
    @InstallDate datetime2(3) = NULL,
    @LastBootUpTime datetime2(3) = NULL,
    @Status nvarchar(50) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[OperatingSystem] AS target
	USING (SELECT @IPV4Address, @Manufacturer, @OSArchitecture, @OSType, @OperatingSystem, @Description, @Version, @ServicePack, @ServicePackMajorVersion, @ServicePackMinorVersion, @BootDevice, @SystemDevice, @WindowsDirectory, @SystemDirectory, @TotalVisibleMemorySize, @InstallDate, @LastBootUpTime, @Status, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([computerGUID] = @ComputerGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [IPV4Address] = @IPV4Address, [Manufacturer] = @Manufacturer, [OSArchitecture] = @OSArchitecture, [OSType] = @OSType, [OperatingSystem] = @OperatingSystem, [Description] = @Description, [Version] = @Version, [ServicePack] = @ServicePack, [ServicePackMajorVersion] = @ServicePackMajorVersion, [ServicePackMinorVersion] = @ServicePackMinorVersion, [BootDevice] = @BootDevice, [SystemDevice] = @SystemDevice, [WindowsDirectory] = @WindowsDirectory, [SystemDirectory] = @SystemDirectory, [TotalVisibleMemorySize] = @TotalVisibleMemorySize, [InstallDate] = @InstallDate, [LastBootUpTime] = @LastBootUpTime, [Status] = @Status, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([computerGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@computerGUID, @IPV4Address, @Manufacturer, @OSArchitecture, @OSType, @OperatingSystem, @Description, @Version, @ServicePack, @ServicePackMajorVersion, @ServicePackMinorVersion, @BootDevice, @SystemDevice, @WindowsDirectory, @SystemDirectory, @TotalVisibleMemorySize, @InstallDate, @LastBootUpTime, @Status, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[OperatingSystem]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT