/****** Object:  StoredProcedure [scom].[spSyncHistoryDeleteByDate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spSyncHistoryDeleteByDate]
	@DaysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM [scom].[SyncHistory]
      WHERE [EndDate] < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT

GO