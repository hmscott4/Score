CREATE PROC [pm].[spLogicalVolumeSizeDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[LogicalVolumeSizeDaily]
WHERE [Date] < DateAdd(Day,-@DaysRetain,@CurrentDate)

COMMIT
