CREATE VIEW ad.GroupView

AS

SELECT
	g.objectGUID
	, g.[SID]
	, g.Domain
	, g.[Name]
	, g.Scope
	, g.Category
	, g.Description
	, g.Email
	, g.DistinguishedName
	, CASE 
		WHEN CHARINDEX('OU=',[g].[DistinguishedName]) > 0 THEN RIGHT([g].[DistinguishedName], (LEN([g].[DistinguishedName]) - CHARINDEX('OU=',[g].[DistinguishedName]))+1)
		ELSE REPLACE(RIGHT([g].[DistinguishedName], (LEN([g].[DistinguishedName]) - CHARINDEX('CN=',[g].[DistinguishedName],2))+1),'CN=','OU=')
	  END as [OrganizationalUnit]
	, gs.Sensitivity
	, g.whenCreated
	, g.whenChanged
	, g.Active
	, g.dbAddDate
	, g.dbLastUpdate
FROM
	[ad].[Group] g LEFT OUTER JOIN [ad].[GroupSensitivity] gs ON
		(g.Domain = gs.Domain OR gs.Domain = 'ALL')
		AND g.[Name] = gs.[GroupName]