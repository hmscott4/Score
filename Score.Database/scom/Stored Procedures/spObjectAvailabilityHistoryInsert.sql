

CREATE PROC [scom].[spObjectAvailabilityHistoryInsert]
(
   @ManagedEntityID uniqueidentifier
   , @FullName nvarchar(2048)
   , @DateTime datetime2(3)
   , @IntervalDurationMilliseconds INT
   , @InWhiteStateMilliseconds INT
   , @InGreenStateMilliseconds INT
   , @InYellowStateMilliseconds INT
   , @InRedStateMilliseconds INT
   , @InDisabledStateMilliseconds INT
   , @InPlannedMaintenanceMilliseconds INT
   , @InUnplannedMaintenanceMilliseconds INT
   , @HealthServiceUnavailableMilliseconds INT
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF NOT EXISTS(
	SELECT ManagedEntityID 
	FROM [scom].[ObjectAvailabilityHistory]
	WHERE [ManagedEntityID]= @ManagedEntityID AND [DateTime]= @DateTime)

BEGIN
      INSERT INTO [scom].[ObjectAvailabilityHistory]
                       ([ManagedEntityID]
                       ,[FullName]
                       ,[DateTime]
                       ,[IntervalDurationMilliseconds]
                       ,[InWhiteStateMilliseconds]
                       ,[InGreenStateMilliseconds]
                       ,[InYellowStateMilliseconds]
                       ,[InRedStateMilliseconds]
                       ,[InDisabledStateMilliseconds]
                       ,[InPlannedMaintenanceMilliseconds]
                       ,[InUnplannedMaintenanceMilliseconds]
                       ,[HealthServiceUnavailableMilliseconds])
             VALUES
                       (@ManagedEntityID
                       ,@FullName
                       ,@DateTime
                       ,@IntervalDurationMilliseconds
                       ,@InWhiteStateMilliseconds
                       ,@InGreenStateMilliseconds
                       ,@InYellowStateMilliseconds
                       ,@InRedStateMilliseconds
                       ,@InDisabledStateMilliseconds
                       ,@InPlannedMaintenanceMilliseconds
                       ,@InUnplannedMaintenanceMilliseconds
                       ,@HealthServiceUnavailableMilliseconds)
END