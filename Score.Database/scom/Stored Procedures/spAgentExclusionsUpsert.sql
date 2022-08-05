/****************************************************************
* Name: scom.spAgentExclusionsUpsert
* Author: huscott
* Date: 2019-06-20
*
* Description:
* Insert entries into scom.AgentExlusions table
* Used to exclude selected computer objects (like Cluster named objects) from Agent deployment count
*
****************************************************************/
CREATE PROC [scom].[spAgentExclusionsUpsert]
(@Domain nvarchar(128),
 @DNSHostName nvarchar(255),
 @Reason nvarchar(1024),
 @dbLastUpdate datetime2(3)
 )

 AS

 SET NOCOUNT ON
 SET XACT_ABORT ON

 IF EXISTS (SELECT DNSHostName FROM scom.AgentExclusions WHERE (Domain = @Domain AND [DNSHostName] = @DNSHostName))
BEGIN
	UPDATE scom.AgentExclusions
	SET dbLastUpdate = @dbLastUpdate
	WHERE Domain = @Domain 
		AND DNSHostName = @DNSHostName
END

ELSE

BEGIN
	INSERT INTO scom.AgentExclusions (Domain, DNSHostName, Reason, dbAddDate, dbLastUpdate)
	VALUES (@Domain, @DNSHostName, @Reason, @dbLastUpdate, @dbLastUpdate)
END


grant exec on scom.spAgentExclusionsUpsert to scomUpdate

GO
GRANT EXECUTE
    ON OBJECT::[scom].[spAgentExclusionsUpsert] TO [scomUpdate]
    AS [dbo];

