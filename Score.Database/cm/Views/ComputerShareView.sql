/****** Object:  View [cm].[ComputerShareView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[ComputerShareView]
AS
SELECT [cs].[objectGUID]
      ,[cs].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[cs].[Name]
      ,[cs].[Description]
      ,[cs].[Path]
      ,[cs].[Status]
      ,[cs].[Type]
      ,[cs].[Active]
      ,[cs].[dbAddDate]
      ,[cs].[dbLastUpdate]
  FROM [cm].[ComputerShare] cs INNER JOIN [cm].[Computer] c ON
		[cs].[ComputerGUID] = [c].[objectGUID]