
/****** Object:  StoredProcedure [ad].[spDomainDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spDomainDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Domain]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
GRANT EXECUTE ON [ad].[spDomainDelete] TO [adUpdate] AS [dbo]
GO
