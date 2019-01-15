CREATE PROC [pm].[spDatabaseSizeRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime2
SET @CurrentDate = GetDate()

DELETE FROM [pm].[DatabaseSizeRaw]
WHERE [DateTime] < DateAdd(Day,-@DaysRetain,@CurrentDate)

COMMIT
