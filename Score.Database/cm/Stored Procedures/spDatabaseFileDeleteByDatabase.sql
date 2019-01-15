/****************************************************************
* Name: cm.spDatabaseFileDeleteByDatabase
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseFileDeleteByDatabase] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseFile]
	WHERE  ([databaseGUID] = @DatabaseGUID) 

	COMMIT
