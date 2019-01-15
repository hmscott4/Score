/****************************************************************
* Name: cm.spDatabaseDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Database]
	WHERE  ([databaseInstanceGUID] = @databaseInstanceGUID) 

	COMMIT
