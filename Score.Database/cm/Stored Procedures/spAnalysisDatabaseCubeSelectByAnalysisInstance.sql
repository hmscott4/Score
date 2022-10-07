/****************************************************************
* Name: cm.spAnalysisDatabaseCubeSelectByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
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