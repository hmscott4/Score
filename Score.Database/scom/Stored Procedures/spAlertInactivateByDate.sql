
CREATE PROC [scom].[spAlertInactivateByDate]
	@BeforeDate datetime2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE dbLastUpdate < @BeforeDate AND Active = 1