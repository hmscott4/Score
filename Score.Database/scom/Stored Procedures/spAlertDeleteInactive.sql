
CREATE PROCEDURE [scom].[spAlertDeleteInactive]

AS

DELETE 
FROM scom.Alert
WHERE Active = 0
