/****************************************************************
* Name: cm.spApplicationInstallationInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationInactivateByComputer] 
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
	
	UPDATE [cm].[ApplicationInstallation]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE   ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ApplicationInstallation]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
