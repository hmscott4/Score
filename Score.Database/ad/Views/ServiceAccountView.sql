CREATE VIEW [ad].[ServiceAccountView]

AS

SELECT
	 [sa].[objectGUID]
	 ,[sa].[SID]
	 ,[sa].[Domain]
	 ,[sa].[Name]
	 ,[sa].[DNSHostName]
	 ,[sa].[Trusted]
	 ,[sa].[Description]
	 ,[sa].[DistinguishedName]
	 ,CASE 
		WHEN CHARINDEX('OU=',[sa].[DistinguishedName]) > 0 THEN RIGHT([sa].[DistinguishedName], (LEN([sa].[DistinguishedName]) - CHARINDEX('OU=',[sa].[DistinguishedName]))+1)
		ELSE REPLACE(RIGHT([sa].[DistinguishedName], (LEN([sa].[DistinguishedName]) - CHARINDEX('CN=',[sa].[DistinguishedName],2))+1),'CN=','OU=')
	  END as [OrganizationalUnit]
	 ,[sa].[PrincipalsAllowedToRetrievePassword]
	 ,[sa].[UserAccountControl]
	 ,[sa].[ServicePrincipalNames]
	 ,[sa].[SupportedEncryptionTypes]
	 ,[sa].[Enabled]
	 ,[sa].[Active]
	 ,[sa].[LastLogon]
	 ,[sa].[whenCreated]
	 ,[sa].[whenChanged]
	 ,[sa].[dbAddDate]
	 ,[sa].[dbLastUpdate]
    ,STUFF((
        select CONCAT(', ', [enc].[Description])
        from [ad].[ServiceAccount] sa2
        join [ad].[SupportedEncryptionTypes] [enc] ON 
            sa2.UserAccountControl & enc.ID = enc.ID
        where [sa].[objectGUID] = [sa2].[objectGUID]
        for xml path(''), type, root
        ).value('root[1]','varchar(max)'),
        1, 2, N'') as [SupportedEncryptionTypesDesc]
FROM
	[ad].[ServiceAccount] [sa]