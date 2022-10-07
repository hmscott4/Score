/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeDailyDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spLogicalVolumeSizeDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[LogicalVolumeSizeDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT