/****** Object:  View [cm].[AnalysisInstanceView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[AnalysisInstanceView] 
AS
SELECT [ai].[objectGUID]
      ,[ai].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[ai].[InstanceName]
      ,[ai].[ProductName]
      ,[ai].[ProductEdition]
      ,[ai].[ProductVersion]
      ,[ai].[ProductServicePack]
      ,[ai].[ConnectionString]
      ,[ai].[ServiceState]
      ,[ai].[IsClustered]
      ,[ai].[ActiveNode]
      ,[ai].[Active]
      ,[ai].[dbAddDate]
      ,[ai].[dbLastUpdate]
  FROM [cm].[AnalysisInstance] [ai] INNER JOIN [cm].[Computer] c ON
		[ai].[ComputerGUID] = [c].[objectGUID]
GO
