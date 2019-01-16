/****** Object:  StoredProcedure [dbo].[spConfigDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spConfigDelete
* Author: huscott
* Date: 2015-03-11
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spConfigDelete] 
    @ConfigName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Config]
	WHERE  [ConfigName] = @ConfigName

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spConfigDelete] TO [cmUpdate] AS [dbo]
GO
