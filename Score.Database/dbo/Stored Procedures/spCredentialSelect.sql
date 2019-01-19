/****************************************************************
* Name: dbo.spCredentialSelect
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialSelect] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [dbo].[Credential] 
	WHERE  ([Name] = @Name OR @Name IS NULL) 

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spCredentialSelect] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[spCredentialSelect] TO [cmUpdate] AS [dbo]
GO
