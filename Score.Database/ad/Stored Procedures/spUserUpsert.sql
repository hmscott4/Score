/****************************************************************
* Name: ad.spUserUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(255),
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @FirstName nvarchar(50) = NULL,
    @LastName nvarchar(50) = NULL,
    @DisplayName nvarchar(100) = NULL,
    @Description nvarchar(255) = NULL, -- new
    @JobTitle nvarchar(255) = NULL, -- new
    @EmployeeNumber nvarchar(255) = NULL, -- new
    @ProfilePath nvarchar(255) = NULL, -- new
    @HomeDirectory nvarchar(255) = NULL, -- new
    @Company nvarchar(255) = NULL,
    @Office nvarchar(255) = NULL,
    @Department nvarchar(255) = NULL,
    @Division nvarchar(255) = NULL,
    @StreetAddress nvarchar(255) = NULL,
    @City nvarchar(255) = NULL,
    @State nvarchar(255) = NULL,
    @PostalCode nvarchar(255) = NULL,
    @Manager nvarchar(255) = NULL,
    @MobilePhone nvarchar(20) = NULL,
    @PhoneNumber nvarchar(20) = NULL,
    @Fax nvarchar(20) = NULL,
    @Pager nvarchar(20) = NULL,
    @EMail nvarchar(255) = NULL,
    @LockedOut bit = NULL, -- new
    @PasswordExpired bit = NULL, -- new
    @PasswordLastSet datetime2(3) = NULL, -- new
    @PasswordNeverExpires bit = NULL, -- new
    @PasswordNotRequired bit = NULL, -- new
    @TrustedForDelegation bit = NULL, -- new
    @TrustedToAuthForDelegation bit = NULL, -- new
	@UserAccountControl int = NULL,
	@SupportedEncryptionTypes int = NULL,
    @DistinguishedName nvarchar(1024),
    @Enabled bit,
    @Active bit,
    @LastLogon datetime2(3) = NULL,
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	-- TEST FOR UNIQUENESS; CHECK FOR SAME DISTINGUISHED NAME BUT UNMATCHED OBJECTGUID
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[User] WHERE [Name] = @Name AND [Domain] = @Domain AND [objectGUID] != @objectGUID)
	BEGIN
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbDelDate])
		SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'User', [dbLastUpdate] 
		FROM [ad].[User]
		WHERE [Name] = @Name AND [Domain] = @Domain

		DELETE FROM [ad].[User] 
		WHERE [Name] = @Name AND [Domain] = @Domain
	END

	MERGE [ad].[User] AS target
	USING (SELECT @SID, @Domain, @Name, @FirstName, @LastName, @DisplayName, @Description, @JobTitle, @EmployeeNumber, @ProfilePath, @HomeDirectory, @Company, @Office, @Department, @Division, @StreetAddress, @City, @State, @PostalCode, @Manager, @MobilePhone, @PhoneNumber, @Fax, @Pager, @EMail, @LockedOut, @PasswordExpired, @PasswordLastSet, @PasswordNeverExpires, @PasswordNotRequired, @TrustedForDelegation, @TrustedToAuthForDelegation, @UserAccountControl, @SupportedEncryptionTypes, @DistinguishedName, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [Name], [SID], [FirstName], [LastName], [DisplayName], [Description], [JobTitle], [EmployeeNumber], [ProfilePath], [HomeDirectory], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [LockedOut], [PasswordExpired], [PasswordLastSet], [PasswordNeverExpires], [PasswordNotRequired], [TrustedForDelegation], [TrustedToAuthForDelegation], [UserAccountControl], [SupportedEncryptionTypes], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SID] = @SID, [Domain] = @Domain, [Name] = @Name, [FirstName] = @FirstName, [LastName] = @LastName, [DisplayName] = @DisplayName, [Description] = @Description, [JobTitle] = @Jobtitle, [EmployeeNumber] = @EmployeeNumber, [ProfilePath] = @ProfilePath, [HomeDirectory] = @HomeDirectory, [Company] = @Company, [Office] = @Office, [Department] = @Department, [Division] = @Division, [StreetAddress] = @StreetAddress, [City] = @City, [State] = @State, [PostalCode] = @PostalCode, [Manager] = @Manager, [MobilePhone] = @MobilePhone, [PhoneNumber] = @PhoneNumber, [Fax] = @Fax, [Pager] = @Pager, [EMail] = @EMail, [LockedOut] = @LockedOut, [PasswordExpired] = @PasswordExpired, [PasswordLastSet] = @PasswordLastSet, [PasswordNeverExpires] = @PasswordNeverExpires, [PasswordNotRequired] = @PasswordNotRequired, [TrustedForDelegation] = @TrustedForDelegation, [TrustedToAuthForDelegation] = @TrustedToAuthForDelegation, [UserAccountControl] = @UserAccountControl, [SupportedEncryptionTypes] = @SupportedEncryptionTypes, [DistinguishedName] = @DistinguishedName, [Enabled] = @Enabled, [Active] = @Active, [LastLogon] = @LastLogon, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Description], [JobTitle], [EmployeeNumber], [ProfilePath], [HomeDirectory], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [LockedOut], [PasswordExpired], [PasswordLastSet], [PasswordNeverExpires], [PasswordNotRequired], [TrustedForDelegation], [TrustedToAuthForDelegation], [UserAccountControl], [SupportedEncryptionTypes], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Domain, @Name, @FirstName, @LastName, @DisplayName, @Description, @JobTitle, @EmployeeNumber, @ProfilePath, @HomeDirectory, @Company, @Office, @Department, @Division, @StreetAddress, @City, @State, @PostalCode, @Manager, @MobilePhone, @PhoneNumber, @Fax, @Pager, @EMail, @LockedOut, @PasswordExpired, @PasswordLastSet, @PasswordNeverExpires, @PasswordNotRequired, @TrustedForDelegation, @TrustedToAuthForDelegation, @UserAccountControl, @SupportedEncryptionTypes, @DistinguishedName, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO


