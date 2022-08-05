
CREATE PROC [ad].[spOrganizationalUnitUpsert]
(
	@objectGUID uniqueidentifier
	,@Domain nvarchar(128)
	,@Name nvarchar(255)
	,@Description nvarchar(1024)
	,@DistinguishedName nvarchar(1024)
	,@StreetAddress nvarchar(255)
	,@City nvarchar(255)
	,@State nvarchar(255)
	,@Country nvarchar(255)
	,@PostalCode nvarchar(255)
	,@Protected bit
	,@whenCreated datetime2(3)
	,@whenChanged datetime2(3)
	,@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

-- TEST FOR UNIQUENESS
IF EXISTS (SELECT [Name] FROM [ad].[OrganizationalUnit] WHERE DistinguishedName = @DistinguishedName AND Domain = @Domain AND [objectGUID] != @objectGUID)
BEGIN
	BEGIN TRAN
		
	INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
	SELECT [objectGUID], '<null>', [Domain], [Name], [DistinguishedName], N'OrganizationalUnit', dbAddDate, CURRENT_TIMESTAMP 
	FROM [ad].[OrganizationalUnit]
	WHERE DistinguishedName = @DistinguishedName AND Domain = @Domain

	DELETE FROM [ad].[OrganizationalUnit] 
	WHERE DistinguishedName = @DistinguishedName AND Domain = @Domain

	COMMIT
END


BEGIN TRAN

UPDATE [ad].[OrganizationalUnit]
   SET [objectGUID] = @objectGUID
      ,[Name] = @Name
      ,[Description] = @Description
      ,[DistinguishedName] = @DistinguishedName
      ,[StreetAddress] = @StreetAddress
      ,[City] = @City
      ,[State] = @State
      ,[Country] = @Country
      ,[PostalCode] = @PostalCode
      ,[Protected] = @Protected
      ,[Active] = 1
      ,[whenCreated] = @whenCreated
      ,[whenChanged] = @whenChanged
      ,[dbLastUpdate] = @dbLastUpdate
 WHERE 
	  DistinguishedName = @DistinguishedName AND Domain = @Domain


IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO [ad].[OrganizationalUnit]
			   ([objectGUID]
			   ,[Domain]
			   ,[Name]
			   ,[Description]
			   ,[DistinguishedName]
			   ,[StreetAddress]
			   ,[City]
			   ,[State]
			   ,[Country]
			   ,[PostalCode]
			   ,[Protected]
			   ,[Active]
			   ,[whenCreated]
			   ,[whenChanged]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@objectGUID
			   ,@Domain
			   ,@Name
			   ,@Description
			   ,@DistinguishedName
			   ,@StreetAddress
			   ,@City
			   ,@State
			   ,@Country
			   ,@PostalCode
			   ,@Protected
			   ,1
			   ,@whenCreated
			   ,@whenChanged
			   ,@dbLastUpdate
			   ,@dbLastUpdate)
END

COMMIT
GO
GRANT EXECUTE
    ON OBJECT::[ad].[spOrganizationalUnitUpsert] TO [adUpdate]
    AS [dbo];

