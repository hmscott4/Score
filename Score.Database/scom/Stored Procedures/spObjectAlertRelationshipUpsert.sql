/****************************************************************
* Name: scom.spObjectAlertRelationshipUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectAlertRelationshipUpsert] (
	@ObjectID uniqueidentifier,
	@AlertID uniqueidentifier
)
AS
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	IF EXISTS (SELECT 1 FROM scom.ObjectAlertRelationship WHERE ObjectID = @ObjectID AND AlertID = @AlertID)
	BEGIN

		UPDATE scom.ObjectAlertRelationship 
		SET Active = 1, dbLastUpdate = GetDate()
		WHERE ObjectID = @ObjectID AND AlertID = @AlertID

	END

	ELSE

	BEGIN

		INSERT INTO scom.ObjectAlertRelationship (ObjectID, AlertID, Active, dbAddDate, dbLastUpdate)
		VALUES (@ObjectID, @AlertID, 1, GetDate(), GetDate())

	END
GO
