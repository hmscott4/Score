/****** Object:  StoredProcedure [scom].[spAlertInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spAlertInactivate]

AS

UPDATE scom.Alert
SET [Active] = 0

GO
