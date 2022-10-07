/****************************************************************
* Name: cm.spWebApplicationURLUpsert
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLUpsert] 
    @WebApplicationGUID uniqueidentifier,
	@dnsHostName nvarchar(255),
    @Name nvarchar(255),
    @URL nvarchar(2048),
    @UseDefaultCredential bit,
    @FormData nvarchar(2048) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[WebApplicationURL] AS target
	USING (SELECT @URL, @UseDefaultCredential, @FormData, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([URL], [UseDefaultCredential], [FormData], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([WebApplicationGUID] = @WebApplicationGUID AND [ComputerGUID] = @ComputerGUID AND [Name] = @Name )
       WHEN MATCHED THEN 
		UPDATE 
		SET   [URL] = @URL, [UseDefaultCredential] = @UseDefaultCredential, [FormData] = @FormData, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([WebApplicationGUID], [ComputerGUID], [Name], [URL], [UseDefaultCredential], [FormData], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@WebApplicationGUID, @ComputerGUID, @Name, @URL, @UseDefaultCredential, @FormData, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [WebApplicationGUID], [ComputerGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplicationURL]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT