
/****************************************************************
* Name: scom.spAlertInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertInactivate]
	@ManagementGroup nvarchar(255) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE
	[Active] = 1
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)