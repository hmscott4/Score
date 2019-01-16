/****** Object:  StoredProcedure [scom].[spObjectAlertRelationshipInactivateByDate]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [scom].[spObjectAlertRelationshipInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

UPDATE scom.ObjectAlertRelationship
SET Active = 0
WHERE dbLastUpdate < @BeforeDate 
	AND Active = 1

COMMIT
GO