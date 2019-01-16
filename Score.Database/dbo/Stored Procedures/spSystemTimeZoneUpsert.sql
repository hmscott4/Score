/****** Object:  StoredProcedure [dbo].[spSystemTimeZoneUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [dbo].[spSystemTimeZoneUpsert] (
	@ID nvarchar(255),
	@DisplayName nvarchar(255),
	@StandardName nvarchar(255),
	@DaylightName nvarchar(255),
	@BaseUTCOffset [int],
	@CurrentUTCOffset [int],
	@SupportsDaylightSavingTime bit,
	@Active bit,
	@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS(SELECT ZoneID FROM dbo.SystemTimeZone WHERE ID = @ID)
BEGIN
	UPDATE [dbo].[SystemTimeZone]
		SET 
			[ID] = @ID
			,[DisplayName] = @DisplayName
			,[StandardName] = @StandardName
			,[DaylightName] = @DaylightName
			,[BaseUTCOffset] = @BaseUTCOffset
			,[CurrentUTCOffset] = @CurrentUTCOffset
			,[SupportsDaylightSavingTime] = @SupportsDaylightSavingTime
			,[Active] = @Active
			,[dbLastUpdate] = @dbLastUpdate
		WHERE ID = @ID
END

ELSE

BEGIN

INSERT INTO [dbo].[SystemTimeZone]
           ([ID]
           ,[DisplayName]
           ,[StandardName]
           ,[DaylightName]
           ,[BaseUTCOffset]
           ,[CurrentUTCOffset]
           ,[SupportsDaylightSavingTime]
		   ,[Active]
           ,[dbAddDate]
           ,[dbLastUpdate])
     VALUES
           (@ID
           ,@DisplayName
           ,@StandardName
           ,@DaylightName
           ,@BaseUTCOffset
           ,@CurrentUTCOffset
           ,@SupportsDaylightSavingTime
		   ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate)

END


GO
