CREATE PROC scom.spObjecthealthStateUpsert (
	@ID uniqueidentifier
	,@Name nvarchar(255)
	,@DisplayName nvarchar(1024)
	,@FullName nvarchar(1024)
	,@Path nvarchar(1024)
	,@HealthState nvarchar(128)
	,@ManagementGroup nvarchar(128)
	,@IsAvailable bit
	,@InMaintenanceMode bit
	,@AvailabilityLastModified datetime2(3)
	,@LastModified datetime2(3)
	,@LastModifiedBy nvarchar(255)
	,@StateLastModified datetime2(3)
	,@ObjectClass nvarchar(255)
	,@Active bit
	,@dbAddDate datetime2(3)
	,@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT ID FROM scom.ObjectHealthState WHERE ID = @ID)
BEGIN

	UPDATE [scom].[ObjectHealthState]
	   SET [ID] = @ID
		  ,[Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[FullName] = @FullName
		  ,[Path] = @Path
		  ,[HealthState] = @HealthState
		  ,[ManagementGroup] = @ManagementGroup
		  ,[IsAvailable] = @IsAvailable
		  ,[InMaintenanceMode] = @InMaintenanceMode
		  ,[AvailabilityLastModified] = @AvailabilityLastModified
		  ,[LastModified] = @LastModified
		  ,[LastModifiedBy] = @LastModifiedBy
		  ,[StateLastModified] = @StateLastModified
		  ,[ObjectClass] = @ObjectClass
		  ,[Active] = @Active
		  ,[dbAddDate] = @dbAddDate
		  ,[dbLastUpdate] = @dbLastUpdate
	 WHERE [ID] = @ID

END

ELSE

BEGIN

	INSERT INTO [scom].[ObjectHealthState]
			   ([ID]
			   ,[Name]
			   ,[DisplayName]
			   ,[FullName]
			   ,[Path]
			   ,[HealthState]
			   ,[ManagementGroup]
			   ,[IsAvailable]
			   ,[InMaintenanceMode]
			   ,[AvailabilityLastModified]
			   ,[LastModified]
			   ,[LastModifiedBy]
			   ,[StateLastModified]
			   ,[ObjectClass]
			   ,[Active]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@ID
			   ,@Name
			   ,@DisplayName
			   ,@FullName
			   ,@Path
			   ,@HealthState
			   ,@ManagementGroup
			   ,@IsAvailable
			   ,@InMaintenanceMode
			   ,@AvailabilityLastModified
			   ,@LastModified
			   ,@LastModifiedBy
			   ,@StateLastModified
			   ,@ObjectClass
			   ,@Active
			   ,@dbAddDate
			   ,@dbLastUpdate)
END

