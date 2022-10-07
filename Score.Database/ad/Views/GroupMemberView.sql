


CREATE VIEW [ad].[GroupMemberView]

AS

SELECT
	[gm].[GroupGUID],
	[gm].[MemberGUID],
	[gm].[Domain],
	[gm].[MemberType],
	[g].[Name] as [GroupName],
	[g].[Scope],
	[g].[Category],
	[g].[DistinguishedName] as [GroupDistinguishedName],
	[member].[adType],
	[member].[Domain] as [MemberDomain],
	[member].[Name] as [MemberName], 
	[member].[DistinguishedName] as [MemberDistinguishedName],
	[member].[Enabled] as [MemberEnabled],
	[member].[Active] as [MemberActive],
	[member].[whenCreated] as [MemberWhenCreated],
	[member].[whenChanged] as [MemberWhenChanged],
	[g].[whenCreated] as [GroupWhenCreated],
	[g].[whenChanged] as [GroupWhenChanged]
FROM 
	[ad].[Group] g inner join [ad].[GroupMember] gm ON
		gm.GroupGUID = g.objectGUID 
	INNER JOIN 
	   (SELECT [objectGUID], N'User' AS [adType], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[User]
		UNION ALL

		SELECT [objectGUID], N'Computer' AS [adType], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[Computer] 
		UNION ALL

		SELECT [objectGUID], N'Group' AS [adType], [Domain], [Name], [DistinguishedName], 1 as [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[Group]  
		UNION ALL

		SELECT [objectGUID], N'ServiceAccount' AS [adType], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[ServiceAccount] 
		) member ON
			gm.MemberGUID = member.objectGUID