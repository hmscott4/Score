
CREATE PROC spSystemTimeZoneUpsert (
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
		   ,[DefaultTimeZone]
		   ,[Display]
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
		   ,0 -- DefaultTimeZone
		   ,0 -- Display
		   ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate)

END