/****** Object:  View [cm].[DatabasePropertyView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DatabasePropertyView] 
AS
SELECT [c].[objectGUID] as [ComputerGUID]
      ,[d].[DatabaseInstanceGUID]
      ,[dp].[DatabaseGUID]
	  ,[dp].[objectGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[d].[DatabaseName]
      ,[dp].[PropertyName]
      ,[dp].[PropertyValue]
      ,[dp].[Active]
      ,[dp].[dbAddDate]
      ,[dp].[dbLastUpdate]
  FROM [cm].[DatabaseProperty] dp INNER JOIN [cm].[Database] d ON
		[dp].[DatabaseGUID] = [d].[objectGUID]
	INNER JOIN [cm].[DatabaseInstance] di ON
		[d].[DatabaseInstanceGUID] = [di].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[di].[ComputerGUID] = [c].[objectGUID]