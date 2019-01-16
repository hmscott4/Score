/****** Object:  StoredProcedure [dbo].[spProcessLogSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spProcessLogSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spProcessLogSelect] 
    @ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Severity], [Process], [Object], [Message], [MessageDate] 
	FROM   [dbo].[ProcessLog] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT
GO
