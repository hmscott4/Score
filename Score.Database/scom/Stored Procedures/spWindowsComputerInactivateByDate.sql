/****** Object:  StoredProcedure [scom].[spWindowsComputerInactivateByDate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spWindowsComputerInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.WindowsComputer
SET Active = 0
WHERE dbLastUpdate < @BeforeDate AND Active = 1

COMMIT
GO