/****************************************************************
* Name: dbo.spCredentialUpsert
* Author: huscott
* Date: 2015-03-30
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialUpsert] 
    @Name nvarchar(255),
    @CredentialType nvarchar(128),
    @AccountName nvarchar(255),
    @Password nvarchar(512) = NULL,
    @Active bit,
    @dbAddDate datetime2(3) = NULL,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [dbo].[Credential] AS target
	USING (SELECT @CredentialType, @AccountName, @Password, @Active, @dbAddDate, @dbLastUpdate) 
		AS source 
		([CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [CredentialType] = @CredentialType, [AccountName] = @AccountName, [Password] = @Password, [Active] = @Active, [dbAddDate] = @dbAddDate, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @CredentialType, @AccountName, @Password, @Active, @dbAddDate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Credential]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
