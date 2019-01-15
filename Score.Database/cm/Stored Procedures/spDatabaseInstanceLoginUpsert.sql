/****************************************************************
* Name: cm.spDatabaseInstanceLoginUpsert
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceLoginUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @Name nvarchar(255),
    @Sid nvarchar(255),
    @LoginType nvarchar(128),
    @DefaultDatabase nvarchar(255),
    @HasAccess bit,
    @IsDisabled bit = null,
    @IsLocked bit = null,
    @IsPasswordExpired bit = null,
    @PasswordExpirationEnabled bit = null,
	@PasswordPolicyEnforced bit = null,
    @IsSysAdmin bit,
    @IsSecurityAdmin bit,
    @IsSetupAdmin bit,
    @IsProcessAdmin bit,
    @IsDiskAdmin bit,
    @IsDBCreator bit,
    @IsBulkAdmin bit,
    @CreateDate datetime2(3),
	@DateLastModified datetime2(3),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseInstanceLogin] AS target
	USING (SELECT @Sid, @LoginType, @DefaultDatabase, @HasAccess, @IsDisabled, @IsLocked, @IsPasswordExpired, @PasswordExpirationEnabled, @PasswordPolicyEnforced, @IsSysAdmin, @IsSecurityAdmin, @IsSetupAdmin, @IsProcessAdmin, @IsDiskAdmin, @IsDBCreator, @IsBulkAdmin, @CreateDate, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Sid] = @Sid, [LoginType] = @LoginType, [DefaultDatabase] = @DefaultDatabase, [HasAccess] = @HasAccess, [IsDisabled] = @IsDisabled, [IsLocked] = @IsLocked, [IsPasswordExpired] = @IsPasswordExpired, [PasswordExpirationEnabled] = @PasswordExpirationEnabled, [PasswordPolicyEnforced] = @PasswordPolicyEnforced, [IsSysAdmin] = @IsSysAdmin, [IsSecurityAdmin] = @IsSecurityAdmin, [IsSetupAdmin] = @IsSetupAdmin, [IsProcessAdmin] = @IsProcessAdmin, [IsDiskAdmin] = @IsDiskAdmin, [IsDBCreator] = @IsDBCreator, [IsBulkAdmin] = @IsBulkAdmin, [CreateDate] = @CreateDate, [State] = @State, [DateLastModified] = @DateLastModified, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @Name, @Sid, @LoginType, @DefaultDatabase, @HasAccess, @IsDisabled, @IsLocked, @IsPasswordExpired, @PasswordExpirationEnabled, @PasswordPolicyEnforced, @IsSysAdmin, @IsSecurityAdmin, @IsSetupAdmin, @IsProcessAdmin, @IsDiskAdmin, @IsDBCreator, @IsBulkAdmin, @CreateDate, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceLogin]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
