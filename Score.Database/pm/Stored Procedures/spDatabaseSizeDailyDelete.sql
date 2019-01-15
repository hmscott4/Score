CREATE PROC [pm].[spDatabaseSizeDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[DatabaseSizeDaily]
WHERE [Date] < DateAdd(Day,-@DaysRetain,@CurrentDate)

COMMIT
