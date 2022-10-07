/****** Object:  View [cm].[ReportingInstanceView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ReportingInstanceView]
AS
SELECT [ri].[objectGUID]
      ,[ri].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[ri].[InstanceName]
      ,[ri].[ProductName]
      ,[ri].[ProductEdition]
      ,[ri].[ProductVersion]
      ,[ri].[ProductServicePack]
      ,[ri].[ConnectionString]
      ,[ri].[ServiceState]
      ,[ri].[RSConfiguration]
      ,[ri].[Active]
      ,[ri].[dbAddDate]
      ,[ri].[dbLastUpdate]
  FROM [cm].[ReportingInstance] ri INNER JOIN [cm].[Computer] c ON
		[ri].[ComputerGUID] = [c].[objectGUID]