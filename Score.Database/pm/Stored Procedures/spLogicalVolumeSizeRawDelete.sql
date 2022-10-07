/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeRawDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spLogicalVolumeSizeRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime2
SET @CurrentDate = GetDate()

DELETE FROM [pm].[LogicalVolumeSizeRaw]
WHERE [DateTime] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT