/****************************************************************
* Name: cm.spAnalysisDatabaseSelectByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseSelectByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisDatabase] 
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT