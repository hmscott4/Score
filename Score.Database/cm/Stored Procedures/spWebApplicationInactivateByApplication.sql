/****************************************************************
* Name: cm.spWebApplicationInactivateByApplication
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationInactivateByApplication] 
    @Name nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[WebApplication]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @Name
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplication]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
