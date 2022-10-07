/****** Object:  StoredProcedure [cm].[spWebApplicationURLDeleteByName]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationURLDeleteByName
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLDeleteByName] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WebApplicationURL]
	WHERE  [Name] = @Name

	COMMIT