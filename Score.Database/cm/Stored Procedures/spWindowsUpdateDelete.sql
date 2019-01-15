/****************************************************************
* Name: cm.spWindowsUpdateDelete
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateDelete] 
    @HotfixID nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WindowsUpdate]
	WHERE  [HotfixID] = @HotfixID

	COMMIT
