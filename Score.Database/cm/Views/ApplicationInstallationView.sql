/****** Object:  View [cm].[ApplicationInstallationView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ApplicationInstallationView]
AS
SELECT [ai].[objectGUID]
      ,[ai].[ComputerGUID]
      ,[ai].[ApplicationGUID]
	  ,[c].[dnsHostName]
	  ,[a].[Name]
	  ,[a].[Version]
	  ,[a].[Vendor]
	  ,[ai].[InstallDate]
      ,[ai].[Active]
      ,[ai].[dbAddDate]
      ,[ai].[dbLastUpdate]
  FROM [cm].[ApplicationInstallation] ai INNER JOIN [cm].[Application] a ON
		[ai].[ApplicationGUID] = [a].objectGUID
	INNER JOIN [cm].[Computer] c ON
		[ai].[ComputerGUID] = [c].[objectGUID]