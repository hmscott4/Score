/****************************************************************
* Name: cm.spAnalysisInstancePropertyInactivateByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertyInactivateByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[AnalysisInstanceProperty]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstanceProperty]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT