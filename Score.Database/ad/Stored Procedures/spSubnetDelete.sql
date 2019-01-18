/****************************************************************
* Name: ad.spSubnetDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Subnet]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
GRANT EXECUTE ON [ad].[spSubnetDelete] TO [adUpdate] AS [dbo]
GO
