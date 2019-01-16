
/****** Object:  StoredProcedure [ad].[spSyncHistorySelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spSyncHistorySelect] 
    @ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [ad].[SyncHistory] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT
GO
GRANT EXECUTE ON [ad].[spSyncHistorySelect] TO [adUpdate] AS [dbo]
GO
