/****************************************************************
* Name: ad.spComputerUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(255),
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @DNSHostName nvarchar(255),
    @IPv4Address nvarchar(128) = NULL,
    @Trusted bit,
    @OperatingSystem nvarchar(128) = NULL,
    @OperatingSystemVersion nvarchar(128) = NULL,
    @OperatingSystemServicePack nvarchar(128) = NULL,
    @Description nvarchar(1024) = NULL,
    @DistinguishedName nvarchar(1024),
    @UserAccountControl int,
	@SupportedEncryptionTypes int = NULL,
    @Enabled bit,
    @Active bit,
    @LastLogon datetime2(3) = NULL,
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [Name] FROM [ad].[Computer] WHERE Name = @Name AND Domain = @Domain AND [objectGUID] != @objectGUID)
	BEGIN
		BEGIN TRAN
		
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
		SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'Computer', dbAddDate, CURRENT_TIMESTAMP 
		FROM [ad].[Computer]
		WHERE [Name] = @Name AND Domain = @Domain

		DELETE FROM [ad].[Computer] 
		WHERE Name = @Name AND Domain = @Domain

		COMMIT
	END

	
	BEGIN TRAN

	MERGE [ad].[Computer] AS target
	USING (SELECT @SID, @Domain, @Name, @DNSHostName, @IPv4Address, @Trusted, @OperatingSystem, @OperatingSystemVersion, @OperatingSystemServicePack, @Description, @DistinguishedName, @UserAccountControl, @SupportedEncryptionTypes, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [UserAccountControl], [SupportedEncryptionTypes], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SID] = @SID, [Domain] = @Domain, [Name] = @Name, [DNSHostName] = @DNSHostName, [IPv4Address] = @IPv4Address, [Trusted] = @Trusted, [OperatingSystem] = @OperatingSystem, [OperatingSystemVersion] = @OperatingSystemVersion, [OperatingSystemServicePack] = @OperatingSystemServicePack, [Description] = @Description, [DistinguishedName] = @DistinguishedName, [UserAccountControl] = @UserAccountControl, [SupportedEncryptionTypes] = @SupportedEncryptionTypes, [Enabled] = @Enabled, [Active] = @Active, [LastLogon] = @LastLogon, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [UserAccountControl], [SupportedEncryptionTypes], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Domain, @Name, @DNSHostName, @IPv4Address, @Trusted, @OperatingSystem, @OperatingSystemVersion, @OperatingSystemServicePack, @Description, @DistinguishedName, @UserAccountControl, @SupportedEncryptionTypes, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT