/****************************************************************
* Name: ad.spForestUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spForestUpsert] 
    @Name nvarchar(128),
    @DomainNamingMaster nvarchar(128),
    @SchemaMaster nvarchar(128),
    @RootDomain nvarchar(128),
    @ForestMode nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[Forest] AS target
	USING (SELECT @DomainNamingMaster, @SchemaMaster, @RootDomain, @ForestMode, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DomainNamingMaster] = @DomainNamingMaster, [SchemaMaster] = @SchemaMaster, [RootDomain] = @RootDomain, [ForestMode] = @ForestMode, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @DomainNamingMaster, @SchemaMaster, @RootDomain, @ForestMode, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Forest]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
