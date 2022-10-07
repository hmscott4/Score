CREATE PROC [ad].[spSyncHistoryDeleteByDate]
	@DaysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM [ad].[SyncHistory]
      WHERE [EndDate] < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT