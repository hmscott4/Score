/****************************************************************
* Name: ad.spSiteUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteUpsert] 
    @objectGUID uniqueidentifier,
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @Description nvarchar(1024) = NULL,
    @Location nvarchar(1024) = NULL,
    @DistinguishedName nvarchar(1024),
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Site] WHERE [Domain] = @Domain AND [Name] = @Name AND [objectGUID] != @objectGUID)
	BEGIN
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate], [dbDelDate])
		SELECT [objectGUID], '', [Domain], [Name], [DistinguishedName], N'Site', [dbAddDate], [dbLastUpdate] 
		FROM [ad].[Site]
		WHERE [Domain] = @Domain AND [Name] = @Name

		DELETE FROM [ad].[Site] 
		WHERE [Domain] = @Domain AND [Name] = @Name
	END

	MERGE [ad].[Site] AS target
	USING (SELECT @Domain, @Name, @Description, @Location, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [Domain] = @Domain, [Name] = @Name, [Description] = @Description, [Location] = @Location, [DistinguishedName] = @DistinguishedName, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @Domain, @Name, @Description, @Location, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT