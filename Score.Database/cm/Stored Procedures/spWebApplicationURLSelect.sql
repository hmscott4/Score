CREATE PROC [cm].[spWebApplicationURLSelect] 
    @Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplicationURL] 
	WHERE  ([Active] >= @Active) 

	COMMIT
