/****************************************************************
* Name: dbo.spConfigDelete
* Author: huscott
* Date: 2015-03-11
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