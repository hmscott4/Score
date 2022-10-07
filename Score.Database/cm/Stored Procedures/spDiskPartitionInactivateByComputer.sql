/****** Object:  StoredProcedure [cm].[spDiskPartitionInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskPartitionInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskPartitionInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[DiskPartition]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskPartition]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT