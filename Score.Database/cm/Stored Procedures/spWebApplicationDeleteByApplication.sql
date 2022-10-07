/****** Object:  StoredProcedure [cm].[spWebApplicationDeleteByApplication]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationDeleteByApplication
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationDeleteByApplication] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WebApplication]
	WHERE  [Name] = @Name

	COMMIT