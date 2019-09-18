/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
/**********************************************************************
* ADD IsOpen Column to scom.AlertResolutionState
* HMS, Issue 19,20,21
* 2019/09/18
***********************************************************************/
-- Add Columns
ALTER TABLE scom.AlertResolutionState
ADD [IsOpen] bit DEFAULT 1
GO

-- Update Column, default is 1
UPDATE scom.AlertResolutionState
SET [IsOpen] = 1
WHERE Name != N'Closed'
GO

-- Update IsOpen, set 'Closed' to 0
UPDATE scom.AlertResolutionState
SET [IsOpen] = 0
WHERE Name = N'Closed'
GO

-- Set Column to NOT NULL
ALTER TABLE scom.AlertResolutionState ALTER COLUMN [IsOpen] BIT NOT NULL
GO

/****************************************************************
* Name: scom.spAlertResolutionStateGet
* Author: huscott
* Date: 2019/09/18
*
* Description:
* Retrieve Alert resolution states
*
****************************************************************/
ALTER PROC [scom].[spAlertResolutionStateGet]
	@ResolutionState INT = NULL,
	@IsOpen BIT = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT OFF

SELECT 
	ResolutionState, [Name]
FROM 
	scom.AlertResolutionState
WHERE
	Active = 1
	AND (@ResolutionState IS NULL OR ResolutionState = @ResolutionState)
	AND (@IsOpen IS NULL OR IsOpen = @IsOpen)
ORDER BY
	ResolutionState

GO

GRANT EXEC ON [scom].[spAlertResolutionStateGet] TO [scomRead]
GO

GRANT EXEC ON [scom].[spAlertResolutionStateGet] TO [scomUpdate]
GO


-- Add Columns
ALTER TABLE scom.Alert
ADD [ManagementGroup] nvarchar(255)
GO

/****** Object:  StoredProcedure [scom].[spAlertUpsert]    Script Date: 9/18/2019 4:13:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
ALTER PROCEDURE [scom].[spAlertUpsert] (
	@AlertId UNIQUEIDENTIFIER, 
	@Name NVARCHAR(255), 
	@Description NVARCHAR(2000), 
	@MonitoringObjectId UNIQUEIDENTIFIER, 
	@MonitoringClassId UNIQUEIDENTIFIER, 
	@MonitoringObjectDisplayName NTEXT, 
	@MonitoringObjectName NTEXT, 
	@MonitoringObjectPath NVARCHAR(MAX), 
	@MonitoringObjectFullName NTEXT, 
	@IsMonitorAlert BIT, 
	@ProblemId UNIQUEIDENTIFIER, 
	@MonitoringRuleId UNIQUEIDENTIFIER, 
	@ResolutionState TINYINT, 
	@ResolutionStateName NVARCHAR(50), 
	@Priority TINYINT, 
	@Severity TINYINT, 
	@Category NVARCHAR(255), 
	@Owner NVARCHAR(255), 
	@ResolvedBy NVARCHAR(255), 
	@TimeRaised DATETIME2(3), 
	@TimeAdded DATETIME2(3), 
	@LastModified DATETIME2(3), 
	@LastModifiedBy NVARCHAR(255), 
	@TimeResolved DATETIME2(3), 
	@TimeResolutionStateLastModified DATETIME2(3), 
	@CustomField1 NVARCHAR(255), 
	@CustomField2 NVARCHAR(255), 
	@CustomField3 NVARCHAR(255), 
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
	@ManagementGroup NVARCHAR(255)
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
GO

/****************************************************************
* Name: scom.spAlertInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
ALTER PROC [scom].[spAlertInactivate]
	@ManagementGroup NVARCHAR(255) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE
	[Active] = 1
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)

GO

/****************************************************************
* Name: scom.spAlertInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
ALTER PROC [scom].[spAlertInactivateByDate]
	@BeforeDate DATETIME2(3),
	@ManagementGroup NVARCHAR(255) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE 
	dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) 
	AND Active = 1
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)

GO

/****************************************************************
* Name: scom.spObjectInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
* Inactivate objects that were not updated in the most recent pass.
* Used only during full sync.
* Modified to subtract 15 minutes from last update.
*
****************************************************************/
ALTER PROC [scom].[spObjectHealthStateInactivateByDate] (
	@BeforeDate datetime2(3),
	@ObjectClass nvarchar(255),
	@ManagementGroup nvarchar(255) = NULL
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.[ObjectHealthState]
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate)
	AND Active = 1
	AND ObjectClass = @ObjectClass
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)

COMMIT

