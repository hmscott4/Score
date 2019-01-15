/****************************************************************
* Name: cm.spDatabaseInstanceLoginDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceLoginDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseInstanceLogin]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
