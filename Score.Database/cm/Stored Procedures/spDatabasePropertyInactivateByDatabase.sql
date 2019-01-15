/****************************************************************
* Name: cm.spDatabasePropertyInactivateByDatabase
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePropertyInactivateByDatabase] 
    @DatabaseGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseProperty]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [DatabaseGUID] = @DatabaseGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseProperty]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
