/****************************************************************
* Name: scom.spGroupHealthStateInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE [scom].[GroupHealthState]
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE,-15,@BeforeDate)
	AND Active = 1

COMMIT

GO

GRANT EXEC ON [scom].[spGroupHealthStateInactivateByDate] TO [scomUpdate]
GO