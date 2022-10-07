
/****************************************************************
* Name: dbo.spComputerReactivate
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerReactivate] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [dbo].[Computer]
	SET [Active] = 1, dbLastUpdate = GETUTCDATE()
	WHERE  [dnsHostName] = @dnsHostName
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [dnsHostName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Computer]
	WHERE  [ID] = @ID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT