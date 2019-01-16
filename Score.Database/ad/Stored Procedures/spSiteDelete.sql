
/****** Object:  StoredProcedure [ad].[spSiteDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spSiteDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
GRANT EXECUTE ON [ad].[spSiteDelete] TO [adUpdate] AS [dbo]
GO
