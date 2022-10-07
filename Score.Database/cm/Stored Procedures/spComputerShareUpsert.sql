/****** Object:  StoredProcedure [cm].[spComputerShareUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerShareUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerShareUpsert]  
    @dnsHostName nvarchar(255),
    @Name nvarchar(128),
    @Description nvarchar(128),
    @Path nvarchar(2048),
    @Status nvarchar(128) = NULL,
    @Type nvarchar(128) = NULL,
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

	MERGE [cm].[ComputerShare] AS target
	USING (SELECT @Description, @Path, @Status, @Type, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [Path] = @Path, [Status] = @Status, [Type] = @Type, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @Description, @Path, @Status, @Type, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerShare]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT