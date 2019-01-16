/****** Object:  StoredProcedure [scom].[spAgentAvailabilityUpdate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spAgentAvailabilityUpdate] (
	@DisplayName nvarchar(255),
	@IsAvailable bit,
	@AvailabilityLastModified datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.Agent
SET IsAvailable = @IsAvailable, AvailabilityLastModified = @AvailabilityLastModified
WHERE DisplayName = @DisplayName

COMMIT

GO