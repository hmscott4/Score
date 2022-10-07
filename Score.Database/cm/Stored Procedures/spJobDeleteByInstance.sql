/****** Object:  StoredProcedure [cm].[spJobDeleteByInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spJobDeleteByInstance
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spJobDeleteByInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Job]
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID

	COMMIT