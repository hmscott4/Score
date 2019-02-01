/****************************************************************
* Name: scom.spGroupHealthStateInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE [scom].[GroupHealthState]
SET Active = 0
WHERE dbLastUpdate < @BeforeDate 
	AND Active = 1

COMMIT