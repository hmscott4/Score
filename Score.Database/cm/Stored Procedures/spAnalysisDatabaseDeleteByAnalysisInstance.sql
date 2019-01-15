/****************************************************************
* Name: cm.spAnalysisDatabaseDeleteByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseDeleteByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[AnalysisDatabase]
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
