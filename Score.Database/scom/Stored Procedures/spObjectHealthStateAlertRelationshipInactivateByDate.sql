/****************************************************************
* Name: scom.spObjectAlertRelationshipInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateAlertRelationshipInactivateByDate] (
	@BeforeDate datetimeoffset(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

UPDATE scom.[ObjectHealthStateAlertRelationship]
SET Active = 0
WHERE dbLastUpdate < DateAdd(Minute, -15, @BeforeDate )
	AND Active = 1

COMMIT