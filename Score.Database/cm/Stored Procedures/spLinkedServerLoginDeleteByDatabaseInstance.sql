/****************************************************************
* Name: cm.spLinkedServerLoginDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerLoginDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[LinkedServerLogin]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
