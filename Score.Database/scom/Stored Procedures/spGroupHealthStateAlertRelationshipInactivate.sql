/****************************************************************
* Name: scom.spGroupHealthStateAlertRelationshipInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateAlertRelationshipInactivate] 

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

update scom.[GroupHealthStateAlertRelationship]
Set Active = b.Active
FROM scom.[GroupHealthStateAlertRelationship] inner join scom.Alert b
	on scom.[GroupHealthStateAlertRelationship].AlertID = b.AlertId

COMMIT