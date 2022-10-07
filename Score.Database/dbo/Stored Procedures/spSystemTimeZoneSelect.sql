CREATE PROC [dbo].[spSystemTimeZoneSelect] (
	@Display bit = 1
)

AS

SET NOCOUNT ON

SELECT [ZoneID]
      ,[ID]
      ,[DisplayName]
      ,[StandardName]
      ,[DaylightName]
      ,[BaseUTCOffset]
      ,[CurrentUTCOffset]
      ,[SupportsDaylightSavingTime]
      ,[Display]
      ,[DefaultTimeZone]
      ,[Active]
      ,[dbAddDate]
      ,[dbLastUpdate]
  FROM [dbo].[SystemTimeZone]
  WHERE [Display] >= @Display
  ORDER BY [CurrentUTCOffset]