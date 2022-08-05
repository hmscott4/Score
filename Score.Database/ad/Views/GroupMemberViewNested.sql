CREATE VIEW [ad].[GroupMemberViewNested]

AS

WITH cte_GroupMember (	Domain
	,GroupGUID
	,MemberGUID
	,MemberType
	,Active
	,dbAddDate
	,dbLastUpdate
	,[Level]
	,[InheritsFrom])

AS

(
	SELECT
		[gm].[Domain]
		,[gm].[GroupGUID]
		,[gm].[MemberGUID]
		,[gm].[MemberType]
		,[gm].[Active]
		,[gm].[dbAddDate]
		,[gm].[dbLastUpdate]
		,0 as [Level]
		,CAST(N'' as nvarchar(1024)) as [InheritsFrom]
	FROM
		ad.GroupMember [gm] 

	UNION ALL

	SELECT
		[gm1].[Domain]
		,[gm1].[GroupGUID]
		,[gm2].[MemberGUID]
		,[gm2].[MemberType]
		,[gm2].[Active]
		,[gm2].[dbAddDate]
		,[gm2].[dbLastUpdate]
		,[Level] + 1 as [Level]
		,CAST(CONCAT([InheritsFrom], (SELECT [Name] FROM ad.[Group] WHERE [objectGUID] = [gm1].[MemberGUID]), ' : ') as NVARCHAR(1024))
	FROM
		ad.GroupMember [gm1] INNER JOIN ad.GroupMember [gm2] ON
			[gm1].[MemberGUID] = [gm2].[GroupGUID] 
		INNER JOIN cte_GroupMember [cte] ON
			[gm2].[GroupGUID] = [cte].[MemberGUID]
			--AND [gm].[MemberType] = N'group'
	WHERE
		[Level] <= 2

)

SELECT
	[gm].[GroupGUID],
	[gm].[MemberGUID],
	[gm].[Domain],
	[gm].[MemberType],
	[g].[Name] as [GroupName],
	[g].[Scope],
	[g].[Category],
	[g].[DistinguishedName] as [GroupDistinguishedName],
	-- [member].[adType],
	[member].[Domain] as [MemberDomain],
	[member].[Name] as [MemberName], 
	[member].[DistinguishedName] as [MemberDistinguishedName],
	[member].[Enabled] as [MemberEnabled],
	[member].[Active] as [MemberActive],
	[member].[whenCreated] as [MemberWhenCreated],
	[member].[whenChanged] as [MemberWhenChanged],
	[g].[whenCreated] as [GroupWhenCreated],
	[g].[whenChanged] as [GroupWhenChanged],
	[gm].[Level],
	[gm].[InheritsFrom]
FROM 
	[ad].[Group] g inner join [cte_GroupMember] gm ON
		gm.GroupGUID = g.objectGUID 
	INNER JOIN 
	   (SELECT [objectGUID], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[User]
		UNION ALL
		SELECT [objectGUID], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[Computer] 
		UNION ALL
		SELECT [objectGUID], [Domain], [Name], [DistinguishedName], 1 as [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[Group] 
		UNION ALL
		SELECT [objectGUID], [Domain], [Name], [DistinguishedName], [Enabled], [Active], [whenCreated], [whenChanged]
		FROM [ad].[ServiceAccount] 
		) member ON
			gm.MemberGUID = member.objectGUID
GO
GRANT SELECT
    ON OBJECT::[ad].[GroupMemberViewNested] TO [adRead]
    AS [dbo];

