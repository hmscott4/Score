/****************************************************************
* Name: cm.spDatabaseInstancePropertyDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePropertyDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseInstanceProperty]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID)

	COMMIT
