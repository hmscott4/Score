/****************************************************************
* Name: dbo.spProcessLogDelete
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [dbo].[spProcessLogDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM dbo.ProcessLog 
WHERE MessageDate < DATEADD(DAY, -@daysRetain, GetDate())

COMMIT
GO
