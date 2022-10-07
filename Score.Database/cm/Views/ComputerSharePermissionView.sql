/****** Object:  View [cm].[ComputerSharePermissionView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ComputerSharePermissionView]

AS

SELECT [csp].[objectGUID]
      ,[c].[objectGUID] as [ComputerGUID]
      ,[csp].[ComputerShareGUID]
	  ,[c].[dnsHostName]
      ,[cs].[Name] as [ShareName]
      ,[csp].[SecurityPrincipal]
      ,[csp].[FileSystemRights]
      ,[csp].[AccessControlType]
      ,[csp].[IsInherited]
      ,[csp].[InheritanceFlags]
      ,[csp].[PropagationFlags]
      ,[csp].[Active]
      ,[csp].[dbAddDate]
      ,[csp].[dbLastUpdate]
  FROM [cm].[ComputerSharePermission] csp INNER JOIN [cm].[ComputerShare] cs ON
			[csp].[ComputerShareGUID] = [cs].[objectGUID] INNER JOIN [cm].[Computer] c ON
			[cs].[ComputerGUID] = [c].[objectGUID]