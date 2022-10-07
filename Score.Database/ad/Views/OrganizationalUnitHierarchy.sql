CREATE VIEW ad.OrganizationalUnitHierarchy

AS

WITH CTE_OrgHierarchy ([Level], [Name], [Domain], [DistinguishedName], ParentOrganizationalUnit, Active, dbAddDate, dbLastUpdate)

AS

(
	SELECT 
		0 as [Level]
		, CAST([NETBiosName] as nvarchar(255)) as [Name]
		,DNSRoot as [Domain]
		, CAST([DistinguishedName] as nvarchar(1024)) as DistinguishedName
		, CAST([DistinguishedName] as nvarchar(1024)) as [ParentOrganizationalUnit]
		, [Active]
		, [dbAddDate]
		, [dbLastUpdate]
	FROM
		ad.Domain ou
		

	UNION ALL

	SELECT
		[cte].[Level] + 1
		, [ou].[Name]
		, [ou].[Domain]
		, [ou].[DistinguishedName]
		, [ou].[ParentOrganizationalUnit]
		, [ou].[Active]
		, [ou].[dbAddDate]
		, [ou].[dbLastUpdate]
	FROM 
		ad.OrganizationalUnitView ou inner join CTE_OrgHierarchy cte ON
			ou.ParentOrganizationalUnit = cte.[DistinguishedName]
)

SELECT 
	[Level]
	, [Domain]
	, [Name]
	, DistinguishedName as [OrganizationalUnit]
	, ParentOrganizationalUnit
	, [Active]
	, [dbAddDate]
	, [dbLastUpdate]
FROM CTE_OrgHierarchy