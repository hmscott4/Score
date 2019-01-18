/****************************************************************
* Name: ad.spSyncHistoryDeleteByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
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
