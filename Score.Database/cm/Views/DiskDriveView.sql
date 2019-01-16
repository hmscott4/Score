/****** Object:  View [cm].[DiskDriveView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DiskDriveView] 
AS
SELECT [dd].[objectGUID]
      ,[dd].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[dd].[Name]
      ,[dd].[DeviceID]
      ,[dd].[Manufacturer]
      ,[dd].[Model]
      ,[dd].[SerialNumber]
      ,[dd].[FirmwareRevision]
      ,[dd].[Partitions]
      ,[dd].[InterfaceType]
      ,[dd].[SCSIBus]
      ,[dd].[SCSIPort]
      ,[dd].[SCSILogicalUnit]
      ,[dd].[SCSITargetID]
      ,[dd].[Size]
      ,[dd].[Status]
      ,[dd].[Active]
      ,[dd].[dbAddDate]
      ,[dd].[dbLastUpdate]
  FROM [cm].[DiskDrive] dd INNER JOIN [cm].[Computer] c ON
	[dd].[ComputerGUID] = [c].[objectGUID]
GO
GRANT REFERENCES ON [cm].[DiskDriveView] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DiskDriveView] TO [cmRead] AS [dbo]
GO
