/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
/* Initialize dbo.ReportHeader
* Hugh Scott
* 2019/02/01
*/
BEGIN TRANSACTION;
INSERT INTO [dbo].[ReportHeader]([Id], [ReportName], [ReportDisplayName], [ReportBackground], [TitleBackground], [TitleFont], [TitleFontColor], [TitleFontSize], [SubTitleBackground], [SubTitleFont], [SubTitleFontColor], [SubTitleFontSize], [TableHeaderBackground], [TableHeaderFont], [TableHeaderFontColor], [TableHeaderFontSize], [TableFooterBackground], [TableFooterFont], [TableFooterFontColor], [TableFooterFontSize], [RowEvenBackground], [RowEvenFont], [RowEvenFontColor], [RowEvenFontSize], [RowOddBackground], [RowOddFont], [RowOddFontColor], [RowOddFontSize], [FooterBackground], [FooterFont], [FooterFontColor], [FooterFontSize], [dbAddDate], [dbModDate])
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', N'Dash_AlertAgingReport', N'Organizational Summary', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', '01/23/2019', '01/19/2019'
COMMIT;

BEGIN TRANSACTION;
INSERT INTO [dbo].[ReportContent]([ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemDisplay], [ItemParameters], [dbAddDate], [dbModDate])
-- Organization Summary By Area
-- Alert aging Dashboard
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 1, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Active Directory Team', N'Active Directory Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 2, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Team', N'Windows Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 3, N'#FFFFFF', N'Arial', N'10', N'#000000', N'DBA Team', N'DBA Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 4, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Web Team', N'Web Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 5, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Config Mgmt Team', N'Config Mgmt Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 6, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Network Team', N'Network Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 7, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Monitoring Team', N'Monitoring Team', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'2ef81f28-684e-4afa-b548-c7af441dce18', 8, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Unassigned', N'Unassigned', '03/11/2019', '03/11/2019'

COMMIT;
GO

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
CREATE PROC scom.spAgentExclusionsUpsert
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
GO


GRANT EXEC ON scom.spAgentExclusionsUpsert TO scomUpdate
GO

/*###########################################################################
# Script: dbo Permissions for scomRead
# Author: Hugh Scott
# Date: 2019/06/20
#
# Fix permissions for dbo schema for scomRead
############################################################################*/

GRANT SELECT ON SCHEMA::dbo TO scomRead
GO

/****************************************************************
* Name: dbo.spCurrentTimeZoneOffsetUpdate
* Author: huscott
* Date: 2019-07-02
*
* Description:
*
****************************************************************/
CREATE PROCEDURE dbo.spCurrentTimeZoneOffsetUpdate

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE dbo.Config
SET ConfigValue = (
	SELECT CurrentUTCOffset 
	FROM dbo.SystemTimeZone
	WHERE DisplayName = (SELECT ConfigValue FROM dbo.Config WHERE ConfigName = N'DefaultTimeZoneDisplayName')
)
WHERE ConfigName = N'DefaultTimeZoneCurrentOffset'

COMMIT
GO

GRANT EXEC ON dbo.spCurrentTimeZoneOffsetUpdate TO scomUpdate
GO