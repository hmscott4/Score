/****************************************************************
* Name: cm.spWindowsUpdateInstallationUpsert
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationUpsert] 
    @dnsHostName nvarchar(255),
    @HotfixID nvarchar(128),
    @Description nvarchar(128),
    @Caption nvarchar(128) = NULL,
    @FixComments nvarchar(128) = NULL,
    @InstallDate datetime2(3) = NULL,
    @InstallBy nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @WindowsUpdateGUID uniqueidentifier
	SELECT @WindowsUpdateGUID = objectGUID
	FROM [cm].[WindowsUpdate]
	WHERE [HotfixID] = @HotfixID

	BEGIN TRAN

	IF @WindowsUpdateGUID is null
	BEGIN
		EXEC cm.spWindowsUpdateUpsert @HotfixID = @HotFixID, @Description = @Description, @Caption = @Caption, @FixComments = @FixComments, @Active = 1, @dbLastUpdate = @dbLastUpdate
		SELECT @WindowsUpdateGUID = objectGUID
		FROM [cm].[WindowsUpdate]
		WHERE [HotfixID] = @HotfixID	
	END

	COMMIT

	BEGIN TRAN

	MERGE [cm].[WindowsUpdateInstallation] AS target
	USING (SELECT @InstallDate, @InstallBy, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [WindowsUpdateGUID] = @WindowsUpdateGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [InstallDate] = @InstallDate, [InstallBy] = @InstallBy, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @WindowsUpdateGUID, @InstallDate, @InstallBy, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdateInstallation]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT