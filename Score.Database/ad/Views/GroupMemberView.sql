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
		UNION 
		SELECT [objectGUID], N'Computer' AS [adType], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[Computer] 
		) member ON
			gm.MemberGUID = member.objectGUID