GO
/******************************************************************************************
* ADD COLUMNS TO ObjectHealthState TO SUPPORT TAGGING
* 2019/09/18
* HMS
*******************************************************************************************/
ALTER TABLE scom.ObjectHealthState ADD  AssetStatus nvarchar(255) NULL,Notes nvarchar(4000)
GO

/****************************************************************
* Name: scom.spObjectHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
ALTER PROC [scom].[spObjectHealthStateUpsert]
	@ID UNIQUEIDENTIFIER,
	@Name NVARCHAR(255),
	@DisplayName NVARCHAR(255),
	@FullName NVARCHAR(255),
	@Path NVARCHAR(1024) = NULL,
	@ObjectClass NVARCHAR(255),
	@HealthState NVARCHAR(255) = N'',
	@StateLastModified DATETIME2(3) = NULL,
	@IsAvailable BIT = NULL,
	@AvailabilityLastModified DATETIME2(3) = NULL,
	@InMaintenanceMode BIT = NULL,
	@MaintenanceModeLastModified DATETIME2(3) = NULL,
	@ManagementGroup NVARCHAR(255),
	@Active BIT,
	@dbLastUpdate DATETIME2(3),
	@Availability NVARCHAR(255),
	@Configuration NVARCHAR(255),
	@Performance NVARCHAR(255),
	@Security NVARCHAR(255),
	@Other NVARCHAR(255),
	@AssetStatus NVARCHAR(255) = NULL,
	@Notes NVARCHAR(4000) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT FullName FROM scom.[ObjectHealthState] WHERE (FullName = @FullName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[ObjectHealthState] AS [target]
	USING (SELECT 	
		@ID ,
		@Name,
		@DisplayName,
		@FullName,
		@Path,
		@ObjectClass,
		@HealthState,
		@StateLastModified,
		@IsAvailable ,
		@AvailabilityLastModified,
		@InMaintenanceMode ,
		@MaintenanceModeLastModified,
		@ManagementGroup,
		@Active ,
		@dbLastUpdate ,
		@dbLastUpdate ,
		@Availability ,
		@Configuration ,
		@Performance , 
		@Security ,
		@Other ,
		@AssetStatus ,
		@Notes ) AS [Source]

		(ID,
		Name,
		DisplayName,
		FullName,
		[Path],
		ObjectClass,
		HealthState,
		StateLastModified,
		IsAvailable,
		AvailabilityLastModified,
		InMaintenanceMode,
		MaintenanceModeLastModified,
		ManagementGroup,
		Active,
		dbAddDate,
		dbLastUpdate,
		[Availability],
		[Configuration],
		[Performance],
		[Security] ,
		[Other] ,
		[AssetStatus] , 
		[Notes] ) ON ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
		  ,[Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[FullName] = @FullName
		  ,[Path] = @Path
		  ,[ObjectClass] = @ObjectClass
		  ,[HealthState] = @HealthState
		  ,[StateLastModified] = @StateLastModified
		  ,[IsAvailable] = @IsAvailable
		  ,[AvailabilityLastModified] = @AvailabilityLastModified
		  ,[InMaintenanceMode] = @InMaintenanceMode
		  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
		  ,[ManagementGroup] = @ManagementGroup
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate
		  ,[Availability] = @Availability
		  ,[Configuration] = @Configuration
		  ,[Performance] = @Performance
		  ,[Security] = @Security
		  ,[Other] = @Other
		  ,[AssetStatus] = @AssetStatus
		  ,[Notes] = @Notes

	WHEN NOT MATCHED
	THEN INSERT (
			ID,
			Name,
			DisplayName,
			FullName,
			[Path],
			ObjectClass,
			HealthState,
			StateLastModified,
			IsAvailable,
			AvailabilityLastModified,
			InMaintenanceMode,
			MaintenanceModeLastModified,
			ManagementGroup,
			Active,
			dbAddDate,
			dbLastUpdate,
			[Availability],
			[Configuration],
			[Performance],
			[Security] ,
			[Other] ,
			[AssetStatus],
			[Notes])
		VALUES (
			@ID ,
			@Name,
			@DisplayName,
			@FullName,
			@Path,
			@ObjectClass,
			@HealthState,
			@StateLastModified,
			@IsAvailable ,
			@AvailabilityLastModified,
			@InMaintenanceMode ,
			@MaintenanceModeLastModified,
			@ManagementGroup,
			@Active ,
			@dbLastUpdate,
			@dbLastUpdate,
			@Availability ,
			@Configuration ,
			@Performance , 
			@Security ,
			@Other ,
			@AssetStatus ,
			@Notes
		)
	;
COMMIT

GO