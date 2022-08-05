CREATE PROCEDURE [ad].[spServiceAccountUpsert] (
	@objectGUID uniqueidentifier
    ,@SID nvarchar(255)
    ,@Domain nvarchar(255)
    ,@Name nvarchar(255)
    ,@DNSHostName nvarchar(255)
    ,@Trusted bit
    ,@Description nvarchar(1024)
    ,@DistinguishedName nvarchar(255)
    ,@PrincipalsAllowedToRetrievePassword nvarchar(2048)
    ,@UserAccountControl int
    ,@ServicePrincipalNames nvarchar(2048)
    ,@SupportedEncryptionTypes int
    ,@Enabled bit
    ,@Active bit 
    ,@LastLogon datetime2(3)
    ,@whenCreated datetime2(3)
    ,@whenChanged datetime2(3)
    ,@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

-- TEST FOR UNIQUENESS; MOVE DUPLICATE OBJECTS (WITH DIFFERENT OBJECTGUID TO DELETEDOBJECTS TABLE)
IF EXISTS (SELECT [Name] FROM [ad].[ServiceAccount] WHERE Name = @Name AND Domain = @Domain AND [objectGUID] != @objectGUID)
BEGIN
	BEGIN TRANSACTION
		
	INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
	SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'ServiceAccount', dbAddDate, CURRENT_TIMESTAMP 
	FROM [ad].[ServiceAccount]
	WHERE [Name] = @Name AND Domain = @Domain

	DELETE FROM [ad].[Computer] 
	WHERE Name = @Name AND Domain = @Domain

	COMMIT
END

BEGIN TRANSACTION;

UPDATE [ad].[ServiceAccount]
   SET [objectGUID] = @objectGUID
      ,[SID] = @SID
      ,[DNSHostName] = @DNSHostName
      ,[Trusted] = @Trusted
      ,[Description] = @Description
      ,[DistinguishedName] = @DistinguishedName
      ,[PrincipalsAllowedToRetrievePassword] = @PrincipalsAllowedToRetrievePassword
      ,[UserAccountControl] = @UserAccountControl
      ,[ServicePrincipalNames] = @ServicePrincipalNames
      ,[SupportedEncryptionTypes] = @SupportedEncryptionTypes
      ,[Enabled] = @Enabled
      ,[Active] = @Active
      ,[LastLogon] = @LastLogon
      ,[whenCreated] = @whenCreated
      ,[whenChanged] = @whenChanged
      ,[dbLastUpdate] = @dbLastUpdate
 WHERE [Name] = @Name 
	AND [Domain] = @Domain


IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO [ad].[ServiceAccount]
			   ([objectGUID]
			   ,[SID]
			   ,[Domain]
			   ,[Name]
			   ,[DNSHostName]
			   ,[Trusted]
			   ,[Description]
			   ,[DistinguishedName]
			   ,[PrincipalsAllowedToRetrievePassword]
			   ,[UserAccountControl]
			   ,[ServicePrincipalNames]
			   ,[SupportedEncryptionTypes]
			   ,[Enabled]
			   ,[Active]
			   ,[LastLogon]
			   ,[whenCreated]
			   ,[whenChanged]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@objectGUID
			   ,@SID
			   ,@Domain
			   ,@Name
			   ,@DNSHostName
			   ,@Trusted
			   ,@Description
			   ,@DistinguishedName
			   ,@PrincipalsAllowedToRetrievePassword
			   ,@UserAccountControl
			   ,@ServicePrincipalNames
			   ,@SupportedEncryptionTypes
			   ,@Enabled
			   ,@Active
			   ,@LastLogon
			   ,@whenCreated
			   ,@whenChanged
			   ,@dbLastUpdate
			   ,@dbLastUpdate)
END


COMMIT;
GO
GRANT EXECUTE
    ON OBJECT::[ad].[spServiceAccountUpsert] TO [adUpdate]
    AS [dbo];

