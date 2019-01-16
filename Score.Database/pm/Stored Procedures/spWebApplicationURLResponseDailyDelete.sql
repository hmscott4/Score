/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseDailyDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spWebApplicationURLResponseDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
GRANT EXECUTE ON [pm].[spWebApplicationURLResponseDailyDelete] TO [pmUpdate] AS [dbo]
GO
