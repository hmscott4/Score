/****************************************************************
* Name: scom.spAgentAvailabilityUpdate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAgentAvailabilityUpdate] (
	@DisplayName nvarchar(255),
	@IsAvailable bit,
	@AvailabilityLastModified datetimeoffset(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.Agent
SET IsAvailable = @IsAvailable, AvailabilityLastModified = @AvailabilityLastModified
WHERE DisplayName = @DisplayName

COMMIT