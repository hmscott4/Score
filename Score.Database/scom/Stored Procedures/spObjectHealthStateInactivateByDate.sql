/****************************************************************
* Name: scom.spObjectInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
* Inactivate objects that were not updated in the most recent pass.
* Used only during full sync.
* Modified to subtract 15 minutes from last update.
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateInactivateByDate] (
	@BeforeDate datetime2(3),
	@ObjectClass nvarchar(255),
	@ManagementGroup nvarchar(255) = NULL
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.[ObjectHealthState]
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate)
	AND Active = 1
	AND ObjectClass = @ObjectClass
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)

COMMIT