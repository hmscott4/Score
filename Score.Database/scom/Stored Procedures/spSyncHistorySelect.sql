/****** Object:  StoredProcedure [scom].[spSyncHistorySelect]    Script Date: 1/16/2019 8:32:48 AM ******/

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

GO