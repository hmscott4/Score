
/****** Object:  StoredProcedure [ad].[spSyncHistoryDeleteByDate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spSyncHistoryDeleteByDate]
	@DaysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM [ad].[SyncHistory]
      WHERE [EndDate] < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT
GO
GRANT EXECUTE ON [ad].[spSyncHistoryDeleteByDate] TO [adUpdate] AS [dbo]
GO
