
/****** Object:  StoredProcedure [ad].[spForestDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spForestDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spForestDelete] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Forest]
	WHERE  [Name] = @Name

	COMMIT
GO
GRANT EXECUTE ON [ad].[spForestDelete] TO [adUpdate] AS [dbo]
GO
