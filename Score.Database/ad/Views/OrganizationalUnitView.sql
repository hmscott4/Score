CREATE VIEW ad.OrganizationalUnitView

AS

SELECT 
	objectGUID
	, Domain
	, [Name]
	, [Description]
	, [DistinguishedName]
	, [StreetAddress]
	, City
	, [State]
	, Country
	, [PostalCode]
	, [Protected]
	, [Active]
	, [whenCreated]
	, [whenChanged]
	, [dbAddDate]
	, [dbLastUpdate]

	 ,CASE 
		WHEN CHARINDEX('OU=',[ou].[DistinguishedName]) > 0 THEN RIGHT([ou].[DistinguishedName], (LEN([ou].[DistinguishedName]) - CHARINDEX('OU=',[ou].[DistinguishedName]))+1)
		ELSE REPLACE(RIGHT([ou].[DistinguishedName], (LEN([ou].[DistinguishedName]) - CHARINDEX('CN=',[ou].[DistinguishedName],2))+1),'CN=','OU=')
	  END as [OrganizationalUnit]
	  ,RIGHT([DistinguishedName], LEN([DistinguishedName]) - CHARINDEX(',',[DistinguishedName])) as [ParentOrganizationalUnit]

FROM 
	ad.OrganizationalUnit [ou]