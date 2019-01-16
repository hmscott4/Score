/****** Object:  StoredProcedure [dbo].[spCredentialDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spCredentialDelete
* Author: huscott
* Date: 2015-03-30
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialDelete] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Credential]
	WHERE  [Name] = @Name

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spCredentialDelete] TO [cmUpdate] AS [dbo]
GO
