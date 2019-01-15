/****************************************************************
* Name: cm.spDatabaseFileUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseFileUpsert] 
    @DatabaseGUID uniqueidentifier,
    @FileID int,
    @FileGroup nvarchar(255),
    @LogicalName nvarchar(255),
    @PhysicalName nvarchar(2048),
    @FileSize bigint,
    @MaxSize bigint,
    @SpaceUsed bigint,
    @Growth bigint,
    @GrowthType nvarchar(128),
    @IsReadOnly bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseFile] AS target
	USING (SELECT  @FileGroup, @LogicalName, @PhysicalName, @FileSize, @MaxSize, @SpaceUsed, @Growth, @GrowthType, @IsReadOnly, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		( [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseGUID] = @DatabaseGUID AND [FileID] = @FileID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [FileGroup] = @FileGroup, [LogicalName] = @LogicalName, [PhysicalName] = @PhysicalName, [FileSize] = @FileSize, [MaxSize] = @MaxSize, [SpaceUsed] = @SpaceUsed, [Growth] = @Growth, [GrowthType] = @GrowthType, [IsReadOnly] = @IsReadOnly, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseGUID, @FileID, @FileGroup, @LogicalName, @PhysicalName, @FileSize, @MaxSize, @SpaceUsed, @Growth, @GrowthType, @IsReadOnly, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseFile]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
