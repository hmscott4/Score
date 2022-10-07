/****************************************************************
* Name: scom.spAlertUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
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
	@CustomField4 NVARCHAR(255), 
	@CustomField5 NVARCHAR(255), 
	@CustomField6 NVARCHAR(255), 
	@CustomField7 NVARCHAR(255), 
	@CustomField8 NVARCHAR(255), 
	@CustomField9 NVARCHAR(255), 
	@CustomField10 NVARCHAR(255), 
	@TicketId NVARCHAR(150), 
	@Context NTEXT, 
	@ConnectorId UNIQUEIDENTIFIER, 
	@LastModifiedByNonConnector DATETIME2(3), 
	@MonitoringObjectInMaintenanceMode BIT, 
	@MaintenanceModeLastModified DATETIME2(3), 
	@MonitoringObjectHealthState TINYINT, 
	@StateLastModified DATETIME2(3), 
	@ConnectorStatus INT, 
	@TopLevelHostEntityId UNIQUEIDENTIFIER, 
	@RepeatCount INT, 
	@AlertStringId UNIQUEIDENTIFIER, 
	@AlertStringName NVARCHAR(MAX), 
	@LanguageCode NVARCHAR(3), 
	@AlertStringDescription NTEXT, 
	@AlertParams NTEXT, 
	@SiteName NVARCHAR(255), 
	@TfsWorkItemId NVARCHAR(150), 
	@TfsWorkItemOwner NVARCHAR(255), 
	@HostID INT, 
	@Active BIT, 
	@dbLastUpdate DATETIME2(3),
	@ManagementGroup nvarchar(255)
)

AS 

SET NOCOUNT ON 
SET XACT_ABORT ON  



BEGIN TRAN

	MERGE scom.Alert AS [target]
	USING (SELECT @AlertId
           ,@Name
           ,@Description
           ,@MonitoringObjectId
           ,@MonitoringClassId
           ,@MonitoringObjectDisplayName
           ,@MonitoringObjectName
           ,@MonitoringObjectPath
           ,@MonitoringObjectFullName
           ,@IsMonitorAlert
           ,@ProblemId
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
           ,@TicketId
           ,@Context
           ,@ConnectorId
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
           ,@TfsWorkItemId
           ,@TfsWorkItemOwner
           ,@HostID
           ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate
		   ,@ManagementGroup) AS [source]

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
           ,[dbLastUpdate]
		   ,[ManagementGroup])

		   ON ([target].[AlertId] = @AlertId)

		WHEN MATCHED THEN

			UPDATE 
			   SET [AlertId] = @AlertId
				  ,[Name] = @Name
				  ,[Description] = @Description
				  ,[MonitoringObjectId] = @MonitoringObjectId
				  ,[MonitoringClassId] = @MonitoringClassId
				  ,[MonitoringObjectDisplayName] = @MonitoringObjectDisplayName
				  ,[MonitoringObjectName] = @MonitoringObjectName
				  ,[MonitoringObjectPath] = @MonitoringObjectPath
				  ,[MonitoringObjectFullName] = @MonitoringObjectFullName
				  ,[IsMonitorAlert] = @IsMonitorAlert
				  ,[ProblemId] = @ProblemId
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
				  ,[ConnectorId] = @ConnectorId
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
				  ,[ManagementGroup] = @ManagementGroup

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
				   ,[dbLastUpdate]
				   ,[ManagementGroup])
			 VALUES
				   (@AlertId
				   ,@Name
				   ,@Description
				   ,@MonitoringObjectId
				   ,@MonitoringClassID
				   ,@MonitoringObjectDisplayName
				   ,@MonitoringObjectName
				   ,@MonitoringObjectPath
				   ,@MonitoringObjectFullName
				   ,@IsMonitorAlert
				   ,@ProblemId
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
				   ,@ConnectorId
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
				   ,@dbLastUpdate
				   ,@ManagementGroup)

			;

COMMIT