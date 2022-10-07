/****** Object:  View [cm].[ComputerGroupMemberView]    Script Date: 1/16/2019 8:32:48 AM ******/

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