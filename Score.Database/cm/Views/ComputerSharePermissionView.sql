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
