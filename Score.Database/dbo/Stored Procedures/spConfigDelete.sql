/****************************************************************
* Name: dbo.spConfigDelete
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spConfigDelete] 
    @ConfigName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Config]
	WHERE  [ConfigName] = @ConfigName

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spConfigDelete] TO [cmUpdate] AS [dbo]
GO
