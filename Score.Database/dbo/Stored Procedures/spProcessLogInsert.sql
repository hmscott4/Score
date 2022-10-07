/****************************************************************
* Name: dbo.spProcessLogInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spProcessLogInsert] 
    @Severity nvarchar(50) = NULL,
    @Process nvarchar(50) = NULL,
    @Object nvarchar(255) = NULL,
    @Message nvarchar(max) = NULL,
    @MessageDate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	INSERT INTO dbo.ProcessLog ([Severity], [Process], [Object], [Message], [MessageDate])
	VALUES (@Severity, @Process, @Object, @Message, @MessageDate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Severity], [Process], [Object], [Message], [MessageDate]
	FROM   [cm].[ProcessLog]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT