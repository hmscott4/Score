/****** Object:  StoredProcedure [scom].[spObjectAlertRelationshipInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/
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