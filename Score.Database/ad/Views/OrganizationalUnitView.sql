
CREATE VIEW [ad].[OrganizationalUnitView]

AS

SELECT 
	[ou].objectGUID
	, [ou].Domain
	, [ou].[Name]
	, [ou].[Description]
	, [ou].[DistinguishedName]
	, [ou].[StreetAddress]
	, [ou].City
	, [ou].[State]
	, [ou].Country
	, [ou].[PostalCode]
	, [ou].[Protected]
	, [ou].[Active]
	, [ou].[whenCreated]
	, [ou].[whenChanged]
	, [ou].[dbAddDate]
	, [ou].[dbLastUpdate]
	, CASE 
		WHEN CHARINDEX('OU=',[ou].[DistinguishedName]) > 0 THEN RIGHT([ou].[DistinguishedName], (LEN([ou].[DistinguishedName]) - CHARINDEX('OU=',[ou].[DistinguishedName]))+1)
		ELSE REPLACE(RIGHT([ou].[DistinguishedName], (LEN([ou].[DistinguishedName]) - CHARINDEX('CN=',[ou].[DistinguishedName],2))+1),'CN=','OU=')
	  END as [OrganizationalUnit]
	 , RIGHT([DistinguishedName], LEN([DistinguishedName]) - CHARINDEX(',',[DistinguishedName])) as [ParentOrganizationalUnit]

FROM 
	ad.OrganizationalUnit [ou]