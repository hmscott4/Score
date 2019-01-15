/****************************************************************
* Name: cm.spAnalysisDatabaseUpsert
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseUpsert] 
    @AnalysisInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @Description nvarchar(1024) = NULL,
    @UpdateAbility nvarchar(128),
    @EstimatedSize bigint,
    @CreateDate datetime2(3),
    @LastProcessedDate datetime2(3) = NULL,
    @LastSchemaUpdate datetime2(3) = NULL,
    @Collation nvarchar(128),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[AnalysisDatabase] AS target
	USING (SELECT @Description, @UpdateAbility, @EstimatedSize, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([AnalysisInstanceGUID] = @AnalysisInstanceGUID AND [DatabaseName] = @DatabaseName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [UpdateAbility] = @UpdateAbility, [EstimatedSize] = @EstimatedSize, [CreateDate] = @CreateDate, [LastProcessedDate] = @LastProcessedDate, [LastSchemaUpdate] = @LastSchemaUpdate, [Collation] = @Collation, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@AnalysisInstanceGUID, @DatabaseName, @Description, @UpdateAbility, @EstimatedSize, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabase]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
