/****************************************************************
* Name: ad.spDatabaseSizeDailyDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spDatabaseSizeDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[DatabaseSizeDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
GRANT EXECUTE ON [pm].[spDatabaseSizeDailyDelete] TO [pmUpdate] AS [dbo]
GO
