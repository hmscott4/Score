/****** Object:  StoredProcedure [scom].[spAgentExclusionsInsert]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [scom].[spAgentExclusionsInsert]

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN


/************************** DISTINGUISHED NAME ***************************************/
INSERT INTO scom.AgentExclusions (Domain, DNSHostName, Reason, dbAddDate, dbLastUpdate)
SELECT Domain, DNSHostName, 'DISA Managed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DistinguishedName LIKE N'%OU=DOE%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'DISA Managed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DistinguishedName LIKE N'%OU=eWorkPlace%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'DISA Managed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DistinguishedName LIKE N'%OU=PKI Servers%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

/************************** DNS HOST NAME *******************************************/
INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'Citrix Workstation', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DNSHostName LIKE N'%CTXWK%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'Citrix Admin Workstation', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DNSHostName LIKE N'%CTXADM%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'Citrix Application Server', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DNSHostName LIKE N'%CTXAPP%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'Citrix Test Server', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DNSHostName LIKE N'%CTXT%'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'SCOM Test Server', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DNSHostName = N'DA01TSCOM01.DIR.AD.DLA.MIL'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

INSERT INTO scom.AgentExclusions
SELECT Domain, DNSHostName, 'SCORCH Test Server', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM ad.Computer
WHERE DNSHostName = N'DA01TSCOR01.DIR.AD.DLA.MIL'
AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

COMMIT
GO