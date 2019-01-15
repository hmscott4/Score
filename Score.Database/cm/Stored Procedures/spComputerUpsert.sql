/****************************************************************
* Name: cm.spComputerUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerUpsert] 
    @Domain nvarchar(128),
    @dnsHostName nvarchar(255),
    @netBIOSName nvarchar(255),
    @IPv4Address nvarchar(128) = NULL,
    @DomainRole nvarchar(128) = NULL,
    @CurrentTimeZone int = NULL,
    @DaylightInEffect bit = NULL,
    @Status nvarchar(50) = NULL,
    @Manufacturer nvarchar(128) = NULL,
    @Model nvarchar(128) = NULL,
	@PCSystemType nvarchar(128) = NULL,
	@SystemType nvarchar(128) = NULL,
    @AssetTag nvarchar(128) = NULL,
    @SerialNumber nvarchar(128) = NULL,
    @TotalPhysicalMemory bigint = NULL,
    @NumberOfLogicalProcessors int = NULL,
    @NumberOfProcessors int = NULL,
    @IsVirtual bit,
    @PendingReboot bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Computer] AS target
	USING (SELECT @Domain, @netBIOSName, @IPv4Address, @DomainRole, @CurrentTimeZone, @DaylightInEffect, @Status, @Manufacturer, @Model, @PCSystemType, @SystemType, @AssetTag, @SerialNumber, @TotalPhysicalMemory, @NumberOfLogicalProcessors, @NumberOfProcessors, @IsVirtual, @PendingReboot, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [SystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [PendingReboot], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([dnsHostName] = @dnsHostName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [netBIOSName] = @netBIOSName, [IPv4Address] = @IPv4Address, [DomainRole] = @DomainRole, [CurrentTimeZone] = @CurrentTimeZone, [DaylightInEffect] = @DaylightInEffect, [Status] = @Status, [Manufacturer] = @Manufacturer, [Model] = @Model, [PCSystemType] = @PCSystemType, [SystemType] = @SystemType, [AssetTag] = @AssetTag, [SerialNumber] = @SerialNumber, [TotalPhysicalMemory] = @TotalPhysicalMemory, [NumberOfLogicalProcessors] = @NumberOfLogicalProcessors, [NumberOfProcessors] = @NumberOfProcessors, [IsVirtual] = @IsVirtual, [PendingReboot] = @PendingReboot, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [SystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [PendingReboot], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @dnsHostName, @netBIOSName, @IPv4Address, @DomainRole, @CurrentTimeZone, @DaylightInEffect, @Status, @Manufacturer, @Model, @PCSystemType, @SystemType, @AssetTag, @SerialNumber, @TotalPhysicalMemory, @NumberOfLogicalProcessors, @NumberOfProcessors, @IsVirtual, @PendingReboot, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
