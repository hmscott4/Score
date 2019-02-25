/****************************************************************
* Name: scom.spGroupHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateUpsert]
	@ID UNIQUEIDENTIFIER,
	@Name nvarchar(255),
	@DisplayName nvarchar(255),
	@FullName nvarchar(255),
	@Path nvarchar(1024) = Null,
	@MonitoringClassIds nvarchar(1024),
	@HealthState nvarchar(255) = N'',
	@StateLastModified datetimeoffset(3) = Null,
	@IsAvailable bit = Null,
	@AvailabilityLastModified datetimeoffset(3) = Null,
	@InMaintenanceMode bit = Null,
	@MaintenanceModeLastModified datetimeoffset(3) = Null,
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

IF EXISTS (SELECT FullName FROM scom.[ObjectHealthState] WHERE (FullName = @FullName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[GroupHealthState] AS [target]
	USING (SELECT 	
		@ID ,
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

		(ID,
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
		[Other]) ON ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
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
			ID,
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
			[Other])
		VALUES (
			@ID ,
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