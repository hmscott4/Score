/****************************************************************
* Name: scom.spAlertInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertInactivateByDate]
	@BeforeDate datetimeoffset(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) AND Active = 1
GO


GRANT EXEC ON [scom].[spAlertInactivateByDate] TO scomUpdate
GO