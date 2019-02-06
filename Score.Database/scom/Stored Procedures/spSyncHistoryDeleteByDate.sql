/****************************************************************
* Name: scom.spSyncHistoryDeleteByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
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


GRANT EXEC ON [scom].[spSyncHistoryDeleteByDate] TO [scomUpdate]
GO