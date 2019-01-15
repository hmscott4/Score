/****************************************************************
* Name: cm.spServiceInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spServiceInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] 
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[Service]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Service]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
