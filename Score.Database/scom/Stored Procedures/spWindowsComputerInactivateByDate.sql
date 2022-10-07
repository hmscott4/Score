/****************************************************************
* Name: scom.spWindowsComputerInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spWindowsComputerInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.WindowsComputer
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) AND Active = 1

COMMIT