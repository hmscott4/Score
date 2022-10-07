/****** Object:  View [cm].[EventView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[EventView]
AS
SELECT [e].[ID]
	  ,[c].[dnsHostName]
      ,[e].[ComputerGUID]
      ,[e].[LogName]
      ,[e].[MachineName]
      ,[e].[EventId]
      ,[e].[Source]
      ,[e].[TimeGenerated]
      ,[e].[EntryType]
      ,[e].[Message]
      ,[e].[UserName]
      ,[e].[dbAddDate]
  FROM [cm].[Event] e INNER JOIN [cm].[Computer] c ON
	[e].ComputerGUID = [c].[objectGUID]