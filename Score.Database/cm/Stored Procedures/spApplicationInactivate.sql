/****************************************************************
* Name: cm.spApplicationInactivate
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInactivate] 
    @Name nvarchar(255),
    @Version nvarchar(128),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[Application]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @Name and [Version] = @Version
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Application]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT