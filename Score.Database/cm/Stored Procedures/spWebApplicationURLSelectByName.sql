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
