/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseInactivateByAnalysisInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spAnalysisDatabaseInactivateByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseInactivateByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[AnalysisDatabase]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabase]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO