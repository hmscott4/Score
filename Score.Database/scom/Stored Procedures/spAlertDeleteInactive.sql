/****** Object:  StoredProcedure [scom].[spAlertDeleteInactive]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROCEDURE [scom].[spAlertDeleteInactive]

AS

DELETE 
FROM scom.Alert
WHERE Active = 0
GO