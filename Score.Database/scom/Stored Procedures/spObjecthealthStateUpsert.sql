/****************************************************************
* Name: scom.spObjectHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateUpsert]
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
	@AssetStatus nvarchar(255) = NULL,
	@Notes nvarchar(4000) = NULL

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

GRANT EXEC ON [scom].[spObjectHealthStateUpsert] TO [scomUpdate]
GO