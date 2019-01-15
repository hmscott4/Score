/****************************************************************
* Name: cm.spLinkedServerLoginUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerLoginUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @LinkedServerID int,
    @Name nvarchar(255),
    @Impersonate bit,
    @State nvarchar(128),
    @DateLastModified datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[LinkedServerLogin] AS target
	USING (SELECT @Name, @Impersonate, @State, @DateLastModified, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [LinkedServerID] = @LinkedServerID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [Name] = @Name, [Impersonate] = @Impersonate, [State] = @State, [DateLastModified] = @DateLastModified, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @LinkedServerID, @Name, @Impersonate, @State, @DateLastModified, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServerLogin]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
