/****************************************************************
* Name: scom.spAgentExclusionsInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAgentExclusionsInsert]

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN


/************************** DISTINGUISHED NAME ***************************************/
-- INSERT INTO scom.AgentExclusions (Domain, DNSHostName, Reason, dbAddDate, dbLastUpdate)
-- SELECT Domain, DNSHostName, 'Managed by other', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
-- FROM ad.Computer
-- WHERE DistinguishedName LIKE N'%OU=DOE%'
-- AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)
/************************** DISTINGUISHED NAME ***************************************/

/************************** DNS HOST NAME *******************************************/
-- INSERT INTO scom.AgentExclusions
-- SELECT Domain, DNSHostName, 'Citrix Workstation', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
-- FROM ad.Computer
-- WHERE DNSHostName LIKE N'%CTXWK%'
-- AND DNSHostName NOT IN (SELECT DNSHostName FROM scom.AgentExclusions)

/************************** DNS HOST NAME *******************************************/


COMMIT