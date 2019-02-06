/****************************************************************
* Name: scom.spGroupHealthStateAlertRelationshipUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateAlertRelationshipUpsert] (
	@GroupID UNIQUEIDENTIFIER,
	@AlertID UNIQUEIDENTIFIER
)
AS
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	IF EXISTS (SELECT 1 FROM scom.[GroupHealthStateAlertRelationship] WHERE GroupID = @GroupID AND AlertID = @AlertID)
	BEGIN

		UPDATE scom.[GroupHealthStateAlertRelationship] 
		SET Active = 1, dbLastUpdate = GetDate()
		WHERE GroupID = @GroupID AND AlertID = @AlertID

	END

	ELSE

	BEGIN

		INSERT INTO scom.[GroupHealthStateAlertRelationship] (GroupID, AlertID, Active, dbAddDate, dbLastUpdate)
		VALUES (@GroupID, @AlertID, 1, GetDate(), GetDate())

	END

GO


GRANT EXEC ON [scom].[spGroupHealthStateAlertRelationshipUpsert] TO [scomUpdate]
GO