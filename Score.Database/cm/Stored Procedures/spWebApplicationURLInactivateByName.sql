/****** Object:  StoredProcedure [cm].[spWebApplicationURLInactivateByName]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationURLInactivateByName
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLInactivateByName]
    @Name nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[WebApplicationURL]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @Name
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplicationURL]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT