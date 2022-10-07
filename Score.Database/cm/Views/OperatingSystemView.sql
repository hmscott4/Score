﻿/****** Object:  View [cm].[OperatingSystemView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[OperatingSystemView]
AS
SELECT [os].[objectGUID]
      ,[os].[computerGUID]
	  ,[c].[Domain]
	  ,[c].[DomainRole]
	  ,[c].[dnsHostName]
      ,[os].[IPV4Address]
      ,[os].[Manufacturer]
      ,[os].[OSArchitecture]
      ,[os].[OSType]
      ,[os].[OperatingSystem]
      ,[os].[Description]
      ,[os].[Version]
      ,[os].[ServicePack]
      ,[os].[ServicePackMajorVersion]
      ,[os].[ServicePackMinorVersion]
      ,[os].[BootDevice]
      ,[os].[SystemDevice]
      ,[os].[WindowsDirectory]
      ,[os].[SystemDirectory]
      ,[os].[TotalVisibleMemorySize]
      ,[os].[InstallDate]
      ,[os].[LastBootUpTime]
      ,[os].[Status]
	  ,[c].[IsClusterResource]
      ,[os].[Active]
      ,[os].[dbAddDate]
      ,[os].[dbLastUpdate]
  FROM [cm].[OperatingSystem] os INNER JOIN [cm].[Computer] [c] ON
		[os].[computerGUID] = [c].[objectGUID]