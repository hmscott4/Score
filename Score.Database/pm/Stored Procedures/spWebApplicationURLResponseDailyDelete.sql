/****************************************************************
* Name: ad.spWebApplicationURLResponseDailyDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spWebApplicationURLResponseDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT