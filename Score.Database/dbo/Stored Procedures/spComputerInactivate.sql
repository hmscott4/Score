/****** Object:  StoredProcedure [dbo].[spComputerInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spComputerInactivate
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerInactivate] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [dbo].[Computer]
	SET [Active] = 0, dbLastUpdate = GETUTCDATE()
	WHERE  [dnsHostName] = @dnsHostName
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [dnsHostName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Computer]
	WHERE  [ID] = @ID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
GRANT EXECUTE ON [dbo].[spComputerInactivate] TO [cmUpdate] AS [dbo]
GO
