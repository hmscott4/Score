
CREATE PROC [scom].[spSyncHistoryDeleteByDate]
	@DaysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM [scom].[SyncHistory]
      WHERE [EndDate] < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT