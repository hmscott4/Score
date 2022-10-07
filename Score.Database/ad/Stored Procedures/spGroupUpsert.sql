/****************************************************************
* Name: ad.spGroupUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(255),
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @Scope nvarchar(255),
    @Category nvarchar(255),
    @Description nvarchar(2048) = NULL,
    @Email nvarchar(255) = NULL,
    @DistinguishedName nvarchar(1024),
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Group] WHERE [Name] = @Name AND [Domain] = @Domain AND [objectGUID] != @objectGUID)
	BEGIN
		BEGIN TRAN
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
		SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'Group', [dbAddDate], [dbLastUpdate] 
		FROM [ad].[Group]
		WHERE [Name] = @Name AND [Domain] = @Domain

		DELETE FROM [ad].[Group] 
		WHERE [Name] = @Name AND [Domain] = @Domain
		COMMIT
	END

	BEGIN TRAN

	MERGE [ad].[Group] AS target
	USING (SELECT @SID, @Name, @Scope, @Category, @Description, @Email, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([SID], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID )
       WHEN MATCHED THEN 
		UPDATE 
		SET    [objectGUID] = @objectGUID, [SID] = @SID, [Name] = @Name, [Scope] = @Scope, [Category] = @Category, [Description] = @Description, [Email] = @Email, [DistinguishedName] = @DistinguishedName, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Domain, @Name, @Scope, @Category, @Description, @Email, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT