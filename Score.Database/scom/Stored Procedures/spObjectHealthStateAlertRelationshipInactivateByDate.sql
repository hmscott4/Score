﻿/****************************************************************
* Name: scom.spObjectAlertRelationshipInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateAlertRelationshipInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

UPDATE scom.[ObjectHealthStateAlertRelationship]
SET Active = 0
WHERE dbLastUpdate < @BeforeDate 
	AND Active = 1

COMMIT