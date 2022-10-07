/****** Object:  View [cm].[DatabaseInstancePropertyView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[DatabaseInstancePropertyView]
AS
SELECT [dip].[objectGUID]
      ,[dip].[DatabaseInstanceGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[di].[ConnectionString]
      ,[dip].[PropertyName]
      ,[dip].[PropertyValue]
      ,[dip].[Active]
      ,[dip].[dbAddDate]
      ,[dip].[dbLastUpdate]
  FROM [cm].[DatabaseInstanceProperty] dip INNER JOIN [cm].[DatabaseInstance] di ON
	[dip].[DatabaseInstanceGUID] = [di].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
	[di].[ComputerGUID] = [c].[objectGUID]