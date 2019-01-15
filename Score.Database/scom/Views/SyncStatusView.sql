


CREATE VIEW [scom].[SyncStatusView]

AS

SELECT 
	[ss].[ManagementGroup],
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
	[scom].[SyncStatus] ss inner join [scom].[SyncHistory] sh ON
		[ss].[ManagementGroup] = [sh].[ManagementGroup] AND
		[ss].[ObjectClass] = [sh].[ObjectClass]
WHERE
	[sh].[Status] Like N'Success%'
GROUP BY
	[ss].[ManagementGroup],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType]

