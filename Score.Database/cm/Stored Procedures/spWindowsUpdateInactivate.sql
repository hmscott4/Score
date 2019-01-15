/****************************************************************
* Name: cm.spWindowsUpdateInactivate
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInactivate] 
    @HotfixID nvarchar(128),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[WindowsUpdate]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [HotfixID] = @HotfixID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdate]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
