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
