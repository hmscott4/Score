
/****** Object:  StoredProcedure [ad].[spGroupDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spGroupDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
GRANT EXECUTE ON [ad].[spGroupDelete] TO [adUpdate] AS [dbo]
GO
