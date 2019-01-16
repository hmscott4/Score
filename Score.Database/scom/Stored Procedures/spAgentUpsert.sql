/****** Object:  StoredProcedure [scom].[spAgentUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spAgentUpsert]
	@AgentID uniqueidentifier,
	@Name nvarchar(255), 
	@DisplayName nvarchar(1024), 
	@Domain nvarchar(255), 
	@ManagementGroup nvarchar(255), 
	@PrimaryManagementServer nvarchar(255), 
	@Version nvarchar(255), 
	@PatchList nvarchar(255), 
	@ComputerName nvarchar(255), 
	@HealthState nvarchar(255), 
	@InstalledBy nvarchar(255), 
	@InstallTime datetime, 
	@ManuallyInstalled bit, 
	@ProxyingEnabled bit, 
	@IPAddress nvarchar(1024), 
	@LastModified datetime2(3),
	@Active bit,
	@dbLastUpdate datetime2(3)
AS


SET NOCOUNT ON 
SET XACT_ABORT ON  

IF EXISTS (SELECT Name FROM scom.Agent WHERE (Name = @Name AND [AgentID] != @AgentID))
BEGIN
	DELETE 
	FROM scom.Agent 
	WHERE Name = @Name
END

BEGIN TRAN

	MERGE [scom].[Agent] AS target
	USING (SELECT @AgentID
           ,@Name
           ,@DisplayName
           ,@Domain
           ,@ManagementGroup
           ,@PrimaryManagementServer
           ,@Version
           ,@PatchList
           ,@ComputerName
           ,@HealthState
           ,@InstalledBy
           ,@InstallTime
           ,@ManuallyInstalled
           ,@ProxyingEnabled
           ,@IPAddress
           ,@LastModified
		   ,@Active
		   ,@dbLastUpdate
		   ,@dbLastUpdate) AS Source

	(	    [AgentID]
           ,[Name]
           ,[DisplayName]
           ,[Domain]
           ,[ManagementGroup]
           ,[PrimaryManagementServer]
           ,[Version]
           ,[PatchList]
           ,[ComputerName]
           ,[HealthState]
           ,[InstalledBy]
           ,[InstallTime]
           ,[ManuallyInstalled]
           ,[ProxyingEnabled]
           ,[IPAddress]
           ,[LastModified]
           ,[Active]
           ,[dbAddDate]
           ,[dbLastUpdate]) 
	ON (target.[AgentID] = @AgentID)

	WHEN MATCHED THEN
		UPDATE 
		   SET [Name] = @Name
			  ,[DisplayName] = @DisplayName
			  ,[Domain] = @Domain
			  ,[ManagementGroup] = @ManagementGroup
			  ,[PrimaryManagementServer] = @PrimaryManagementServer
			  ,[Version] = @Version
			  ,[PatchList] = @PatchList
			  ,[ComputerName] = @ComputerName
			  ,[HealthState] = @HealthState
			  ,[InstalledBy] = @InstalledBy
			  ,[InstallTime] = @InstallTime
			  ,[ManuallyInstalled] = @ManuallyInstalled
			  ,[ProxyingEnabled] = @ProxyingEnabled
			  ,[IPAddress] = @IPAddress
			  ,[LastModified] = @LastModified
			  ,[Active] = 1
			  ,[dbLastUpdate] = @dbLastUpdate

	WHEN NOT MATCHED THEN
		INSERT 	   ([AgentID]
				   ,[Name]
				   ,[DisplayName]
				   ,[Domain]
				   ,[ManagementGroup]
				   ,[PrimaryManagementServer]
				   ,[Version]
				   ,[PatchList]
				   ,[ComputerName]
				   ,[HealthState]
				   ,[InstalledBy]
				   ,[InstallTime]
				   ,[ManuallyInstalled]
				   ,[ProxyingEnabled]
				   ,[IPAddress]
				   ,[LastModified]
				   ,[Active]
				   ,[dbAddDate]
				   ,[dbLastUpdate])
			 VALUES
				   (@AgentID
				   ,@Name
				   ,@DisplayName
				   ,@Domain
				   ,@ManagementGroup
				   ,@PrimaryManagementServer
				   ,@Version
				   ,@PatchList
				   ,@ComputerName
				   ,@HealthState
				   ,@InstalledBy
				   ,@InstallTime
				   ,@ManuallyInstalled
				   ,@ProxyingEnabled
				   ,@IPAddress
				   ,@LastModified
				   ,1
				   ,@dbLastUpdate
				   ,@dbLastUpdate)
			;
COMMIT

GO