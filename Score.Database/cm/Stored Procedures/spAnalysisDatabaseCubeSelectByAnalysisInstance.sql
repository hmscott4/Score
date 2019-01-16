/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseCubeSelectByAnalysisInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spAnalysisDatabaseCubeSelectByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisDatabaseCube] 
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO