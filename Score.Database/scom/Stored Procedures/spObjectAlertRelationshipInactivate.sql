/****************************************************************
* Name: scom.spObjectAlertRelationshipInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectAlertRelationshipInactivate] 

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

update scom.ObjectAlertRelationship
Set Active = b.Active
FROM scom.ObjectAlertRelationship inner join scom.Alert b
	on scom.ObjectAlertRelationship.AlertID = b.AlertId

COMMIT
GO