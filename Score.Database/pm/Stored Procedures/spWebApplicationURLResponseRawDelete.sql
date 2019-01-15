CREATE PROC [pm].[spWebApplicationURLResponseRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseRaw]
WHERE [DateTime] < DateAdd(Day,-@DaysRetain,@CurrentDate)

COMMIT
