/****** Object:  StoredProcedure [cm].[spWebApplicationURLUpdateLastResult]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spWebApplicationURLUpsertLastResult
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLUpdateLastResult] 
    @WebApplicationURLGUID uniqueidentifier,
	@LastStatusCode nvarchar(128), 
	@LastStatusDescription nvarchar(128) = NULL, 
	@LastResponseTime int = NULL, 
	@LastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[WebApplicationURL]
	SET   [LastStatusCode] = @LastStatusCode, [LastStatusDescription] = @LastStatusDescription, [LastResponseTime] = @LastResponseTime, [LastUpdate] = @LastUpdate
	WHERE [objectGUID] = @WebApplicationURLGUID 
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplicationURL]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT