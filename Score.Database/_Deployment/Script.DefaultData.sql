/*
2019/02/12
SCORE Create
Hugh Scott
--------------------------------------------------------------------------------------
 This script contains insert statements for default data
 1. Run this script after the database is created
 2. Customize the data after intitial deployment (e.g. Organization Name)
--------------------------------------------------------------------------------------
*/
/* Initialize dbo.Config
* Hugh Scott
* 2019/02/01
*/

INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'ProcessLogRetainDays', N'90', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'SyncHistoryRetainDays', N'90', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'EventLogRetainDays', N'7', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DatabaseSizeDailyRetainDays', N'1825', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DatabaseSizeRawRetainDays', N'30', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'LogicalVolumeSizeDailyRetainDays', N'1825', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'LogicalVolumeSizeRawRetainDays', N'30', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'WebApplicationResponseDailyRetainDays', N'365', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'WebApplicationResponseRawRetainDays', N'30', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'ConfigurationHistoryRetainDays', N'21', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'StoreConfigurationHistory', N'1', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DefaultTimeZoneDisplayName', N'(UTC-05:00) Eastern Time (US & Canada)', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'OrganizationDisplayName', N'ABCD Corporation', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DefaultTimeZoneCurrentOffset', N'-300', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DefaultTimeZone', N'Eastern Time Zone', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO

