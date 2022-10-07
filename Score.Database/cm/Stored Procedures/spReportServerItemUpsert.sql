/****** Object:  StoredProcedure [cm].[spReportServerItemUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerItemUpsert
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerItemUpsert] 
    @ReportingInstanceGUID uniqueidentifier,
    @Name nvarchar(128),
    @Path nvarchar(512),
    @VirtualPath nvarchar(1024),
    @TypeName nvarchar(128),
    @Size int,
    @Description nvarchar(1024) = NULL,
    @Hidden bit,
    @CreationDate datetime2(3),
    @ModifiedDate datetime2(3),
    @ModifiedBy nvarchar(255),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[ReportServerItem] AS target
	USING (SELECT @VirtualPath, @TypeName, @Size, @Description, @Hidden, @CreationDate, @ModifiedDate, @ModifiedBy, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ReportingInstanceGUID] = @ReportingInstanceGUID AND [Name] = @Name AND [Path] = @Path)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [VirtualPath] = @VirtualPath, [TypeName] = @TypeName, [Size] = @Size, [Description] = @Description, [Hidden] = @Hidden, [CreationDate] = @CreationDate, [ModifiedDate] = @ModifiedDate, [ModifiedBy] = @ModifiedBy, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ReportingInstanceGUID, @Name, @Path, @VirtualPath, @TypeName, @Size, @Description, @Hidden, @CreationDate, @ModifiedDate, @ModifiedBy, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerItem]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT