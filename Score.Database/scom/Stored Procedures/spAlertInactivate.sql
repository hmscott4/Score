/****************************************************************
* Name: scom.spAlertInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertInactivate]

AS

UPDATE scom.Alert
SET [Active] = 0

GO


GRANT EXEC ON [scom].[spAlertInactivate] TO scomUpdate
GO