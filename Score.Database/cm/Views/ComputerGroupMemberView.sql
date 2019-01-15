CREATE VIEW [cm].[ComputerGroupMemberView]

AS

SELECT
	[cgm].[ComputerGUID],
	[c].[dnsHostName], 
	[cgm].[GroupName],
	[cgm].[MemberName],
	[cgm].[Active],
	[cgm].[dbAddDate],
	[cgm].[dbLastUpdate]
FROM
	[cm].[ComputerGroupMember] cgm INNER JOIN [cm].[Computer] c
		ON c.objectGUID = cgm.ComputerGUID
