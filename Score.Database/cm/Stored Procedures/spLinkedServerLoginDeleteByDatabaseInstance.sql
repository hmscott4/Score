/****** Object:  StoredProcedure [cm].[spLinkedServerLoginDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
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