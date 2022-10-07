/****** Object:  View [cm].[DatabaseView]    Script Date: 1/16/2019 8:32:48 AM ******/



CREATE VIEW [cm].[DatabaseView]
AS
SELECT
      [c].[objectGUID] as [ComputerGUID]
      ,[db].[DatabaseInstanceGUID]
      ,[db].[objectGUID] as [DatabaseObjectGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[di].[ConnectionString]
      ,[db].[DatabaseName]
      ,[db].[DatabaseID]
      ,[db].[RecoveryModel]
      ,[db].[Status]
      ,[db].[ReadOnly]
      ,[db].[UserAccess]
      ,[db].[CreateDate]
      ,[db].[Owner]
      ,[db].[LastFullBackup]
      ,[db].[LastDiffBackup]
      ,[db].[LastLogBackup]
      ,[db].[CompatibilityLevel]
	  ,[db].[DataFileSize]
	  ,[db].[DataFileSpaceUsed]
	  ,[db].[LogFileSize]
	  ,[db].[LogFileSpaceUsed]
	  ,[db].[VirtualLogFileCount]
      ,[db].[Active]
      ,[db].[dbAddDate]
      ,[db].[dbLastUpdate]
  FROM [cm].[Database] db INNER JOIN [cm].[DatabaseInstance] di ON
			[db].[DatabaseInstanceGUID] = [di].[objectGUID]
		INNER JOIN [cm].[Computer] c ON
			[di].[ComputerGUID] = [c].[objectGUID]