/****************************************************************
* Name: scom.spAlertDeleteInactive
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [scom].[spAlertDeleteInactive]

AS

DELETE 
FROM scom.Alert
WHERE Active = 0
GO