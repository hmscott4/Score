/****** Object:  StoredProcedure [dbo].[spProcessLogDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
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
