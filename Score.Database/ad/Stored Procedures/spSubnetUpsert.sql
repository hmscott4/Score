/****************************************************************
* Name: ad.spSubnetUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetUpsert] 
    @objectGUID uniqueidentifier,
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @Description nvarchar(1024) = NULL,
    @Location nvarchar(1024) = NULL,
    @Site nvarchar(255) = NULL,
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
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Subnet] WHERE 	[Domain] = @Domain AND [Name] = @Name AND [objectGUID] != @objectGUID)
	BEGIN
		BEGIN TRAN

		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate], [dbDelDate])
		SELECT [objectGUID], '', [Domain], [Name], [DistinguishedName], N'Subnet', [dbAddDate], [dbLastUpdate]
		FROM [ad].[Subnet]
		WHERE [Domain] = @Domain AND [Name] = @Name

		DELETE FROM [ad].[Subnet] 
		WHERE [Domain] = @Domain AND [Name] = @Name

		COMMIT
	END

	MERGE [ad].[Subnet] AS target
	USING (SELECT @Domain, @Name, @Description, @Location, @Site, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate) 
		AS source 
		([Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [Name] = @Name, [Description] = @Description, [Location] = @Location, [Site] = @Site, [DistinguishedName] = @DistinguishedName, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @Domain, @Name, @Description, @Location, @Site, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Subnet]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT