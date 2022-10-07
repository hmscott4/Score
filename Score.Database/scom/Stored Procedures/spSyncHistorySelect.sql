
CREATE PROC [scom].[spSyncHistorySelect] 
    @ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [scom].[SyncHistory] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT