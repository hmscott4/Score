/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseRawDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spWebApplicationURLResponseRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseRaw]
WHERE [DateTime] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
GRANT EXECUTE ON [pm].[spWebApplicationURLResponseRawDelete] TO [pmUpdate] AS [dbo]
GO
