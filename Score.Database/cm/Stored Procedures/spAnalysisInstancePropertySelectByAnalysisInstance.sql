CREATE PROC [cm].[spAnalysisInstancePropertySelectByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [AnalysisInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisInstanceProperty] 
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
