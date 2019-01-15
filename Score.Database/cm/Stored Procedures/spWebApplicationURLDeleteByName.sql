/****************************************************************
* Name: cm.spWebApplicationURLDeleteByName
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLDeleteByName] 
    @Name uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WebApplicationURL]
	WHERE  [Name] = @Name

	COMMIT
