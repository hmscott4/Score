/****************************************************************
* Name: cm.spDatabaseUserDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseUser]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
