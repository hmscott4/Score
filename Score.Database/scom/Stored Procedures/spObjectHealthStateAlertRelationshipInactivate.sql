/****************************************************************
* Name: scom.spObjectAlertRelationshipInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateAlertRelationshipInactivate] 

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

update scom.[ObjectHealthStateAlertRelationship]
SET Active = b.Active
FROM scom.[ObjectHealthStateAlertRelationship] inner join scom.Alert b
	ON scom.[ObjectHealthStateAlertRelationship].AlertID = b.AlertId

COMMIT

GO


GO