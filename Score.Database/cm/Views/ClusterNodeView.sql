/****** Object:  View [cm].[ClusterNodeView]    Script Date: 1/16/2019 8:32:48 AM ******/


CREATE VIEW [cm].[ClusterNodeView]
AS
SELECT [cn].[objectGUID]
      ,[cn].[ClusterGUID]
      ,[cn].[ComputerGUID]
	  ,[cl].[ClusterName]
	  ,[c].[dnsHostName]
	  ,[cn].[State]
      ,[cn].[Active]
      ,[cn].[dbAddDate]
      ,[cn].[dbLastUpdate]
  FROM [cm].[ClusterNode] cn INNER JOIN [cm].[Computer] [c] ON
		[cn].[ComputerGUID] = [c].[objectGUID]
		INNER JOIN [cm].[Cluster] cl ON
		[cn].[ClusterGUID] = [cl].[objectGUID]