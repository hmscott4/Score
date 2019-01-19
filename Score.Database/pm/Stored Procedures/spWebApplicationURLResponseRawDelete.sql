/****************************************************************
* Name: ad.spWebApplicationURLResponseRawDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
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
