/****************************************************************
* Name: ad.spSyncHistorySelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
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
