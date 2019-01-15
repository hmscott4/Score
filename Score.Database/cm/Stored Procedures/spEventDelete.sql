/****************************************************************
* Name: cm.spEventDelete
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventDelete] 
    @daysRetain int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @CurrentDate datetime2
	SET @CurrentDate = CURRENT_TIMESTAMP

	DELETE
	FROM   [cm].[Event]
	WHERE  [TimeGenerated] < DATEADD(DAY, -@DaysRetain, @CurrentDate)

	COMMIT
