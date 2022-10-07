/****************************************************************
* Name: cm.spAnalysisInstanceInactivate
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceInactivate]  
    @AnalysisInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[AnalysisInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate, ServiceState = N'Removed'
	WHERE  ([objectGUID] = @AnalysisInstanceGUID)

	IF @IncludeChildObjects = 1
	BEGIN

		UPDATE [cm].[AnalysisDatabase]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID)

		UPDATE [cm].[AnalysisDatabaseCube]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID)

		UPDATE [cm].[AnalysisInstanceProperty]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID)

	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT