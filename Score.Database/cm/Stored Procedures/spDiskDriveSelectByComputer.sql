/****** Object:  StoredProcedure [cm].[spDiskDriveSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDiskDriveSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Status], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DiskDrive] 
	WHERE  ([ComputerGUID] = @computerGUID AND [Active] >= @Active) 

	COMMIT