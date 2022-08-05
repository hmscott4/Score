CREATE VIEW [ad].[UserView]

AS

SELECT
	 [u].[objectGUID]
	 ,[u].[SID]
	 ,[u].[Domain]
	 ,[u].[Name]
	 ,[u].[FirstName]
	 ,[u].[LastName]
	 ,[u].[DisplayName]
	 ,[u].[Description]
	 ,[u].[JobTitle]
	 ,[u].[EmployeeNumber]
	 ,[u].[ProfilePath]
	 ,[u].[HomeDirectory]
	 ,[u].[Company]
	 ,[u].[Office]
	 ,[u].[Department]
	 ,[u].[Division]
	 ,[u].[StreetAddress]
	 ,[u].[City]
	 ,[u].[State]
	 ,[u].[PostalCode]
	 ,[u].[Manager]
	 ,[u].[MobilePhone]
	 ,[u].[PhoneNumber]
	 ,[u].[Fax]
	 ,[u].[Pager]
	 ,[u].[EMail]
	 ,[u].[LockedOut]
	 ,[u].[PasswordExpired]
	 ,[u].[PasswordLastSet]
	 ,[u].[PasswordNeverExpires]
	 ,[u].[PasswordNotRequired]
	 ,[u].[TrustedForDelegation]
	 ,[u].[TrustedToAuthForDelegation]
	 ,[u].[UserAccountControl]
	 ,[u].[SupportedEncryptionTypes]
	 ,[u].[DistinguishedName]
	 ,CASE 
		WHEN CHARINDEX('OU=',[u].[DistinguishedName]) > 0 THEN RIGHT([u].[DistinguishedName], (LEN([u].[DistinguishedName]) - CHARINDEX('OU=',[u].[DistinguishedName]))+1)
		ELSE REPLACE(RIGHT([u].[DistinguishedName], (LEN([u].[DistinguishedName]) - CHARINDEX('CN=',[u].[DistinguishedName],2))+1),'CN=','OU=')
	  END as [OrganizationalUnit]
	 ,[u].[Enabled]
	 ,[u].[Active]
	 ,[u].[LastLogon]
	 ,[u].[whenCreated]
	 ,[u].[whenChanged]
	 ,[u].[dbAddDate]
	 ,[u].[dbLastUpdate]
     ,STUFF((
        select CONCAT(', ', Property)
        from ad.[User] u2
        join ad.UserAccountControl uac ON 
            u2.UserAccountControl & uac.ID = uac.ID
        where u.[Name] = u2.[Name]
        for xml path(''), type, root
        ).value('root[1]','varchar(max)'),
        1, 2, N'') as AccountProperties
FROM 
	ad.[User] [u]