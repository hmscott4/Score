/****** Object:  StoredProcedure [dbo].[spSystemTimeZoneSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GO
