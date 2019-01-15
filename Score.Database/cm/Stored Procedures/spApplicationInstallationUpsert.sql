/****************************************************************
* Name: cm.spApplicationInstallationUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationUpsert] 
    @dnsHostName nvarchar(255),
	@Name nvarchar(255),
	@Version nvarchar(128),
	@Vendor nvarchar(128),
	@InstallDate datetime2(0) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ApplicationGUID uniqueidentifier
	SELECT @ApplicationGUID = objectGUID
	FROM [cm].[Application]
	WHERE [Name] = @Name AND [Version] = @Version

	BEGIN TRAN

	IF @ApplicationGUID is null
	BEGIN
		EXEC cm.spApplicationUpsert @Name = @Name, @Version = @Version, @Vendor = @Vendor, @Active = 1, @dbLastUpdate = @dbLastUpdate
		SELECT @ApplicationGUID = objectGUID
		FROM [cm].[Application]
		WHERE [Name] = @Name AND [Version] = @Version		
	END

	COMMIT

	BEGIN TRAN

	MERGE [cm].[ApplicationInstallation] AS target
	USING (SELECT @InstallDate, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([InstallDate], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ApplicationGUID] = @ApplicationGUID and [ComputerGUID] = @ComputerGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [InstallDate] = @InstallDate, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [ApplicationGUID], [InstallDate], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @ApplicationGUID, @InstallDate, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ApplicationInstallation]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
