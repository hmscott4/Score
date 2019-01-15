CREATE PROC [pm].[spWebApplicationURLResponseDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseDaily]
WHERE [Date] < DateAdd(Day,-@DaysRetain,@CurrentDate)

COMMIT
