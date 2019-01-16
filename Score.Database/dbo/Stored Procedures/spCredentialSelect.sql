/****** Object:  StoredProcedure [dbo].[spCredentialSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
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
