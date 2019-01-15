/****************************************************************
* Name: cm.spDatabasePropertyDeleteByDatabase
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePropertyDeleteByDatabase] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseProperty]
	WHERE  [DatabaseGUID] = @DatabaseGUID

	COMMIT
