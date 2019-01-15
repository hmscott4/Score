/****************************************************************
* Name: cm.spAnalysisDatabaseCubeUpsert
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseCubeUpsert] 
    @AnalysisInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @CubeName nvarchar(128),
    @Description nvarchar(1024) = NULL,
    @CreateDate datetime2(3),
    @LastProcessedDate datetime2(3) = NULL,
    @LastSchemaUpdate datetime2(3) = NULL,
    @Collation nvarchar(128),
	@StorageLocation nvarchar(255),
	@StorageMode nvarchar(128),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[AnalysisDatabaseCube] AS target
	USING (SELECT @Description, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @StorageLocation, @StorageMode, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([AnalysisInstanceGUID] = @AnalysisInstanceGUID AND [DatabaseName] = @DatabaseName AND [CubeName] = @CubeName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [CreateDate] = @CreateDate, [LastProcessedDate] = @LastProcessedDate, [LastSchemaUpdate] = @LastSchemaUpdate, [Collation] = @Collation, [StorageLocation] = @StorageLocation, [StorageMode] = @StorageMode, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([AnalysisInstanceGUID], [DatabaseName], [CubeName], [Description],[CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@AnalysisInstanceGUID, @DatabaseName, @CubeName, @Description, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @StorageLocation, @StorageMode, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabaseCube]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
