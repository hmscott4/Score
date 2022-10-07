/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spWebApplicationURLSelectByComputer] 
	@dnsHostName nvarchar(255),
    @Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [WebApplicationGUID], [ComputerGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplicationURL] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT