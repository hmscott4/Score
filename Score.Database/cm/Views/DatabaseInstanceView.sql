/****** Object:  View [cm].[DatabaseInstanceView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[DatabaseInstanceView]
AS
SELECT [di].[objectGUID]
      ,[di].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[di].[InstanceName]
      ,[di].[ProductName]
      ,[di].[ProductEdition]
      ,[di].[ProductVersion]
      ,[di].[ProductServicePack]
      ,[di].[ConnectionString]
      ,[di].[ServiceState]
      ,[di].[IsClustered]
      ,[di].[ActiveNode]
      ,[di].[Active]
      ,[di].[dbAddDate]
      ,[di].[dbLastUpdate]
  FROM [cm].[DatabaseInstance] di INNER JOIN [cm].[Computer] c ON
	[di].[ComputerGUID] = [c].[objectGUID]