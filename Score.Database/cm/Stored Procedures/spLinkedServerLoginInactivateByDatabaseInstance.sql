/****************************************************************
* Name: cm.spLinkedServerLoginInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerLoginInactivateByDatabaseInstance]  
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[LinkedServerLogin]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServerLogin]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
