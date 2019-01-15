/****************************************************************
* Name: cm.spLogicalVolumeUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLogicalVolumeUpsert] 
    @dnsHostName nvarchar(255),
    @Name nvarchar(128),
    @DriveLetter nvarchar(128) = NULL,
    @Label nvarchar(128) = NULL,
    @FileSystem nvarchar(128),
    @BlockSize int,
	@SerialNumber nvarchar(128),
    @Capacity bigint,
	@SpaceUsed bigint,
	@SystemVolume bit,
	@IsClustered bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[LogicalVolume] AS target
	USING (SELECT @DriveLetter, @Label, @FileSystem, @BlockSize, @SerialNumber, @Capacity, @SpaceUsed, @SystemVolume, @IsClustered, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUSed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name) 
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DriveLetter] = @DriveLetter, [Label] = @Label, [FileSystem] = @FileSystem, [BlockSize] = @BlockSize, [SerialNumber] = @SerialNumber, [Capacity] = @Capacity, [SpaceUsed] = @SpaceUsed, [SystemVolume] = @SystemVolume, [IsClustered] = @IsClustered, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUsed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @DriveLetter, @Label, @FileSystem, @BlockSize, @SerialNumber, @Capacity, @SpaceUsed, @SystemVolume, @IsClustered, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUsed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LogicalVolume]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
