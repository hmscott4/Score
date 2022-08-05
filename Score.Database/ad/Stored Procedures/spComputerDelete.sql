/****************************************************************
* Name: ad.spComputerDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
GRANT EXECUTE
    ON OBJECT::[ad].[spComputerDelete] TO [adUpdate]
    AS [dbo];

