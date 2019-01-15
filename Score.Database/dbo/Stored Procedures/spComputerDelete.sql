/****************************************************************
* Name: dbo.spComputerDelete
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerDelete] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Computer]
	WHERE  [dnsHostName] = @dnsHostName

	COMMIT
