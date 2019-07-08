/****************************************************************
* Name: dbo.spCurrentTimeZoneOffsetUpdate
* Author: huscott
* Date: 2019-07-02
*
* Description:
*
****************************************************************/
CREATE PROCEDURE dbo.spCurrentTimeZoneOffsetUpdate

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE dbo.Config
SET ConfigValue = (
	SELECT CurrentUTCOffset 
	FROM dbo.SystemTimeZone
	WHERE DisplayName = (SELECT ConfigValue FROM dbo.Config WHERE ConfigName = N'DefaultTimeZoneDisplayName')
)
WHERE ConfigName = N'DefaultTimeZoneCurrentOffset'

COMMIT