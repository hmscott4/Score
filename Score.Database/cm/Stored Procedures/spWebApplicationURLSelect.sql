/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

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