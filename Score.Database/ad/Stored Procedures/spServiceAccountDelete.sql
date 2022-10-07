/****************************************************************
* Name: ad.spServiceAccountDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spServiceAccountDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[ServiceAccount]
	WHERE  [objectGUID] = @objectGUID

	COMMIT