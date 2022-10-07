/****** Object:  StoredProcedure [cm].[spDiskPartitionUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskPartitionUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskPartitionUpsert] 
    @dnsHostName nvarchar(255),
    @Name nvarchar(255),
    @DiskIndex int,
    @Index int,
    @DeviceID nvarchar(255),
    @Bootable bit,
    @BootPartition bit,
    @PrimaryPartition bit,
    @StartingOffset bigint = NULL,
    @Size bigint,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[DiskPartition] AS target
	USING (SELECT @DiskIndex, @Index, @DeviceID, @Bootable, @BootPartition, @PrimaryPartition, @StartingOffset, @Size, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DiskIndex] = @DiskIndex, [Index] = @Index, [DeviceID] = @DeviceID, [Bootable] = @Bootable, [BootPartition] = @BootPartition, [PrimaryPartition] = @PrimaryPartition, [StartingOffset] = @StartingOffset, [Size] = @Size, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate])		
		VALUES (@ComputerGUID, @Name, @DiskIndex, @Index, @DeviceID, @Bootable, @BootPartition, @PrimaryPartition, @StartingOffset, @Size, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskPartition]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT