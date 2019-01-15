/****************************************************************
* Name: cm.spDrivePartitionMapUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDrivePartitionMapUpsert] 
    @dnsHostName nvarchar(255),
    @PartitionName nvarchar(128),
    @DriveName nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[DrivePartitionMap] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [PartitionName] = @PartitionName AND [DriveName] = @DriveName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @PartitionName, @DriveName, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ObjectGUID], [ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DrivePartitionMap]
	WHERE  [ObjectGUID] = @ObjectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
