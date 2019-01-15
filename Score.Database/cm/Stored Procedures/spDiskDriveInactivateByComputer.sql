/****************************************************************
* Name: cm.spDiskDriveInactivate
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskDriveInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[DiskDrive]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @ComputerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskDrive]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
