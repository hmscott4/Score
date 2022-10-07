/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelectByName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spWebApplicationURLSelectByName] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplicationURL] 
	WHERE  ([Name] = @Name) 

	COMMIT