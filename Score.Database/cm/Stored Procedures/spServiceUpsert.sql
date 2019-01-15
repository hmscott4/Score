/****************************************************************
* Name: cm.spServiceUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spServiceUpsert] 
    @dnsHostName nvarchar(255),
    @Name nvarchar(255),
    @DisplayName nvarchar(255) = NULL,
    @Description nvarchar(2048) = NULL,
    @Status nvarchar(128) = NULL,
    @State nvarchar(128) = NULL,
    @StartMode nvarchar(128) = NULL,
    @StartName nvarchar(255) = NULL,
    @PathName nvarchar(255) = NULL,
    @AcceptStop bit,
    @AcceptPause bit,
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

	MERGE [cm].[Service] AS target
	USING (SELECT @DisplayName, @Description, @Status, @State, @StartMode, @StartName, @PathName, @AcceptStop, @AcceptPause, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DisplayName] = @DisplayName, [Description] = @Description, [Status] = @Status, [State] = @State, [StartMode] = @StartMode, [StartName] = @StartName, [PathName] = @PathName, [AcceptStop] = @AcceptStop, [AcceptPause] = @AcceptPause, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @DisplayName, @Description, @Status, @State, @StartMode, @StartName, @PathName, @AcceptStop, @AcceptPause, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Service]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
