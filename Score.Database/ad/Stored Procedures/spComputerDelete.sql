/****************************************************************
* Name: ad.spComputerDelete
* Author: huscott
* Date: 2019-01-18
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
