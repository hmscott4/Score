/****** Object:  StoredProcedure [cm].[spDiskDriveUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskDriveUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskDriveUpsert] 
	@dnsHostName nvarchar(255),
    @Name nvarchar(128),
    @DeviceID nvarchar(128),
    @Manufacturer nvarchar(255) = NULL,
    @Model nvarchar(255) = NULL,
    @SerialNumber nvarchar(128) = NULL,
    @FirmwareRevision nvarchar(128) = NULL,
    @Partitions int = NULL,
    @InterfaceType nvarchar(128),
    @SCSIBus int = NULL,
    @SCSIPort int = NULL,
    @SCSILogicalUnit int = NULL,
    @SCSITargetID int = NULL,
	@Size bigint,
    @Status nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[DiskDrive] AS target
	USING (SELECT @DeviceID, @Manufacturer, @Model, @SerialNumber, @FirmwareRevision, @Partitions, @InterfaceType, @SCSIBus, @SCSIPort, @SCSILogicalUnit, @SCSITargetID, @Size, @Status, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Size], [Status], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DeviceID] = @DeviceID, [Manufacturer] = @Manufacturer, [Model] = @Model, [SerialNumber] = @SerialNumber, [FirmwareRevision] = @FirmwareRevision, [Partitions] = @Partitions, [InterfaceType] = @InterfaceType, [SCSIBus] = @SCSIBus, [SCSIPort] = @SCSIPort, [SCSILogicalUnit] = @SCSILogicalUnit, [SCSITargetID] = @SCSITargetID, [Size] = @Size, [Status] = @Status, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Size], [Status], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @DeviceID, @Manufacturer, @Model, @SerialNumber, @FirmwareRevision, @Partitions, @InterfaceType, @SCSIBus, @SCSIPort, @SCSILogicalUnit, @SCSITargetID, @Size, @Status, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Size], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskDrive]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT