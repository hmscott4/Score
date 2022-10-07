/****** Object:  StoredProcedure [cm].[spComputerShareInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerShareInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerShareInactivateByComputer]  
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
	
	UPDATE [cm].[ComputerShare]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerShare]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT