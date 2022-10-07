/****************************************************************
* Name: cm.spWindowsUpdateSelect
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateSelect] 
    @HotfixID nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WindowsUpdate] 
	WHERE  ([HotfixID] = @HotfixID OR @HotfixID IS NULL) 

	COMMIT