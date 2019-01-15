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
