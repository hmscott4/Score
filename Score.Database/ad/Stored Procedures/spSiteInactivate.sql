/****************************************************************
* Name: ad.spSiteInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Site]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
