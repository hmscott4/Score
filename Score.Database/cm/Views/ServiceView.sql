﻿CREATE VIEW [cm].[ServiceView]
AS
SELECT [s].[objectGUID]
      ,[s].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[s].[Name]
      ,[s].[DisplayName]
      ,[s].[Description]
      ,[s].[Status]
      ,[s].[State]
      ,[s].[StartMode]
      ,[s].[StartName]
      ,[s].[PathName]
      ,[s].[AcceptStop]
      ,[s].[AcceptPause]
      ,[s].[Active]
      ,[s].[dbAddDate]
      ,[s].[dbLastUpdate]
  FROM [cm].[Service] s INNER JOIN [cm].[Computer] c ON
	[s].[ComputerGUID] = [c].[objectGUID]
