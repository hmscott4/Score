/****** Object:  StoredProcedure [scom].[spAlertInactivateByDate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spAlertInactivateByDate]
	@BeforeDate datetime2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE dbLastUpdate < @BeforeDate AND Active = 1
GO