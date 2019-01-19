/****************************************************************
* Name: scom.spObjectInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectInactivateByDate] (
	@BeforeDate datetime2(3),
	@ObjectClass nvarchar(255)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.Object
SET Active = 0
WHERE dbLastUpdate < @BeforeDate 
	AND Active = 1
	AND ObjectClass = @ObjectClass

COMMIT

GO
