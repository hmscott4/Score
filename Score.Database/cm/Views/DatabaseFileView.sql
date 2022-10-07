/****** Object:  View [cm].[DatabaseFileView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[DatabaseFileView]
AS
SELECT [di].[ComputerGUID]
      ,[d].[DatabaseInstanceGUID]
      ,[df].[DatabaseGUID]
	  ,[df].[objectGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[di].[ConnectionString]
	  ,[d].[DatabaseName]
      ,[df].[FileID]
      ,[df].[FileGroup]
      ,[df].[LogicalName]
      ,[df].[PhysicalName]
      ,[df].[FileSize]
      ,[df].[MaxSize]
      ,[df].[SpaceUsed]
      ,[df].[Growth]
      ,[df].[GrowthType]
      ,[df].[IsReadOnly]
      ,[df].[Active]
      ,[df].[dbAddDate]
      ,[df].[dbLastUpdate]
  FROM [cm].[DatabaseFile] df INNER JOIN [cm].[Database] d ON
		[df].[DatabaseGUID] = [d].[objectGUID]
	INNER JOIN [cm].[DatabaseInstance] di ON
		[d].[DatabaseInstanceGUID] = [di].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[di].[ComputerGUID] = [c].[objectGUID]