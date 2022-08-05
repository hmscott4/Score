/****************************************************************
* Name: ad.spUserDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
GRANT EXECUTE
    ON OBJECT::[ad].[spUserDelete] TO [adUpdate]
    AS [dbo];

