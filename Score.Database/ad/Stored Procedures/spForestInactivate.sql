/****************************************************************
* Name: ad.spForestInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spForestInactivate] 
    @ForestName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Forest]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @ForestName
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate], [dbDelDate]
	FROM   [ad].[Forest]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT

