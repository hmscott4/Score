/****************************************************************
* Name: cm.spDatabaseFileInactivate
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseFileInactivateByDatabase] 
    @DatabaseGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseFile]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([databaseGUID] = @DatabaseGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseFile]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
