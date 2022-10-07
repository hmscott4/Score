/****** Object:  StoredProcedure [cm].[spDiskPartitionSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDiskPartitionSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DiskPartition] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT