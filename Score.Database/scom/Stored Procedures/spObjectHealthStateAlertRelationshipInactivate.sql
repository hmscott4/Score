﻿/****************************************************************
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
Set Active = b.Active
FROM scom.[ObjectHealthStateAlertRelationship] inner join scom.Alert b
	on scom.[ObjectHealthStateAlertRelationship].AlertID = b.AlertId

COMMIT