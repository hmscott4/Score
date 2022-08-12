

CREATE VIEW [ad].[ComputerView]

AS

SELECT
	[c].objectGUID
	,[c].[SID]
	,[c].[Domain]
	,[c].[Name]
	,[c].[DNSHostName]
	,[c].[IPv4Address]
	,[c].[Trusted]
	,[c].[OperatingSystem]
	,[c].[OperatingSystemVersion]
	,[c].[OperatingSystemServicePack]
	,[c].[Description]
	,[c].[DistinguishedName]
	 ,CASE 
		WHEN CHARINDEX('OU=',[c].[DistinguishedName]) > 0 THEN RIGHT([c].[DistinguishedName], (LEN([c].[DistinguishedName]) - CHARINDEX('OU=',[c].[DistinguishedName]))+1)
		ELSE REPLACE(RIGHT([c].[DistinguishedName], (LEN([c].[DistinguishedName]) - CHARINDEX('CN=',[c].[DistinguishedName],2))+1),'CN=','OU=')
	  END as [OrganizationalUnit]
	,[c].[UserAccountControl]
	,[c].[SupportedEncryptionTypes]
	,[c].[Enabled]
	,[c].[Active]
	,[c].[LastLogon]
	,[c].[whenCreated]
	,[c].[whenChanged]
	,[c].[dbAddDate]
	,[c].[dbLastUpdate]
    ,STUFF((
        select CONCAT(', ', Property)
        from ad.Computer c2
        join ad.UserAccountControl uac ON 
            c2.UserAccountControl & uac.ID = uac.ID
        where c.DNSHostName = c2.DNSHostName
        for xml path(''), type, root
        ).value('root[1]','varchar(max)'),
        1, 2, N'') as [AccountProperties]
    ,STUFF((
        select CONCAT(', ', [enc].[Description])
        from [ad].[Computer] c2
        join [ad].[SupportedEncryptionTypes] [enc] ON 
            c2.SupportedEncryptionTypes = enc.ID
        where [c].objectGUID = c2.objectGUID
        for xml path(''), type, root
        ).value('root[1]','varchar(max)'),
        1, 2, N'') as [SupportedEncryptionTypesDesc]
	,ISNULL([dc].[Type],'None') as [DomainController]
	,[laps].[AdmPwdExpiration]
	,CASE
		WHEN [cno].[DNSHostName] IS NULL THEN 0
		ELSE 1
	END AS [ClusterObject]
FROM 
	[ad].[Computer] [c] LEFT OUTER JOIN [ad].[DomainController] [dc] ON
		[c].[DNSHostName] = [dc].[DNSHostName]
	LEFT OUTER JOIN [ad].[LocalAdminPasswordSolution] [laps] ON
		[c].[objectGUID] = [laps].[objectGUID]
	LEFT OUTER JOIN ad.ClusterNamedObject cno ON
		[c].DNSHostName = [cno].[DNSHostName]