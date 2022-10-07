


CREATE VIEW [ad].[SyncStatusView]

AS

SELECT 
	[ss].[Domain],
	[ss].[ObjectClass],
	[ss].[Status] as LastStatus,
	[ss].[SyncType] as LastSyncType,
	[ss].[StartDate] as LastStartDate,
	MAX(CASE WHEN [sh].[SyncType] = N'Full' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastFullSync],
	MAX(CASE WHEN [sh].[SyncType] = N'Incremental' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastIncrementalSync]
FROM
	[ad].[SyncStatus] ss inner join [ad].[SyncHistory] sh ON
		[ss].[Domain] = [sh].[Domain] AND
		[ss].[ObjectClass] = [sh].[ObjectClass]
GROUP BY
	[ss].[Domain],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType],
	[ss].[StartDate]