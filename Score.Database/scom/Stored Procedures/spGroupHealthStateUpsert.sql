/****************************************************************
* Name: scom.spGroupHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateUpsert]
	@Id UNIQUEIDENTIFIER,
	@Name nvarchar(255),
	@DisplayName nvarchar(255),
	@FullName nvarchar(255),
	@Path nvarchar(1024) = Null,
	@MonitoringClassIds nvarchar(1024),
	@HealthState nvarchar(255) = N'',
	@StateLastModified datetime2(3) = Null,
	@IsAvailable bit = Null,
	@AvailabilityLastModified datetime2(3) = Null,
	@InMaintenanceMode bit = Null,
	@MaintenanceModeLastModified datetime2(3) = Null,
	@ManagementGroup nvarchar(255),
	@Active bit,
	@dbLastUpdate datetime2(3),
	@Availability nvarchar(255),
	@Configuration nvarchar(255),
	@Performance nvarchar(255),
	@Security nvarchar(255),
	@Other nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT FullName FROM scom.[GroupHealthState] WHERE (FullName = @FullName AND [Id] != @Id))
BEGIN
	DELETE 
	FROM scom.[GroupHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[GroupHealthState] AS [target]
	USING (SELECT 	
		@Id ,
		@Name,
		@DisplayName,
		@FullName,
		@Path,
		@MonitoringClassIds,
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
		@Other	 ) AS [Source]

		(Id,
		Name,
		DisplayName,
		FullName,
		[Path],
		MonitoringClassIds,
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
		[Other]) ON ([target].Id = @Id)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [Id] = @Id
		  ,[Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[FullName] = @FullName
		  ,[Path] = @Path
		  ,[MonitoringClassIds] = @MonitoringClassIds
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

	WHEN NOT MATCHED
	THEN INSERT (
			Id,
			Name,
			DisplayName,
			FullName,
			[Path],
			MonitoringClassIds,
			HealthState,
			StateLastModified,
			IsAvailable,
			AvailabilityLastModified,
			InMaintenanceMode,
			MaintenanceModeLastModified,
			ManagementGroup,
			Display,
			Active,
			dbAddDate,
			dbLastUpdate,
			[Availability],
			[Configuration],
			[Performance],
			[Security] ,
			[Other])
		VALUES (
			@Id ,
			@Name,
			@DisplayName,
			@FullName,
			@Path,
			@MonitoringClassIds,
			@HealthState,
			@StateLastModified,
			@IsAvailable ,
			@AvailabilityLastModified,
			@InMaintenanceMode ,
			@MaintenanceModeLastModified,
			@ManagementGroup,
			0,
			@Active ,
			@dbLastUpdate,
			@dbLastUpdate,
			@Availability ,
			@Configuration ,
			@Performance , 
			@Security ,
			@Other
		)
	;
COMMIT

GO

GRANT EXEC ON [scom].[spGroupHealthStateUpsert] TO [scomUpdate]
GO