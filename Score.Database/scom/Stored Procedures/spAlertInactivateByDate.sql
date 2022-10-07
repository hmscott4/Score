/****************************************************************
* Name: scom.spAlertInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertInactivateByDate]
	@BeforeDate datetime2(3),
	@ManagementGroup nvarchar(255) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE 
	dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) 
	AND Active = 1
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)