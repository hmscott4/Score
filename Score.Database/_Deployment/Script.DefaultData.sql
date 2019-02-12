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

SET IDENTITY_INSERT [dbo].[Config] ON 
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (1, N'ProcessLogRetainDays', N'90', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (2, N'SyncHistoryRetainDays', N'90', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (3, N'EventLogRetainDays', N'7', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (4, N'DatabaseSizeDailyRetainDays', N'1825', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (5, N'DatabaseSizeRawRetainDays', N'30', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (6, N'LogicalVolumeSizeDailyRetainDays', N'1825', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (7, N'LogicalVolumeSizeRawRetainDays', N'30', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (8, N'WebApplicationResponseDailyRetainDays', N'365', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (9, N'WebApplicationResponseRawRetainDays', N'30', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (10, N'ConfigurationHistoryRetainDays', N'21', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (11, N'StoreConfigurationHistory', N'1', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (1002, N'DefaultTimeZoneDisplayName', N'(UTC-05:00) Eastern Time (US & Canada)', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (1003, N'OrganizationDisplayName', N'ABCD Corporation', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
INSERT [dbo].[Config] ([ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (1004, N'DefaultTimeZoneCurrentOffset', N'-300', GETDATE(), SUSER_SNAME(), GETDATE(), SUSER_SNAME())
GO
SET IDENTITY_INSERT [dbo].[Config] OFF
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
INSERT [dbo].[ReportHeader] ([Id], [ReportName], [ReportDisplayName], [ReportBackground], [TitleBackground], [TitleFont], [TitleFontColor], [TitleFontSize], [SubTitleBackground], [SubTitleFont], [SubTitleFontColor], [SubTitleFontSize], [TableHeaderBackground], [TableHeaderFont], [TableHeaderFontColor], [TableHeaderFontSize], [TableFooterBackground], [TableFooterFont], [TableFooterFontColor], [TableFooterFontSize], [RowEvenBackground], [RowEvenFont], [RowEvenFontColor], [RowEvenFontSize], [RowOddBackground], [RowOddFont], [RowOddFontColor], [RowOddFontSize], [FooterBackground], [FooterFont], [FooterFontColor], [FooterFontSize], [dbAddDate], [dbModDate]) VALUES (N'f5772c15-ad25-446c-96f4-2a21e4073321', N'Dash_OrganizationSummaryByArea', N'Organizational Summary By Area', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportHeader] ([Id], [ReportName], [ReportDisplayName], [ReportBackground], [TitleBackground], [TitleFont], [TitleFontColor], [TitleFontSize], [SubTitleBackground], [SubTitleFont], [SubTitleFontColor], [SubTitleFontSize], [TableHeaderBackground], [TableHeaderFont], [TableHeaderFontColor], [TableHeaderFontSize], [TableFooterBackground], [TableFooterFont], [TableFooterFontColor], [TableFooterFontSize], [RowEvenBackground], [RowEvenFont], [RowEvenFontColor], [RowEvenFontSize], [RowOddBackground], [RowOddFont], [RowOddFontColor], [RowOddFontSize], [FooterBackground], [FooterFont], [FooterFontColor], [FooterFontSize], [dbAddDate], [dbModDate]) VALUES (N'133ae6f5-30df-4818-8ef7-bb46f25f58f4', N'<default>', N'<default>', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportHeader] ([Id], [ReportName], [ReportDisplayName], [ReportBackground], [TitleBackground], [TitleFont], [TitleFontColor], [TitleFontSize], [SubTitleBackground], [SubTitleFont], [SubTitleFontColor], [SubTitleFontSize], [TableHeaderBackground], [TableHeaderFont], [TableHeaderFontColor], [TableHeaderFontSize], [TableFooterBackground], [TableFooterFont], [TableFooterFontColor], [TableFooterFontSize], [RowEvenBackground], [RowEvenFont], [RowEvenFontColor], [RowEvenFontSize], [RowOddBackground], [RowOddFont], [RowOddFontColor], [RowOddFontSize], [FooterBackground], [FooterFont], [FooterFontColor], [FooterFontSize], [dbAddDate], [dbModDate]) VALUES (N'0b1f5a22-217e-4bd7-a8e8-c8465ba00440', N'Dash_OrganizationSummary', N'Organizational Summary', N'#FFFFFF', N'#483D8B', N'Arial', N'#F8F8FF', N'36pt', N'#FFFFFF', N'Arial', N'#000000', N'18pt', N'#6495ED', N'Arial', N'#F8F8FF', N'10pt', N'#F0E68C', N'Arial', N'#000000', N'10pt', N'#B0C4DE', N'Arial', N'#000000', N'9pt', N'#FFFFFF', N'Arial', N'#FFFFFF', N'9pt', N'#FFFFFF', N'Arial', N'#000000', N'10pt', GETDATE(), GETDATE())
GO

/* Initialize dbo.ReportContent
* Hugh Scott
* 2019/02/01
*/
SET IDENTITY_INSERT [dbo].[ReportContent] ON 
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (1, N'f5772c15-ad25-446c-96f4-2a21e4073321', 1, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Domain Controller', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (2, N'f5772c15-ad25-446c-96f4-2a21e4073321', 5, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Active Directory Site', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (3, N'f5772c15-ad25-446c-96f4-2a21e4073321', 2, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Server', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (4, N'f5772c15-ad25-446c-96f4-2a21e4073321', 3, N'#FFFFFF', N'Arial', N'10', N'#000000', N'SQL DB Engine', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (5, N'f5772c15-ad25-446c-96f4-2a21e4073321', 4, N'#FFFFFF', N'Arial', N'10', N'#000000', N'Windows Cluster', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (6, N'f5772c15-ad25-446c-96f4-2a21e4073321', 6, N'#FFFFFF', N'Arial', N'10', N'#000000', N'UNIX/Linux Computer', GETDATE(), GETDATE())
GO
INSERT [dbo].[ReportContent] ([Id], [ReportId], [SortSequence], [ItemBackground], [ItemFont], [ItemFontSize], [ItemFontColor], [ItemParameters], [dbAddDate], [dbModDate]) VALUES (7, N'f5772c15-ad25-446c-96f4-2a21e4073321', 7, N'#FFFFFF', N'Arial', N'10', N'#000000', N'IIS Web Site', GETDATE(), GETDATE())
GO
SET IDENTITY_INSERT [dbo].[ReportContent] OFF
GO