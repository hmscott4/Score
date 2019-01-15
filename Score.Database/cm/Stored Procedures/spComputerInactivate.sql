/****************************************************************
* Name: cm.spComputerInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerInactivate] 
    @dnsHostName nvarchar(255),
	@IncludeChildObject bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] WHERE [dnsHostName] = @dnsHostName

	UPDATE [cm].[Computer]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @ComputerGUID

	IF @IncludeChildObject = 1
	BEGIN

		UPDATE [cm].[Service]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[ApplicationInstallation]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[DiskDrive]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[LogicalVolume]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[DrivePartitionMap]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[NetworkAdapter]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[NetworkAdapterConfiguration]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[DrivePartitionMap]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[WindowsUpdateInstallation]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[OperatingSystem]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[ClusterNode]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[ComputerShare]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

			UPDATE [cm].[ComputerSharePermission]
			SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
			WHERE [ComputerShareGUID] IN (SELECT [ComputerShareGUID] FROM [cm].[ComputerShare] WHERE [ComputerGUID] = @ComputerGUID)

		UPDATE [cm].[ComputerGroupMember]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

	END

	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [InstallDate], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
