
CREATE PROC [scom].[spAlertInactivate]

AS

UPDATE scom.Alert
SET [Active] = 0

