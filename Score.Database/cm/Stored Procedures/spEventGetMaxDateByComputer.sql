/****************************************************************
* Name: cm.spEventGetMaxDateByComputer
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventGetMaxDateByComputer]
    @dnsHostName nvarchar(255),
	@LogName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName 

	SELECT MAX(TimeGenerated) as MaxTimeGenerated
	FROM [cm].[Event]
	WHERE [ComputerGUID] = @ComputerGUID AND [LogName] = @LogName

	COMMIT