/* Initialize scom.MaintenanceReasonCode
* Hugh Scott
* 2019/02/01
*/
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (0, N'Other (Planned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (1, N'Other (Unplanned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (2, N'Hardware: Maintenance (Planned0', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (3, N'Hardware: Maintenance (Unplanned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (4, N'Hardware: Installation (Planned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (5, N'Hardware: Installation (Unplanned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (6, N'Operating System: Reconfiguration (Planned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (7, N'Operating System: Reconfiguration (Unplanned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (9, N'Application: Maintenance (Planned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (10, N'Application: Installation (Planned)', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (11, N'Application: Unresponsive', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (12, N'Application: Unstable', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (13, N'Security Issue', 1, GETDATE(), GETDATE())
GO
INSERT INTO [scom].[MaintenanceReasonCode] ([ReasonCode], [Reason], [Active], [dbAddDate], [dbModDate]) VALUES (14, N'Loss of network connectivity (Unplanned)', 1, GETDATE(), GETDATE())
GO

/* Initialize scom.ObjectClass
* Hugh Scott
* 2019/02/01
*/
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'722594ba-bc11-45d5-81a2-a6059ada4682', N'Microsoft.SQLServer.Windows.Database', N'MSSQL on Windows: Database', N'SQL Database', N'Microsoft.SQLServer.Windows.Discovery', N'SQL Database', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'8def7ccc-ca28-c7ef-796f-644160e0b22a', N'Microsoft.SQLServer.Windows.DBEngine', N'MSSQL on Windows: DB Engine', N'SQL DB Engine', N'Microsoft.SQLServer.Windows.Discovery', N'SQL DB Engine', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'6b1d1be8-ebb4-b425-08dc-2385c5930b04', N'Microsoft.SystemCenter.ManagementGroup', N'Operations Manager Management Group', N'Operations Manager Management Group', N'Microsoft.SystemCenter.Library', N'Operations Manager Management Group', 1, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'360e5a02-bc9e-0000-2614-1972e304088a', N'Microsoft.Unix.Computer', N'UNIX/Linux Computer', N'UNIX/Linux Computer', N'Microsoft.Unix.Library', N'UNIX/Linux Computer', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'627f4dff-40f7-89d6-6d0d-71102b6e8cea', N'Microsoft.Windows.Cluster', N'Windows Cluster', N'Windows Cluster', N'Microsoft.Windows.Cluster.Library', N'Windows Cluster', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'c2dbd9a8-c677-5ec7-735e-bc703e84b743', N'Microsoft.Windows.InternetInformationServices.WebServer', N'IIS Web Server', N'IIS Web Server', N'Microsoft.Windows.InternetInformationServices.CommonLibrary', N'IIS Web Server', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'294f206e-08aa-6dc1-1bd7-a72ce272f365', N'Microsoft.Windows.InternetInformationServices.WebSite', N'IIS Web Site', N'IIS Web Site', N'Microsoft.Windows.InternetInformationServices.CommonLibrary', N'IIS Web Site', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'40aa6fa1-a799-1dba-255c-d8d3ab8b33b6', N'Microsoft.Windows.Server.AD.Library.DomainControllerRole', N'Active Directory Domain Controller Computer Role', N'Domain Controller', N'Microsoft.Windows.Server.AD.Class.Library', N'Active Directory Domain Controller', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'adf4f2cc-8380-9b9b-532e-20306371d65a', N'Microsoft.Windows.Server.AD.Library.Site', N'Active Directory Site', N'Active Directory Site', N'Microsoft.Windows.Server.AD.Class.Library', N'Active Directory Site', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'8e0d6b90-4918-8db1-6dd2-89f5262133c7', N'Microsoft.Windows.Server.AD.Site', N'Active Directory Site', N'Active Directory Site', N'Microsoft.Windows.Server.AD.Library', N'Microsoft.Windows.Server.AD.Library', 0, 0, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'10f38c20-64e5-06ea-6e54-a18c9226e0a3', N'Microsoft.Windows.Server.ClusterDisksMonitoring.ClusterDisk', N'Cluster Disk', N'Windows Logical Disk', N'Microsoft.Windows.Server.ClusterSharedVolumeMonitoring', N'Windows Logical Disk', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'193cbd06-cbe3-e1fa-cb80-2773e7e772c9', N'Microsoft.Windows.Server.ClusterSharedVolumeMonitoring.ClusterSharedVolume', N'Cluster Shared Volume', N'Windows Logical Disk', N'Microsoft.Windows.Server.ClusterSharedVolumeMonitoring', N'Windows Logical Disk', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'e817d034-02e8-294c-3509-01ca25481689', N'Microsoft.Windows.Server.Computer', N'Windows Server', N'Windows Server', N'Microsoft.Windows.Library', N'Windows Server', 0, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[ObjectClass] ([ID], [Name], [DisplayName], [GenericName], [ManagementPackName], [Description], [DistributedApplication], [Active], [dbAddDate], [dbLastUpdate]) VALUES (N'486adddb-2eb8-819a-fa24-8f6ab3e29543', N'Microsoft.Windows.Server.LogicalDisk', N'Logical Disk (Server)', N'Windows Logical Disk', N'Microsoft.Windows.Server.Library', N'Windows Logical Disk', 0, 1, GETDATE(), GETDATE())
GO

/* Initialize scom.AlertAgingBuckets
* Hugh Scott
* 2019/02/01
*/
SET IDENTITY_INSERT [scom].[AlertAgingBuckets] ON 
GO
INSERT [scom].[AlertAgingBuckets] ([AgeID], [LowValue], [HighValue], [Label], [SortOrder], [Active], [dbAddDate], [dbLastUpdate]) VALUES (1, 0, 24, N'<24', 1, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[AlertAgingBuckets] ([AgeID], [LowValue], [HighValue], [Label], [SortOrder], [Active], [dbAddDate], [dbLastUpdate]) VALUES (2, 24, 72, N'24-72', 2, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[AlertAgingBuckets] ([AgeID], [LowValue], [HighValue], [Label], [SortOrder], [Active], [dbAddDate], [dbLastUpdate]) VALUES (3, 72, 168, N'72-168', 3, 1, GETDATE(), GETDATE())
GO
INSERT [scom].[AlertAgingBuckets] ([AgeID], [LowValue], [HighValue], [Label], [SortOrder], [Active], [dbAddDate], [dbLastUpdate]) VALUES (4, 168, 1000000, N'>WEEK', 4, 1, GETDATE(), GETDATE())
GO
SET IDENTITY_INSERT [scom].[AlertAgingBuckets] OFF
GO

/* Initialize dbo.ReportHeader
* Hugh Scott
* 2019/02/01
*/
BEGIN TRANSACTION;
INSERT INTO [dbo].[ReportHeader]([Id], [ReportName], [ReportDisplayName], [ReportBackground], [TitleBackground], [TitleFont], [TitleFontColor], [TitleFontSize], [SubTitleBackground], [SubTitleFont], [SubTitleFontColor], [SubTitleFontSize], [TableHeaderBackground], [TableHeaderFont], [TableHeaderFontColor], [TableHeaderFontSize], [TableFooterBackground], [TableFooterFont], [TableFooterFontColor], [TableFooterFontSize], [RowEvenBackground], [RowEvenFont], [RowEvenFontColor], [RowEvenFontSize], [RowOddBackground], [RowOddFont], [RowOddFontColor], [RowOddFontSize], [FooterBackground], [FooterFont], [FooterFontColor], [FooterFontSize], [dbAddDate], [dbModDate])
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', N'Dash_OrganizationSummaryByArea', N'Organizational Summary By Area', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'88586f14-ec03-4be5-aad9-47133b42548c', N'Dash_OrganizationSummaryByGroup', N'Organizational Summary By Group', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'133ae6f5-30df-4818-8ef7-bb46f25f58f4', N'<default>', N'<default>', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', N'Dash_OrganizationSummary', N'Organizational Summary', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', '01/23/2019', '01/19/2019'
COMMIT;
RAISERROR (N'[dbo].[ReportHeader]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

/* Initialize dbo.ReportContent
* Hugh Scott
* 2019/02/01
*/
BEGIN TRANSACTION;
INSERT INTO [dbo].[ReportContent]([ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemDisplay], [ItemParameters], [dbAddDate], [dbModDate])
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 1, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Domain Controller', N'Domain Controller', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 5, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Active Directory Site', N'Active Directory Site', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 2, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server', N'Windows Server', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 3, N'#FFFFFF', N'Arial', N'10', N'#000000', N'SQL DB Engine', N'SQL DB Engine', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 4, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Cluster', N'Windows Cluster', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 6, N'#FFFFFF', N'Arial', N'10', N'#000000', N'UNIX/Linux Computer', N'UNIX/Linux Computer', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'f5772c15-ad25-446c-96f4-2a21e4073321', 7, N'#FFFFFF', N'Arial', N'10', N'#000000', N'IIS Web Site', N'IIS Web Site', '01/23/2019', '01/23/2019' UNION ALL
SELECT N'88586f14-ec03-4be5-aad9-47133b42548c', 1, N'#FFFFFF', N'Arial', N'10', N'#000000', N'All Windows Computers', N'All Windows Computers', '03/08/2019', '03/08/2019' UNION ALL
SELECT N'88586f14-ec03-4be5-aad9-47133b42548c', 2, N'#FFFFFF', N'Arial', N'10', N'#000000', N'IIS Computer Group', N'IIS Computer Group', '03/08/2019', '03/08/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 11, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Organization Summary By Area', N'Dash_OrganizationSummaryByArea', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 12, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Active Directory Server Coverage', N'Dash_ServerSummary', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 13, N'#FFFFFF', N'Arial', N'10', N'#000000', N'SQL Server Summary', N'Dash_OrganizationSummary_SQL', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 14, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Alert Aging Report', N'Dash_AlertAgingReport', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 15, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Organization Summary By Group', N'Dash_OrganizationSummaryByGroup', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 21, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server Top 10 Performance', N'List_WindowsServersTopNPerf;All Windows Computers', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 22, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server Logical Disk', N'Dash_OrganizationSummary_WindowsLogicalDisk', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 23, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server Details', N'List_WindowsServers', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 24, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server Utilization', N'List_ServerUtilization', '03/11/2019', '03/11/2019' UNION ALL
SELECT N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', 25, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server Scheduled Maintenance', N'Chart_ServerMaintenanceMode', '03/11/2019', '03/11/2019'
COMMIT;
RAISERROR (N'[dbo].[ReportContent]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

/* Initialize dbo.SystemTimeZone
* Hugh Scott
* 2019/02/01
*/

BEGIN TRANSACTION;
INSERT INTO [dbo].[SystemTimeZone]([ZoneID], [ID], [DisplayName], [StandardName], [DaylightName], [BaseUTCOffset], [CurrentUTCOffset], [SupportsDaylightSavingTime], [Display], [DefaultTimeZone], [Active], [dbAddDate], [dbLastUpdate])
VALUES (N'c6008104-4331-4323-8653-01cb1208f6ca', N'Newfoundland Standard Time', N'(UTC-03:30) Newfoundland', N'Newfoundland Standard Time', N'Newfoundland Daylight Time', -210, -210, 1, 0, 0, 1, GetDate(), GetDate()),
(N'9244b0ec-349a-4370-85a3-053b71b3d47e', N'Russia Time Zone 3', N'(UTC+04:00) Izhevsk, Samara', N'Russia TZ 3 Standard Time', N'Russia TZ 3 Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'683761c2-b58d-4d6c-ba00-0573297fcf62', N'Taipei Standard Time', N'(UTC+08:00) Taipei', N'Taipei Standard Time', N'Taipei Daylight Time', 480, 480, 0, 0, 0, 1, GetDate(), GetDate()),
(N'4ce1468d-6eb4-403e-b99a-0721f5a1bcda', N'N. Central Asia Standard Time', N'(UTC+07:00) Novosibirsk', N'Novosibirsk Standard Time', N'Novosibirsk Daylight Time', 420, 420, 1, 0, 0, 1, GetDate(), GetDate()),
(N'3c9cd998-642f-44c9-9dc4-07809a4f054c', N'Bahia Standard Time', N'(UTC-03:00) Salvador', N'Bahia Standard Time', N'Bahia Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'9980481c-ace4-49df-b469-07c591b3c0e8', N'Chatham Islands Standard Time', N'(UTC+12:45) Chatham Islands', N'Chatham Islands Standard Time', N'Chatham Islands Daylight Time', 765, 825, 1, 0, 0, 1, GetDate(), GetDate()),
(N'a21543c5-f166-4d8a-b1dc-07f92ccae71d', N'Arab Standard Time', N'(UTC+03:00) Kuwait, Riyadh', N'Arab Standard Time', N'Arab Daylight Time', 180, 180, 0, 0, 0, 1, GetDate(), GetDate()),
(N'daa528c8-a97c-4f38-b8fe-0bdaf45e2941', N'Mountain Standard Time (Mexico)', N'(UTC-07:00) Chihuahua, La Paz, Mazatlan', N'Mountain Standard Time (Mexico)', N'Mountain Daylight Time (Mexico)', -420, -420, 1, 0, 0, 1, GetDate(), GetDate()),
(N'badde940-8e6f-4434-9a4d-0cf14c1446e2', N'Libya Standard Time', N'(UTC+02:00) Tripoli', N'Libya Standard Time', N'Libya Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'768296b9-7445-4420-be09-0d1f51d133b1', N'E. Australia Standard Time', N'(UTC+10:00) Brisbane', N'E. Australia Standard Time', N'E. Australia Daylight Time', 600, 600, 0, 0, 0, 1, GetDate(), GetDate()),
(N'7defbe41-4fd8-47e2-8660-11f8f054c432', N'UTC-11', N'(UTC-11:00) Coordinated Universal Time-11', N'UTC-11', N'UTC-11', -660, -660, 0, 0, 0, 1, GetDate(), GetDate()),
(N'c6201d45-df56-44df-a7f0-1367b4dc65bc', N'Caucasus Standard Time', N'(UTC+04:00) Yerevan', N'Caucasus Standard Time', N'Caucasus Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'b5013251-6757-4283-beb7-14dd3d3c8875', N'Russia Time Zone 11', N'(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky', N'Russia TZ 11 Standard Time', N'Russia TZ 11 Daylight Time', 720, 720, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ecc9ff0b-2461-4b92-a03e-155e843fd35d', N'Paraguay Standard Time', N'(UTC-04:00) Asuncion', N'Paraguay Standard Time', N'Paraguay Daylight Time', -240, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'56188775-c8b5-4f72-ae9e-15f975f505f8', N'Central Europe Standard Time', N'(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague', N'Central Europe Standard Time', N'Central Europe Daylight Time', 60, 60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'7294523a-523b-450f-bd69-16c0dbcf0eec', N'Sakhalin Standard Time', N'(UTC+11:00) Sakhalin', N'Sakhalin Standard Time', N'Sakhalin Daylight Time', 660, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'56fd1d94-f13f-4652-b83c-17ca936c47e9', N'W. Central Africa Standard Time', N'(UTC+01:00) West Central Africa', N'W. Central Africa Standard Time', N'W. Central Africa Daylight Time', 60, 60, 0, 0, 0, 1, GetDate(), GetDate()),
(N'5b96bc0c-126c-4b53-89c8-1b03960f2951', N'Dateline Standard Time', N'(UTC-12:00) International Date Line West', N'Dateline Standard Time', N'Dateline Daylight Time', -720, -720, 0, 0, 0, 1, GetDate(), GetDate()),
(N'05e7905a-1b5b-491c-a6b1-1b44c350abfe', N'North Asia Standard Time', N'(UTC+07:00) Krasnoyarsk', N'Russia TZ 6 Standard Time', N'Russia TZ 6 Daylight Time', 420, 420, 1, 0, 0, 1, GetDate(), GetDate()),
(N'aae62a04-8d0a-46d1-b283-1d1f82f32fd2', N'Atlantic Standard Time', N'(UTC-04:00) Atlantic Time (Canada)', N'Atlantic Standard Time', N'Atlantic Daylight Time', -240, -240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'70381008-4023-4582-83c5-2068a0fa8cff', N'Saint Pierre Standard Time', N'(UTC-03:00) Saint Pierre and Miquelon', N'Saint Pierre Standard Time', N'Saint Pierre Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'e8d6289b-ed00-4a4d-a063-26b5240dc0f2', N'Arabian Standard Time', N'(UTC+04:00) Abu Dhabi, Muscat', N'Arabian Standard Time', N'Arabian Daylight Time', 240, 240, 0, 0, 0, 1, GetDate(), GetDate()),
(N'2982851f-05f5-493f-b30f-26dd13138b67', N'Canada Central Standard Time', N'(UTC-06:00) Saskatchewan', N'Canada Central Standard Time', N'Canada Central Daylight Time', -360, -360, 0, 0, 0, 1, GetDate(), GetDate()),
(N'7f699767-4200-434b-891b-2b40f0e27ace', N'Lord Howe Standard Time', N'(UTC+10:30) Lord Howe Island', N'Lord Howe Standard Time', N'Lord Howe Daylight Time', 630, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'1d96589e-cee5-45b6-b483-2c535edd8fa4', N'Pacific Standard Time (Mexico)', N'(UTC-08:00) Baja California', N'Pacific Standard Time (Mexico)', N'Pacific Daylight Time (Mexico)', -480, -480, 1, 0, 0, 1, GetDate(), GetDate()),
(N'52a1186e-2d03-428f-a9e8-2e8e784e71db', N'Greenwich Standard Time', N'(UTC+00:00) Monrovia, Reykjavik', N'Greenwich Standard Time', N'Greenwich Daylight Time', 0, 0, 0, 0, 0, 1, GetDate(), GetDate()),
(N'e0e048d3-98ae-4113-a91c-324fa53be9b3', N'Transbaikal Standard Time', N'(UTC+09:00) Chita', N'Transbaikal Standard Time', N'Transbaikal Daylight Time', 540, 540, 1, 0, 0, 1, GetDate(), GetDate()),
(N'a455fdea-baf0-4f0d-915b-34e5f6a2e1ef', N'Cen. Australia Standard Time', N'(UTC+09:30) Adelaide', N'Cen. Australia Standard Time', N'Cen. Australia Daylight Time', 570, 630, 1, 0, 0, 1, GetDate(), GetDate()),
(N'87b8e33e-572b-4e23-8fa0-35b1f391a954', N'Kamchatka Standard Time', N'(UTC+12:00) Petropavlovsk-Kamchatsky - Old', N'Kamchatka Standard Time', N'Kamchatka Daylight Time', 720, 720, 1, 0, 0, 1, GetDate(), GetDate()),
(N'7d3536af-9721-42ba-960b-3658236b994e', N'E. South America Standard Time', N'(UTC-03:00) Brasilia', N'E. South America Standard Time', N'E. South America Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'9ba1ae76-e064-4851-acb7-37f7354ec66f', N'Eastern Standard Time', N'(UTC-05:00) Eastern Time (US & Canada)', N'Eastern Standard Time', N'Eastern Daylight Time', -300, -300, 1, 1, 1, 1, GetDate(), GetDate()),
(N'488a973e-0ba1-4971-9156-394f4b51fe29', N'Arabic Standard Time', N'(UTC+03:00) Baghdad', N'Arabic Standard Time', N'Arabic Daylight Time', 180, 180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'6c7e506f-66bb-4a4d-8a83-3a9d339f9f7f', N'Pakistan Standard Time', N'(UTC+05:00) Islamabad, Karachi', N'Pakistan Standard Time', N'Pakistan Daylight Time', 300, 300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'8a9f43d9-177c-4da1-bf8d-3aaa01d7aacf', N'Magallanes Standard Time', N'(UTC-03:00) Punta Arenas', N'Magallanes Standard Time', N'Magallanes Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'0526fad4-7553-4268-9253-4141c532a13d', N'Egypt Standard Time', N'(UTC+02:00) Cairo', N'Egypt Standard Time', N'Egypt Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'f0ff073a-fec2-4f7b-9c35-4c3b7d411b9e', N'Namibia Standard Time', N'(UTC+02:00) Windhoek', N'Namibia Standard Time', N'Namibia Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'0496293d-3f3d-4e0a-ad24-4caa070b06e7', N'Mountain Standard Time', N'(UTC-07:00) Mountain Time (US & Canada)', N'Mountain Standard Time', N'Mountain Daylight Time', -420, -420, 1, 1, 0, 1, GetDate(), GetDate()),
(N'e774dff4-ab5d-4ff6-9905-5169c05711d7', N'W. Mongolia Standard Time', N'(UTC+07:00) Hovd', N'W. Mongolia Standard Time', N'W. Mongolia Daylight Time', 420, 420, 1, 0, 0, 1, GetDate(), GetDate()),
(N'751092c5-0350-4e97-8752-54bc6699735e', N'West Asia Standard Time', N'(UTC+05:00) Ashgabat, Tashkent', N'West Asia Standard Time', N'West Asia Daylight Time', 300, 300, 0, 0, 0, 1, GetDate(), GetDate()),
(N'084259bd-a66a-4da1-9525-55e5976266a2', N'GMT Standard Time', N'(UTC+00:00) Dublin, Edinburgh, Lisbon, London', N'GMT Standard Time', N'GMT Daylight Time', 0, 0, 1, 0, 0, 1, GetDate(), GetDate()),
(N'157f0bd4-2fe5-4db3-9d33-569cc1fa5bc1', N'Georgian Standard Time', N'(UTC+04:00) Tbilisi', N'Georgian Standard Time', N'Georgian Daylight Time', 240, 240, 0, 0, 0, 1, GetDate(), GetDate()),
(N'f78fbcfc-8859-43b5-a337-56c6ed1263b6', N'US Mountain Standard Time', N'(UTC-07:00) Arizona', N'US Mountain Standard Time', N'US Mountain Daylight Time', -420, -420, 0, 0, 0, 1, GetDate(), GetDate()),
(N'9459fa95-9ee9-4d06-a63e-57243bb1f3b2', N'Tasmania Standard Time', N'(UTC+10:00) Hobart', N'Tasmania Standard Time', N'Tasmania Daylight Time', 600, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'be1867d2-607b-418f-a2e0-5984cfab9f77', N'West Bank Standard Time', N'(UTC+02:00) Gaza, Hebron', N'West Bank Gaza Standard Time', N'West Bank Gaza Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'c2776c22-f2e7-4c5c-a6e9-59c71b5ac73c', N'Astrakhan Standard Time', N'(UTC+04:00) Astrakhan, Ulyanovsk', N'Astrakhan Standard Time', N'Astrakhan Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'1c0eeb02-b8ed-4095-a3a7-59fe8ef49850', N'Azores Standard Time', N'(UTC-01:00) Azores', N'Azores Standard Time', N'Azores Daylight Time', -60, -60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'68ebc221-bc79-4f1d-ad8f-5a167277a3d8', N'Sao Tome Standard Time', N'(UTC+01:00) Sao Tome', N'Sao Tome Standard Time', N'Sao Tome Daylight Time', 60, 60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'fbf504cf-bd2c-4ce1-a399-5d3cb27cfd51', N'Iran Standard Time', N'(UTC+03:30) Tehran', N'Iran Standard Time', N'Iran Daylight Time', 210, 210, 1, 0, 0, 1, GetDate(), GetDate()),
(N'f6f65dec-3639-46af-9d5e-5db3092635c3', N'Greenland Standard Time', N'(UTC-03:00) Greenland', N'Greenland Standard Time', N'Greenland Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'932f9286-08c4-4bcc-bc2a-5edcc1529dbc', N'Middle East Standard Time', N'(UTC+02:00) Beirut', N'Middle East Standard Time', N'Middle East Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate())
COMMIT;
RAISERROR (N'[dbo].[SystemTimeZone]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[SystemTimeZone]([ZoneID], [ID], [DisplayName], [StandardName], [DaylightName], [BaseUTCOffset], [CurrentUTCOffset], [SupportsDaylightSavingTime], [Display], [DefaultTimeZone], [Active], [dbAddDate], [dbLastUpdate])
VALUES (N'45ea38a3-784d-4327-8610-612888be57a0', N'Venezuela Standard Time', N'(UTC-04:00) Caracas', N'Venezuela Standard Time', N'Venezuela Daylight Time', -240, -240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'd09f2744-9f46-4f87-b430-6198ffeb3444', N'Syria Standard Time', N'(UTC+02:00) Damascus', N'Syria Standard Time', N'Syria Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ec07b999-bf46-41c6-98e2-61a6be7d5f58', N'Central Pacific Standard Time', N'(UTC+11:00) Solomon Is., New Caledonia', N'Central Pacific Standard Time', N'Central Pacific Daylight Time', 660, 660, 0, 0, 0, 1, GetDate(), GetDate()),
(N'72bf80ad-4cfe-41c5-ab83-62c4def3f5fe', N'Afghanistan Standard Time', N'(UTC+04:30) Kabul', N'Afghanistan Standard Time', N'Afghanistan Daylight Time', 270, 270, 0, 0, 0, 1, GetDate(), GetDate()),
(N'1ef1f84d-0f30-4a6b-863a-694ad685855d', N'Fiji Standard Time', N'(UTC+12:00) Fiji', N'Fiji Standard Time', N'Fiji Daylight Time', 720, 720, 1, 0, 0, 1, GetDate(), GetDate()),
(N'c7513199-a7f6-40f0-b713-6950e494f18f', N'China Standard Time', N'(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi', N'China Standard Time', N'China Daylight Time', 480, 480, 0, 0, 0, 1, GetDate(), GetDate()),
(N'25532d31-2cde-41a1-8d2e-6b5a0a974c4e', N'Line Islands Standard Time', N'(UTC+14:00) Kiritimati Island', N'Line Islands Standard Time', N'Line Islands Daylight Time', 840, 840, 0, 0, 0, 1, GetDate(), GetDate()),
(N'26836fba-4986-4723-88e2-6d030ea8fbf6', N'Pacific Standard Time', N'(UTC-08:00) Pacific Time (US & Canada)', N'Pacific Standard Time', N'Pacific Daylight Time', -480, -480, 1, 1, 0, 1, GetDate(), GetDate()),
(N'37506ac4-b0be-496b-94c8-6e8d0ffb1962', N'W. Europe Standard Time', N'(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna', N'W. Europe Standard Time', N'W. Europe Daylight Time', 60, 60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'42fa9e7b-d481-4180-a36a-6f3e5bffccba', N'Aus Central W. Standard Time', N'(UTC+08:45) Eucla', N'Aus Central W. Standard Time', N'Aus Central W. Daylight Time', 525, 525, 0, 0, 0, 1, GetDate(), GetDate()),
(N'7c2e70c3-3cbc-4c38-9a1f-7183445ccfa8', N'Eastern Standard Time (Mexico)', N'(UTC-05:00) Chetumal', N'Eastern Standard Time (Mexico)', N'Eastern Daylight Time (Mexico)', -300, -300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'7c0914db-4d67-4131-aaee-7213acc57005', N'Samoa Standard Time', N'(UTC+13:00) Samoa', N'Samoa Standard Time', N'Samoa Daylight Time', 780, 840, 1, 0, 0, 1, GetDate(), GetDate()),
(N'8bdc0b33-21e4-4d60-8aa4-73ae9e183dae', N'SA Pacific Standard Time', N'(UTC-05:00) Bogota, Lima, Quito, Rio Branco', N'SA Pacific Standard Time', N'SA Pacific Daylight Time', -300, -300, 0, 0, 0, 1, GetDate(), GetDate()),
(N'7122d22c-94b4-40f5-844f-73bb6bf4373b', N'Central Standard Time', N'(UTC-06:00) Central Time (US & Canada)', N'Central Standard Time', N'Central Daylight Time', -360, -360, 1, 1, 0, 1, GetDate(), GetDate()),
(N'28dce8af-ea94-4751-ba87-745d594915da', N'UTC-09', N'(UTC-09:00) Coordinated Universal Time-09', N'UTC-09', N'UTC-09', -540, -540, 0, 0, 0, 1, GetDate(), GetDate()),
(N'48cc3c76-12ff-4947-a16d-77b320c470de', N'Ekaterinburg Standard Time', N'(UTC+05:00) Ekaterinburg', N'Russia TZ 4 Standard Time', N'Russia TZ 4 Daylight Time', 300, 300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'246b3b78-336b-4b7b-b05c-780b7de3a173', N'Alaskan Standard Time', N'(UTC-09:00) Alaska', N'Alaskan Standard Time', N'Alaskan Daylight Time', -540, -540, 1, 0, 0, 1, GetDate(), GetDate()),
(N'e00c2277-5510-4152-94e8-78156c63f6e1', N'Jordan Standard Time', N'(UTC+02:00) Amman', N'Jordan Standard Time', N'Jordan Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'f3ac37cd-1b78-4497-9a76-79c879eefe23', N'Azerbaijan Standard Time', N'(UTC+04:00) Baku', N'Azerbaijan Standard Time', N'Azerbaijan Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'23113b4e-1256-4f1d-89d2-7b4096d62c6e', N'Belarus Standard Time', N'(UTC+03:00) Minsk', N'Belarus Standard Time', N'Belarus Daylight Time', 180, 180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'66d1bbd8-762a-4e26-89fc-7d910f6c4a87', N'North Korea Standard Time', N'(UTC+09:00) Pyongyang', N'North Korea Standard Time', N'North Korea Daylight Time', 540, 540, 1, 0, 0, 1, GetDate(), GetDate()),
(N'132dca8b-eee1-4f56-8ff4-80fb85c473d1', N'Kaliningrad Standard Time', N'(UTC+02:00) Kaliningrad', N'Russia TZ 1 Standard Time', N'Russia TZ 1 Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'530c5c0c-c89e-422e-b1fd-82f5a5acdfd1', N'Saratov Standard Time', N'(UTC+04:00) Saratov', N'Saratov Standard Time', N'Saratov Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'18d86b57-b202-4357-be81-87a3a196fc9c', N'Aleutian Standard Time', N'(UTC-10:00) Aleutian Islands', N'Aleutian Standard Time', N'Aleutian Daylight Time', -600, -600, 1, 0, 0, 1, GetDate(), GetDate()),
(N'acf840a7-dbf5-4a7f-9274-8acdd34ff9f8', N'UTC+13', N'(UTC+13:00) Coordinated Universal Time+13', N'UTC+13', N'UTC+13', 780, 780, 0, 0, 0, 1, GetDate(), GetDate()),
(N'a865af52-d741-4e17-b6e8-8b21a39e5ae9', N'Turkey Standard Time', N'(UTC+03:00) Istanbul', N'Turkey Standard Time', N'Turkey Daylight Time', 180, 180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ecab1fce-2887-4875-8089-8bb71409a876', N'Pacific SA Standard Time', N'(UTC-04:00) Santiago', N'Pacific SA Standard Time', N'Pacific SA Daylight Time', -240, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'40e7f528-0b6e-43d3-99ed-8c1466daaf9b', N'Tomsk Standard Time', N'(UTC+07:00) Tomsk', N'Tomsk Standard Time', N'Tomsk Daylight Time', 420, 420, 1, 0, 0, 1, GetDate(), GetDate()),
(N'a8adc0df-0773-44f7-bfb0-8d70dc73d099', N'W. Australia Standard Time', N'(UTC+08:00) Perth', N'W. Australia Standard Time', N'W. Australia Daylight Time', 480, 480, 1, 0, 0, 1, GetDate(), GetDate()),
(N'e634163d-49f4-4a1b-bf78-90f18408781d', N'GTB Standard Time', N'(UTC+02:00) Athens, Bucharest', N'GTB Standard Time', N'GTB Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'093190b0-b0e0-4cce-ba24-9176e118dcb5', N'Myanmar Standard Time', N'(UTC+06:30) Yangon (Rangoon)', N'Myanmar Standard Time', N'Myanmar Daylight Time', 390, 390, 0, 0, 0, 1, GetDate(), GetDate()),
(N'3a84381d-1e09-4d00-882b-93a4d607de75', N'Korea Standard Time', N'(UTC+09:00) Seoul', N'Korea Standard Time', N'Korea Daylight Time', 540, 540, 0, 0, 0, 1, GetDate(), GetDate()),
(N'43a22f88-3459-44c4-b3e5-95bd39209c1d', N'Easter Island Standard Time', N'(UTC-06:00) Easter Island', N'Easter Island Standard Time', N'Easter Island Daylight Time', -360, -300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'579cbf75-e472-4f51-88b3-97d7720de848', N'Yakutsk Standard Time', N'(UTC+09:00) Yakutsk', N'Russia TZ 8 Standard Time', N'Russia TZ 8 Daylight Time', 540, 540, 1, 0, 0, 1, GetDate(), GetDate()),
(N'7d653eae-0551-4079-a14f-98a34eaadda0', N'Hawaiian Standard Time', N'(UTC-10:00) Hawaii', N'Hawaiian Standard Time', N'Hawaiian Daylight Time', -600, -600, 0, 0, 0, 1, GetDate(), GetDate()),
(N'41be8b1b-d495-4782-9f96-9971c3108811', N'SA Western Standard Time', N'(UTC-04:00) Georgetown, La Paz, Manaus, San Juan', N'SA Western Standard Time', N'SA Western Daylight Time', -240, -240, 0, 0, 0, 1, GetDate(), GetDate()),
(N'e6860020-df57-49e9-ad37-9dd3b4db3dd6', N'Israel Standard Time', N'(UTC+02:00) Jerusalem', N'Jerusalem Standard Time', N'Jerusalem Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'e4f54d5f-4366-4bd5-b24c-a104aa1155e6', N'Central America Standard Time', N'(UTC-06:00) Central America', N'Central America Standard Time', N'Central America Daylight Time', -360, -360, 0, 0, 0, 1, GetDate(), GetDate()),
(N'561d1a25-62b2-4a23-88ad-a25ea2c040bf', N'New Zealand Standard Time', N'(UTC+12:00) Auckland, Wellington', N'New Zealand Standard Time', N'New Zealand Daylight Time', 720, 780, 1, 0, 0, 1, GetDate(), GetDate()),
(N'512e783e-fc76-4682-b383-a6468980ef96', N'Omsk Standard Time', N'(UTC+06:00) Omsk', N'Omsk Standard Time', N'Omsk Daylight Time', 360, 360, 1, 0, 0, 1, GetDate(), GetDate()),
(N'f5a0f423-9ce2-46fd-8ab9-a7cf9a6450fc', N'North Asia East Standard Time', N'(UTC+08:00) Irkutsk', N'Russia TZ 7 Standard Time', N'Russia TZ 7 Daylight Time', 480, 480, 1, 0, 0, 1, GetDate(), GetDate()),
(N'6a5d1819-27c4-4e78-8e1c-a7f6463c7905', N'Magadan Standard Time', N'(UTC+11:00) Magadan', N'Magadan Standard Time', N'Magadan Daylight Time', 660, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ed5ec95f-eb2d-488e-9c36-a8949f8d8f65', N'Ulaanbaatar Standard Time', N'(UTC+08:00) Ulaanbaatar', N'Ulaanbaatar Standard Time', N'Ulaanbaatar Daylight Time', 480, 480, 1, 0, 0, 1, GetDate(), GetDate()),
(N'dc15f68d-7322-4094-a3d6-a9f30da740a1', N'UTC+12', N'(UTC+12:00) Coordinated Universal Time+12', N'UTC+12', N'UTC+12', 720, 720, 0, 0, 0, 1, GetDate(), GetDate()),
(N'e4435e08-ff71-47f8-ba71-ae4731618b92', N'Bougainville Standard Time', N'(UTC+11:00) Bougainville Island', N'Bougainville Standard Time', N'Bougainville Daylight Time', 660, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ff33b912-f26d-432f-bf85-b0a86ea2c1b3', N'Russia Time Zone 10', N'(UTC+11:00) Chokurdakh', N'Russia TZ 10 Standard Time', N'Russia TZ 10 Daylight Time', 660, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'dee8f8c4-e96e-43b2-a27e-b0e786842811', N'Altai Standard Time', N'(UTC+07:00) Barnaul, Gorno-Altaysk', N'Altai Standard Time', N'Altai Daylight Time', 420, 420, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ea495c92-f02f-4543-ac37-b35c64f57379', N'Mauritius Standard Time', N'(UTC+04:00) Port Louis', N'Mauritius Standard Time', N'Mauritius Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ffa4e060-9d33-449a-a95d-b44e4efe0962', N'Sri Lanka Standard Time', N'(UTC+05:30) Sri Jayawardenepura', N'Sri Lanka Standard Time', N'Sri Lanka Daylight Time', 330, 330, 0, 0, 0, 1, GetDate(), GetDate()),
(N'c8a7c5cd-2c85-469a-b7ce-b4e56df6277d', N'FLE Standard Time', N'(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius', N'FLE Standard Time', N'FLE Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate())
COMMIT;
RAISERROR (N'[dbo].[SystemTimeZone]: Insert Batch: 2.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[SystemTimeZone]([ZoneID], [ID], [DisplayName], [StandardName], [DaylightName], [BaseUTCOffset], [CurrentUTCOffset], [SupportsDaylightSavingTime], [Display], [DefaultTimeZone], [Active], [dbAddDate], [dbLastUpdate])
VALUES (N'd3cf156c-ec0f-4415-90af-b583a2085c95', N'Montevideo Standard Time', N'(UTC-03:00) Montevideo', N'Montevideo Standard Time', N'Montevideo Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'cc021d67-c7ca-4624-83c3-b7a7508edd93', N'Marquesas Standard Time', N'(UTC-09:30) Marquesas Islands', N'Marquesas Standard Time', N'Marquesas Daylight Time', -570, -570, 0, 0, 0, 1, GetDate(), GetDate()),
(N'8eaf8256-7fab-44c0-a7ac-b9dd3efaf58d', N'Singapore Standard Time', N'(UTC+08:00) Kuala Lumpur, Singapore', N'Malay Peninsula Standard Time', N'Malay Peninsula Daylight Time', 480, 480, 0, 0, 0, 1, GetDate(), GetDate()),
(N'21c4ee52-1e6a-401d-861e-c2e75b75d8f2', N'Tokyo Standard Time', N'(UTC+09:00) Osaka, Sapporo, Tokyo', N'Tokyo Standard Time', N'Tokyo Daylight Time', 540, 540, 0, 0, 0, 1, GetDate(), GetDate()),
(N'e0c4c913-13a0-491d-aea4-c6037afe8668', N'SE Asia Standard Time', N'(UTC+07:00) Bangkok, Hanoi, Jakarta', N'SE Asia Standard Time', N'SE Asia Daylight Time', 420, 420, 0, 0, 0, 1, GetDate(), GetDate()),
(N'70332714-dc74-43b9-a339-c7f11eb021eb', N'Argentina Standard Time', N'(UTC-03:00) City of Buenos Aires', N'Argentina Standard Time', N'Argentina Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'3b2aaab9-e610-4ee0-9c9b-c97f01c7a946', N'AUS Central Standard Time', N'(UTC+09:30) Darwin', N'AUS Central Standard Time', N'AUS Central Daylight Time', 570, 570, 0, 0, 0, 1, GetDate(), GetDate()),
(N'f6a4084d-6ce6-4e90-8bfc-c9ca328eef49', N'India Standard Time', N'(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi', N'India Standard Time', N'India Daylight Time', 330, 330, 0, 0, 0, 1, GetDate(), GetDate()),
(N'1eaff6d5-9f62-4d99-b9ed-c9ee41e84b4c', N'E. Africa Standard Time', N'(UTC+03:00) Nairobi', N'E. Africa Standard Time', N'E. Africa Daylight Time', 180, 180, 0, 0, 0, 1, GetDate(), GetDate()),
(N'9aa133cf-1c4e-49c9-b457-cc4e647987fa', N'Russian Standard Time', N'(UTC+03:00) Moscow, St. Petersburg', N'Russia TZ 2 Standard Time', N'Russia TZ 2 Daylight Time', 180, 180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'3dbfbfb9-ddb7-4e04-bdf2-cf926572bb75', N'Tocantins Standard Time', N'(UTC-03:00) Araguaina', N'Tocantins Standard Time', N'Tocantins Daylight Time', -180, -180, 1, 0, 0, 1, GetDate(), GetDate()),
(N'e242d0eb-54f5-4b23-863f-cfe400d5a739', N'UTC', N'(UTC) Coordinated Universal Time', N'Coordinated Universal Time', N'Coordinated Universal Time', 0, 0, 0, 0, 0, 1, GetDate(), GetDate()),
(N'f76eca1a-b5c3-4a0b-8afe-d13368b582ee', N'UTC-08', N'(UTC-08:00) Coordinated Universal Time-08', N'UTC-08', N'UTC-08', -480, -480, 0, 0, 0, 1, GetDate(), GetDate()),
(N'4f66a897-0588-4396-9800-d24d4143e766', N'Nepal Standard Time', N'(UTC+05:45) Kathmandu', N'Nepal Standard Time', N'Nepal Daylight Time', 345, 345, 0, 0, 0, 1, GetDate(), GetDate()),
(N'ead6d7b1-5156-4956-9268-d3313212f8ac', N'Romance Standard Time', N'(UTC+01:00) Brussels, Copenhagen, Madrid, Paris', N'Romance Standard Time', N'Romance Daylight Time', 60, 60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'23b62a4f-101e-4ed2-88bf-d7adf24d74de', N'AUS Eastern Standard Time', N'(UTC+10:00) Canberra, Melbourne, Sydney', N'AUS Eastern Standard Time', N'AUS Eastern Daylight Time', 600, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'60edfa89-ef67-4adc-b885-d7b88c3f5cf3', N'Cape Verde Standard Time', N'(UTC-01:00) Cabo Verde Is.', N'Cabo Verde Standard Time', N'Cabo Verde Daylight Time', -60, -60, 0, 0, 0, 1, GetDate(), GetDate()),
(N'c741faa1-99df-48e8-9c4d-dc5a18366ecf', N'Central Brazilian Standard Time', N'(UTC-04:00) Cuiaba', N'Central Brazilian Standard Time', N'Central Brazilian Daylight Time', -240, -240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'a6f021fd-54ed-4c2b-b865-dea2365f7226', N'Central European Standard Time', N'(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb', N'Central European Standard Time', N'Central European Daylight Time', 60, 60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'766f77be-9154-44bb-bba3-e2aeae78fdc1', N'Tonga Standard Time', N'(UTC+13:00) Nuku''alofa', N'Tonga Standard Time', N'Tonga Daylight Time', 780, 780, 1, 0, 0, 1, GetDate(), GetDate()),
(N'55753bef-2779-4699-9cb7-e5045d31d124', N'E. Europe Standard Time', N'(UTC+02:00) Chisinau', N'E. Europe Standard Time', N'E. Europe Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ab86ba07-1e78-48d0-b053-e5a5cf8435eb', N'Central Asia Standard Time', N'(UTC+06:00) Astana', N'Central Asia Standard Time', N'Central Asia Daylight Time', 360, 360, 0, 0, 0, 1, GetDate(), GetDate()),
(N'5c10a1ef-016b-4b8b-b73a-e99f84d4f074', N'Morocco Standard Time', N'(UTC+01:00) Casablanca', N'Morocco Standard Time', N'Morocco Daylight Time', 60, 60, 1, 0, 0, 1, GetDate(), GetDate()),
(N'e1a74ebb-1201-40d0-b249-ecbe5f2e1d3c', N'SA Eastern Standard Time', N'(UTC-03:00) Cayenne, Fortaleza', N'SA Eastern Standard Time', N'SA Eastern Daylight Time', -180, -180, 0, 0, 0, 1, GetDate(), GetDate()),
(N'b5ee13d8-c30f-46cd-9b1b-edfac31e396a', N'South Africa Standard Time', N'(UTC+02:00) Harare, Pretoria', N'South Africa Standard Time', N'South Africa Daylight Time', 120, 120, 0, 0, 0, 1, GetDate(), GetDate()),
(N'522e2291-3f9f-4408-ab19-ee204fd59e1b', N'Bangladesh Standard Time', N'(UTC+06:00) Dhaka', N'Bangladesh Standard Time', N'Bangladesh Daylight Time', 360, 360, 1, 0, 0, 1, GetDate(), GetDate()),
(N'6192131c-d240-4b08-82a2-ef753d192a75', N'Cuba Standard Time', N'(UTC-05:00) Havana', N'Cuba Standard Time', N'Cuba Daylight Time', -300, -300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'7d86fe1f-0e5d-4c6d-a90b-ef87f1e1692a', N'Volgograd Standard Time', N'(UTC+04:00) Volgograd', N'Volgograd Standard Time', N'Volgograd Daylight Time', 240, 240, 1, 0, 0, 1, GetDate(), GetDate()),
(N'94d1c50b-153b-4550-81a9-f29d058c037d', N'Sudan Standard Time', N'(UTC+02:00) Khartoum', N'Sudan Standard Time', N'Sudan Daylight Time', 120, 120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'd82303a0-8c5a-4d8b-86e6-f376800493d5', N'Turks And Caicos Standard Time', N'(UTC-05:00) Turks and Caicos', N'Turks and Caicos Standard Time', N'Turks and Caicos Daylight Time', -300, -300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'4aa63144-736d-40e7-a1ec-f49c8dcc2d5e', N'Central Standard Time (Mexico)', N'(UTC-06:00) Guadalajara, Mexico City, Monterrey', N'Central Standard Time (Mexico)', N'Central Daylight Time (Mexico)', -360, -360, 1, 0, 0, 1, GetDate(), GetDate()),
(N'10ced930-054c-4591-aa9d-f5709062e7d6', N'UTC-02', N'(UTC-02:00) Coordinated Universal Time-02', N'UTC-02', N'UTC-02', -120, -120, 0, 0, 0, 1, GetDate(), GetDate()),
(N'3e3ae674-5d8f-47ff-a301-f7500dc53efe', N'West Pacific Standard Time', N'(UTC+10:00) Guam, Port Moresby', N'West Pacific Standard Time', N'West Pacific Daylight Time', 600, 600, 0, 0, 0, 1, GetDate(), GetDate()),
(N'58e0a68c-0a2f-4ad0-a869-fb3a05e90d57', N'Vladivostok Standard Time', N'(UTC+10:00) Vladivostok', N'Russia TZ 9 Standard Time', N'Russia TZ 9 Daylight Time', 600, 600, 1, 0, 0, 1, GetDate(), GetDate()),
(N'ae79a9c4-10d7-4094-9799-fc5f6e460ad3', N'Norfolk Standard Time', N'(UTC+11:00) Norfolk Island', N'Norfolk Standard Time', N'Norfolk Daylight Time', 660, 660, 1, 0, 0, 1, GetDate(), GetDate()),
(N'20e67bf7-81c9-46f1-b4b5-fd744240233e', N'Mid-Atlantic Standard Time', N'(UTC-02:00) Mid-Atlantic - Old', N'Mid-Atlantic Standard Time', N'Mid-Atlantic Daylight Time', -120, -120, 1, 0, 0, 1, GetDate(), GetDate()),
(N'954b8869-c8ca-4328-8976-fe3e2cceda2f', N'US Eastern Standard Time', N'(UTC-05:00) Indiana (East)', N'US Eastern Standard Time', N'US Eastern Daylight Time', -300, -300, 1, 0, 0, 1, GetDate(), GetDate()),
(N'8e7831a6-a9eb-4491-a374-ff7948e6630e', N'Haiti Standard Time', N'(UTC-05:00) Haiti', N'Haiti Standard Time', N'Haiti Daylight Time', -300, -300, 1, 0, 0, 1, GetDate(), GetDate())
COMMIT;
RAISERROR (N'[dbo].[SystemTimeZone]: Insert Batch: 3.....Done!', 10, 1) WITH NOWAIT;
GO

