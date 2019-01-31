/****************************************************************
* Name: scom.spGroupHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateUpsert]
	@ID uniqueidentifier,
	@Name nvarchar(255),
	@DisplayName nvarchar(255),
	@FullName nvarchar(255),
	@Path nvarchar(1024) = Null,
	@MonitoringObjectClassIds nvarchar(1024),
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

IF EXISTS (SELECT FullName FROM scom.[ObjectHealthState] WHERE (FullName = @FullName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[GroupHealthState] as [target]
	USING (SELECT 	
		@ID ,
		@Name,
		@DisplayName,
		@FullName,
		@Path,
		@MonitoringObjectClassIds,
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
		@Other	 ) as [Source]

		(ID,
		Name,
		DisplayName,
		FullName,
		[Path],
		MonitoringObjectClassIds,
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
		[Other]) on ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
		  ,[Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[FullName] = @FullName
		  ,[Path] = @Path
		  ,[MonitoringObjectClassIds] = @MonitoringObjectClassIds
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
			MonitoringObjectClassIds,
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
			@MonitoringObjectClassIds,
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