/****************************************************************
* Name: cm.spEventDeleteByComputer
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[Event]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
