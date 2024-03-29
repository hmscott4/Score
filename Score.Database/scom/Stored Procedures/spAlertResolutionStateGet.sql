﻿/****************************************************************
* Name: scom.spAlertResolutionStateGet
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertResolutionStateGet]
	@ResolutionState INT = NULL,
	@IsOpen BIT = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT OFF

SELECT 
	ResolutionState, [Name]
FROM 
	scom.AlertResolutionState
WHERE
	Active = 1
	AND (@ResolutionState IS NULL OR ResolutionState = @ResolutionState)
	AND (@IsOpen IS NULL OR IsOpen = @IsOpen)
ORDER BY
	ResolutionState