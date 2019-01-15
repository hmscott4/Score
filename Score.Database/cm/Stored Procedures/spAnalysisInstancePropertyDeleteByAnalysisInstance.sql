/****************************************************************
* Name: cm.spAnalysisInstancePropertyDeleteByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertyDeleteByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[AnalysisInstanceProperty]
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
