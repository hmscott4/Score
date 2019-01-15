/****************************************************************
* Name: cm.spAnalysisDatabaseCubeDeleteByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseCubeDeleteByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[AnalysisDatabaseCube]
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
