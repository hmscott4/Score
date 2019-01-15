/****************************************************************
* Name: cm.spOperatingSystemDeleteByComputer
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spOperatingSystemDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[OperatingSystem]
	WHERE  [ComputerGUID] = @computerGUID

	COMMIT
