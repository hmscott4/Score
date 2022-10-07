/****************************************************************
* Name: dbo.spCredentialDelete
* Author: huscott
* Date: 2015-03-30
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialDelete] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Credential]
	WHERE  [Name] = @Name

	COMMIT