/****************************************************************
* Name: dbo.spCredentialInactivate
* Author: huscott
* Date: 2015-03-30
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialInactivate] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [dbo].[Credential]
	SET [Active] = 0, dbLastUpdate = GETUTCDATE()
	WHERE  [Name] = @Name
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Credential]
	WHERE  [ID] = @ID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
