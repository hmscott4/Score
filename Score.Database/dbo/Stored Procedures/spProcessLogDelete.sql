CREATE PROCEDURE [dbo].[spProcessLogDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM dbo.ProcessLog 
WHERE MessageDate < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT
