CREATE VIEW [cm].[DatabaseUserView] 

AS 

SELECT [du].[objectGUID]
      ,[du].[DatabaseInstanceGUID]
	  ,[c].[objectGUID] AS [ComputerGUID]
	  ,[c].[dnsHostName] 
	  ,[di].[InstanceName]
      ,[du].[DatabaseName]
      ,[du].[UserName]
      ,[du].[Login]
      ,[du].[UserType]
      ,[du].[LoginType]
      ,[du].[HasDBAccess]
      ,[du].[CreateDate]
      ,[du].[DateLastModified]
      ,[du].[State]
      ,[du].[Active]
      ,[du].[dbAddDate]
      ,[du].[dbLastUpdate]
  FROM 
	[cm].[DatabaseUser] du INNER JOIN [cm].[DatabaseInstance] [di] ON
		[du].[DatabaseInstanceGUID] = [di].[objectGUID] 
	INNER JOIN [cm].[Computer] c ON
		[di].[ComputerGUID] = [c].[objectGUID]
