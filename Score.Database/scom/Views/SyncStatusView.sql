/****** Object:  View [scom].[SyncStatusView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [scom].[SyncStatusView]

AS

SELECT 
	[ss].[ManagementGroup],
	[ss].[ObjectClass],
	[ss].[Status] as [LastStatus],
	[ss].[SyncType] as [LastSyncType],
	[ss].[StartDate] as [LastStartDate],
	MAX(CASE WHEN [sh].[SyncType] = N'Full' AND [sh].[Status] like N'Success%' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastFullSync],
	MAX(CASE WHEN [sh].[SyncType] = N'Incremental' AND [sh].[Status] like N'Success%' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastIncrementalSync]
FROM
	[scom].[SyncStatus] ss inner join [scom].[SyncHistory] sh ON
		[ss].[ManagementGroup] = [sh].[ManagementGroup] AND
		[ss].[ObjectClass] = [sh].[ObjectClass]
GROUP BY
	[ss].[ManagementGroup],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType],
	[ss].[StartDate]

GO
