
CREATE PROCEDURE [scom].[spAlertUpsert] (
	@AlertId uniqueidentifier, 
	@Name nvarchar(255), 
	@Description nvarchar(2000), 
	@MonitoringObjectId uniqueidentifier, 
	@MonitoringClassId uniqueidentifier, 
	@MonitoringObjectDisplayName ntext, 
	@MonitoringObjectName ntext, 
	@MonitoringObjectPath nvarchar(max), 
	@MonitoringObjectFullName ntext, 
	@IsMonitorAlert bit, 
	@ProblemId uniqueidentifier, 
	@MonitoringRuleId uniqueidentifier, 
	@ResolutionState tinyint, 
	@ResolutionStateName nvarchar(50), 
	@Priority tinyint, 
	@Severity tinyint, 
	@Category nvarchar(255), 
	@Owner nvarchar(255), 
	@ResolvedBy nvarchar(255), 
	@TimeRaised datetime2(3), 
	@TimeAdded datetime2(3), 
	@LastModified datetime2(3), 
	@LastModifiedBy nvarchar(255), 
	@TimeResolved datetime2(3), 
	@TimeResolutionStateLastModified datetime2(3), 
	@CustomField1 nvarchar(255), 
	@CustomField2 nvarchar(255), 
	@CustomField3 nvarchar(255), 
	@CustomField4 nvarchar(255), 
	@CustomField5 nvarchar(255), 
	@CustomField6 nvarchar(255), 
	@CustomField7 nvarchar(255), 
	@CustomField8 nvarchar(255), 
	@CustomField9 nvarchar(255), 
	@CustomField10 nvarchar(255), 
	@TicketId nvarchar(150), 
	@Context ntext, 
	@ConnectorId uniqueidentifier, 
	@LastModifiedByNonConnector datetime2(3), 
	@MonitoringObjectInMaintenanceMode bit, 
	@MaintenanceModeLastModified datetime2(3), 
	@MonitoringObjectHealthState tinyint, 
	@StateLastModified datetime2(3), 
	@ConnectorStatus int, 
	@TopLevelHostEntityId uniqueidentifier, 
	@RepeatCount int, 
	@AlertStringId uniqueidentifier, 
	@AlertStringName nvarchar(max), 
	@LanguageCode nvarchar(3), 
	@AlertStringDescription ntext, 
	@AlertParams ntext, 
	@SiteName nvarchar(255), 
	@TfsWorkItemId nvarchar(150), 
	@TfsWorkItemOwner nvarchar(255), 
	@HostID int, 
	@Active bit, 
	@dbLastUpdate datetime2(3)
)

AS 

SET NOCOUNT ON 
SET XACT_ABORT ON  



