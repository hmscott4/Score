CREATE VIEW [ad].[SyncStatusView]

AS

SELECT 
	[ss].[Domain],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType],
	MAX(CASE WHEN [sh].[SyncType] = N'Full' THEN [sh].[StartDate]
		ELSE NULL
		END) as [LastFullSync],
	MAX(CASE WHEN [sh].[SyncType] = N'Incremental' THEN [sh].[StartDate]
		ELSE NULL
		END) as [LastIncrementalSync]
FROM
	[ad].[SyncStatus] ss inner join [ad].[SyncHistory] sh ON
		[ss].[Domain] = [sh].[Domain] AND
		[ss].[ObjectClass] = [sh].[ObjectClass]
WHERE
	[sh].[Status] Like N'Success%'
GROUP BY
	[ss].[Domain],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType]
