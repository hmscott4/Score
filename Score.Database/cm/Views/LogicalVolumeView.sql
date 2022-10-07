/****** Object:  View [cm].[LogicalVolumeView]    Script Date: 1/16/2019 8:32:48 AM ******/




CREATE VIEW [cm].[LogicalVolumeView]
AS
SELECT [lv].[objectGUID]
      ,[lv].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[lv].[Name]
      ,[lv].[DriveLetter]
      ,[lv].[Label]
      ,[lv].[FileSystem]
      ,[lv].[BlockSize]
	  ,[lv].[SerialNumber]
      ,[lv].[Capacity]
	  ,[lv].[SpaceUsed]
	  ,[lv].[SystemVolume]
	  ,[lv].[IsClustered]
      ,[lv].[Active]
      ,[lv].[dbAddDate]
      ,[lv].[dbLastUpdate]
  FROM [cm].[LogicalVolume] lv INNER JOIN [cm].[Computer] c ON
	[lv].[ComputerGUID] = [c].[objectGUID]