BEGIN TRAN

	MERGE scom.Alert as [target]
	USING (SELECT @AlertID
           ,@Name
           ,@Description
           ,@MonitoringObjectID
           ,@MonitoringClassID
           ,@MonitoringObjectDisplayName
           ,@MonitoringObjectName
           ,@MonitoringObjectPath
           ,@MonitoringObjectFullName
           ,@IsMonitorAlert
           ,@ProblemID
           ,@MonitoringRuleID
           ,@ResolutionState
           ,@ResolutionStateName
           ,@Priority
           ,@Severity
           ,@Category
           ,@Owner
           ,@ResolvedBy
           ,@TimeRaised
           ,@TimeAdded
           ,@LastModified
           ,@LastModifiedBy
           ,@TimeResolved
           ,@TimeResolutionStateLastModified
           ,@CustomField1
           ,@CustomField2
           ,@CustomField3
           ,@CustomField4
           ,@CustomField5
           ,@CustomField6
           ,@CustomField7
           ,@CustomField8
           ,@CustomField9
           ,@CustomField10
           ,@TicketID
           ,@Context
           ,@ConnectorID
           ,@LastModifiedByNonConnector
           ,@MonitoringObjectInMaintenanceMode
           ,@MaintenanceModeLastModified
           ,@MonitoringObjectHealthState
           ,@StateLastModified
           ,@ConnectorStatus
           ,@TopLevelHostEntityId
           ,@RepeatCount
           ,@AlertStringID
           ,@AlertStringName
           ,@LanguageCode
           ,@AlertStringDescription
           ,@AlertParams
           ,@SiteName
           ,@TfsWorkItemID
           ,@TfsWorkItemOwner
           ,@HostID
           ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate) AS [source]

	([AlertId]
           ,[Name]
           ,[Description]
           ,[MonitoringObjectId]
           ,[MonitoringClassId]
           ,[MonitoringObjectDisplayName]
           ,[MonitoringObjectName]
           ,[MonitoringObjectPath]
           ,[MonitoringObjectFullName]
           ,[IsMonitorAlert]
           ,[ProblemId]
           ,[MonitoringRuleId]
           ,[ResolutionState]
           ,[ResolutionStateName]
           ,[Priority]
           ,[Severity]
           ,[Category]
           ,[Owner]
           ,[ResolvedBy]
           ,[TimeRaised]
           ,[TimeAdded]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[TimeResolved]
           ,[TimeResolutionStateLastModified]
           ,[CustomField1]
           ,[CustomField2]
           ,[CustomField3]
           ,[CustomField4]
           ,[CustomField5]
           ,[CustomField6]
           ,[CustomField7]
           ,[CustomField8]
           ,[CustomField9]
           ,[CustomField10]
           ,[TicketId]
           ,[Context]
           ,[ConnectorId]
           ,[LastModifiedByNonConnector]
           ,[MonitoringObjectInMaintenanceMode]
           ,[MaintenanceModeLastModified]
           ,[MonitoringObjectHealthState]
           ,[StateLastModified]
           ,[ConnectorStatus]
           ,[TopLevelHostEntityId]
           ,[RepeatCount]
           ,[AlertStringId]
           ,[AlertStringName]
           ,[LanguageCode]
           ,[AlertStringDescription]
           ,[AlertParams]
           ,[SiteName]
           ,[TfsWorkItemId]
           ,[TfsWorkItemOwner]
           ,[HostID]
           ,[Active]
           ,[dbAddDate]
           ,[dbLastUpdate])

		   ON ([target].[AlertID] = @AlertID)

		WHEN MATCHED THEN

			UPDATE 
			   SET [AlertId] = @AlertID
				  ,[Name] = @Name
				  ,[Description] = @Description
				  ,[MonitoringObjectId] = @MonitoringObjectID
				  ,[MonitoringClassId] = @MonitoringClassID
				  ,[MonitoringObjectDisplayName] = @MonitoringObjectDisplayName
				  ,[MonitoringObjectName] = @MonitoringObjectName
				  ,[MonitoringObjectPath] = @MonitoringObjectPath
				  ,[MonitoringObjectFullName] = @MonitoringObjectFullName
				  ,[IsMonitorAlert] = @IsMonitorAlert
				  ,[ProblemId] = @ProblemID
				  ,[MonitoringRuleId] = @MonitoringRuleID
				  ,[ResolutionState] = @ResolutionState
				  ,[ResolutionStateName] = @ResolutionStateName
				  ,[Priority] = @Priority
				  ,[Severity] = @Severity
				  ,[Category] = @Category
				  ,[Owner] = @Owner
				  ,[ResolvedBy] = @ResolvedBy
				  ,[TimeRaised] = @TimeRaised
				  ,[TimeAdded] = @TimeAdded
				  ,[LastModified] = @LastModified
				  ,[LastModifiedBy] = @LastModifiedBy
				  ,[TimeResolved] = @TimeResolved
				  ,[TimeResolutionStateLastModified] = @TimeResolutionStateLastModified
				  ,[CustomField1] = @CustomField1
				  ,[CustomField2] = @CustomField2
				  ,[CustomField3] = @CustomField3
				  ,[CustomField4] = @CustomField4
				  ,[CustomField5] = @CustomField5
				  ,[CustomField6] = @CustomField6
				  ,[CustomField7] = @CustomField7
				  ,[CustomField8] = @CustomField8
				  ,[CustomField9] = @CustomField9
				  ,[CustomField10] = @CustomField10
				  ,[TicketId] = @TicketID
				  ,[Context] = @Context
				  ,[ConnectorId] = @ConnectorID
				  ,[LastModifiedByNonConnector] = @LastModifiedByNonConnector
				  ,[MonitoringObjectInMaintenanceMode] = @MonitoringObjectInMaintenanceMode
				  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
				  ,[MonitoringObjectHealthState] = @MonitoringObjectHealthState
				  ,[StateLastModified] = @StateLastModified
				  ,[ConnectorStatus] = @ConnectorStatus
				  ,[TopLevelHostEntityId] = @TopLevelHostEntityId
				  ,[RepeatCount] = @RepeatCount
				  ,[AlertStringId] = @AlertStringID
				  ,[AlertStringName] = @AlertStringName
				  ,[LanguageCode] = @LanguageCode
				  ,[AlertStringDescription] = @AlertStringDescription
				  ,[AlertParams] = @AlertParams
				  ,[SiteName] = @SiteName
				  ,[TfsWorkItemId] = @TfsWorkItemID
				  ,[TfsWorkItemOwner] = @TfsWorkItemOwner
				  ,[HostID] = @HostID
				  ,[Active] = @Active
				  ,[dbLastUpdate] = @dbLastUpdate

		WHEN NOT MATCHED THEN

		INSERT 
				   ([AlertId]
				   ,[Name]
				   ,[Description]
				   ,[MonitoringObjectId]
				   ,[MonitoringClassId]
				   ,[MonitoringObjectDisplayName]
				   ,[MonitoringObjectName]
				   ,[MonitoringObjectPath]
				   ,[MonitoringObjectFullName]
				   ,[IsMonitorAlert]
				   ,[ProblemId]
				   ,[MonitoringRuleId]
				   ,[ResolutionState]
				   ,[ResolutionStateName]
				   ,[Priority]
				   ,[Severity]
				   ,[Category]
				   ,[Owner]
				   ,[ResolvedBy]
				   ,[TimeRaised]
				   ,[TimeAdded]
				   ,[LastModified]
				   ,[LastModifiedBy]
				   ,[TimeResolved]
				   ,[TimeResolutionStateLastModified]
				   ,[CustomField1]
				   ,[CustomField2]
				   ,[CustomField3]
				   ,[CustomField4]
				   ,[CustomField5]
				   ,[CustomField6]
				   ,[CustomField7]
				   ,[CustomField8]
				   ,[CustomField9]
				   ,[CustomField10]
				   ,[TicketId]
				   ,[Context]
				   ,[ConnectorId]
				   ,[LastModifiedByNonConnector]
				   ,[MonitoringObjectInMaintenanceMode]
				   ,[MaintenanceModeLastModified]
				   ,[MonitoringObjectHealthState]
				   ,[StateLastModified]
				   ,[ConnectorStatus]
				   ,[TopLevelHostEntityId]
				   ,[RepeatCount]
				   ,[AlertStringId]
				   ,[AlertStringName]
				   ,[LanguageCode]
				   ,[AlertStringDescription]
				   ,[AlertParams]
				   ,[SiteName]
				   ,[TfsWorkItemId]
				   ,[TfsWorkItemOwner]
				   ,[HostID]
				   ,[Active]
				   ,[dbAddDate]
				   ,[dbLastUpdate])
			 VALUES
				   (@AlertID
				   ,@Name
				   ,@Description
				   ,@MonitoringObjectID
				   ,@MonitoringClassID
				   ,@MonitoringObjectDisplayName
				   ,@MonitoringObjectName
				   ,@MonitoringObjectPath
				   ,@MonitoringObjectFullName
				   ,@IsMonitorAlert
				   ,@ProblemID
				   ,@MonitoringRuleID
				   ,@ResolutionState
				   ,@ResolutionStateName
				   ,@Priority
				   ,@Severity
				   ,@Category
				   ,@Owner
				   ,@ResolvedBy
				   ,@TimeRaised
				   ,@TimeAdded
				   ,@LastModified
				   ,@LastModifiedBy
				   ,@TimeResolved
				   ,@TimeResolutionStateLastModified
				   ,@CustomField1
				   ,@CustomField2
				   ,@CustomField3
				   ,@CustomField4
				   ,@CustomField5
				   ,@CustomField6
				   ,@CustomField7
				   ,@CustomField8
				   ,@CustomField9
				   ,@CustomField10
				   ,@TicketID
				   ,@Context
				   ,@ConnectorID
				   ,@LastModifiedByNonConnector
				   ,@MonitoringObjectInMaintenanceMode
				   ,@MaintenanceModeLastModified
				   ,@MonitoringObjectHealthState
				   ,@StateLastModified
				   ,@ConnectorStatus
				   ,@TopLevelHostEntityId
				   ,@RepeatCount
				   ,@AlertStringID
				   ,@AlertStringName
				   ,@LanguageCode
				   ,@AlertStringDescription
				   ,@AlertParams
				   ,@SiteName
				   ,@TfsWorkItemID
				   ,@TfsWorkItemOwner
				   ,@HostID
				   ,@Active
				   ,@dbLastUpdate
				   ,@dbLastUpdate)

			;

COMMIT

