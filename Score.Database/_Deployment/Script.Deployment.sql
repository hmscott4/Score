/*
2019/02/12
SCORE Create
Hugh Scott
--------------------------------------------------------------------------------------
 This script contains schema creation scripts for SCORE database.
 1. Run this script first
 2. This script will create the SCORE database and all objects
--------------------------------------------------------------------------------------
*/
USE [master]
GO
/****** Object:  Database [SCORE]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE DATABASE [SCORE]
GO
USE [SCORE]
GO
/****** Object:  DatabaseRole [scomUpdate]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [scomUpdate]
GO
/****** Object:  DatabaseRole [scomRead]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [scomRead]
GO
/****** Object:  DatabaseRole [pmUpdate]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [pmUpdate]
GO
/****** Object:  DatabaseRole [pmRead]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [pmRead]
GO
/****** Object:  DatabaseRole [cmUpdate]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [cmUpdate]
GO
/****** Object:  DatabaseRole [cmRead]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [cmRead]
GO
/****** Object:  DatabaseRole [cmAdmin]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [cmAdmin]
GO
/****** Object:  DatabaseRole [adUpdate]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [adUpdate]
GO
/****** Object:  DatabaseRole [adRead]    Script Date: 2/12/2019 10:38:44 AM ******/
CREATE ROLE [adRead]
GO
/****** Object:  Schema [ad]    Script Date: 2/12/2019 10:38:45 AM ******/
CREATE SCHEMA [ad]
GO
/****** Object:  Schema [cm]    Script Date: 2/12/2019 10:38:45 AM ******/
CREATE SCHEMA [cm]
GO
/****** Object:  Schema [pm]    Script Date: 2/12/2019 10:38:45 AM ******/
CREATE SCHEMA [pm]
GO
/****** Object:  Schema [scom]    Script Date: 2/12/2019 10:38:45 AM ******/
CREATE SCHEMA [scom]
GO
/****** Object:  Table [cm].[AnalysisInstance]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[AnalysisInstance](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ProductName] [nvarchar](128) NOT NULL,
	[ProductEdition] [nvarchar](128) NOT NULL,
	[ProductVersion] [nvarchar](128) NOT NULL,
	[ProductServicePack] [nvarchar](128) NOT NULL,
	[ConnectionString] [nvarchar](255) NOT NULL,
	[ServiceState] [nvarchar](128) NOT NULL,
	[IsClustered] [bit] NOT NULL,
	[ActiveNode] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisInstance] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[Computer]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Computer](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[dnsHostName] [nvarchar](255) NOT NULL,
	[netBIOSName] [nvarchar](255) NOT NULL,
	[IPv4Address] [nvarchar](128) NULL,
	[DomainRole] [nvarchar](128) NULL,
	[CurrentTimeZone] [int] NULL,
	[DaylightInEffect] [bit] NULL,
	[Status] [nvarchar](50) NULL,
	[Manufacturer] [nvarchar](128) NULL,
	[Model] [nvarchar](128) NULL,
	[PCSystemType] [nvarchar](128) NULL,
	[SystemType] [nvarchar](128) NULL,
	[AssetTag] [nvarchar](128) NULL,
	[SerialNumber] [nvarchar](128) NULL,
	[TotalPhysicalMemory] [bigint] NULL,
	[NumberOfLogicalProcessors] [int] NULL,
	[NumberOfProcessors] [int] NULL,
	[IsVirtual] [bit] NOT NULL,
	[PendingReboot] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[IsClusterResource] [bit] NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Computer] PRIMARY KEY NONCLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_Computer_Unique]    Script Date: 2/12/2019 10:38:45 AM ******/
CREATE UNIQUE CLUSTERED INDEX [IX_cm_Computer_Unique] ON [cm].[Computer]
(
	[dnsHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [cm].[AnalysisInstanceView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[AnalysisInstanceView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[AnalysisInstanceView] 
AS
SELECT [ai].[objectGUID]
      ,[ai].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[ai].[InstanceName]
      ,[ai].[ProductName]
      ,[ai].[ProductEdition]
      ,[ai].[ProductVersion]
      ,[ai].[ProductServicePack]
      ,[ai].[ConnectionString]
      ,[ai].[ServiceState]
      ,[ai].[IsClustered]
      ,[ai].[ActiveNode]
      ,[ai].[Active]
      ,[ai].[dbAddDate]
      ,[ai].[dbLastUpdate]
  FROM [cm].[AnalysisInstance] [ai] INNER JOIN [cm].[Computer] c ON
		[ai].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[DatabaseInstance]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseInstance](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ProductName] [nvarchar](128) NOT NULL,
	[ProductEdition] [nvarchar](128) NOT NULL,
	[ProductVersion] [nvarchar](128) NOT NULL,
	[ProductServicePack] [nvarchar](128) NOT NULL,
	[ConnectionString] [nvarchar](255) NOT NULL,
	[ServiceState] [nvarchar](128) NOT NULL,
	[IsClustered] [bit] NOT NULL,
	[ActiveNode] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseInstance] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DatabaseInstanceView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabaseInstanceView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[DatabaseInstanceView]
AS
SELECT [di].[objectGUID]
      ,[di].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[di].[InstanceName]
      ,[di].[ProductName]
      ,[di].[ProductEdition]
      ,[di].[ProductVersion]
      ,[di].[ProductServicePack]
      ,[di].[ConnectionString]
      ,[di].[ServiceState]
      ,[di].[IsClustered]
      ,[di].[ActiveNode]
      ,[di].[Active]
      ,[di].[dbAddDate]
      ,[di].[dbLastUpdate]
  FROM [cm].[DatabaseInstance] di INNER JOIN [cm].[Computer] c ON
	[di].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[DatabaseInstanceProperty]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseInstanceProperty](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseInstanceProperty] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DatabaseInstancePropertyView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabaseInstancePropertyView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[DatabaseInstancePropertyView]
AS
SELECT [dip].[objectGUID]
      ,[dip].[DatabaseInstanceGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[di].[ConnectionString]
      ,[dip].[PropertyName]
      ,[dip].[PropertyValue]
      ,[dip].[Active]
      ,[dip].[dbAddDate]
      ,[dip].[dbLastUpdate]
  FROM [cm].[DatabaseInstanceProperty] dip INNER JOIN [cm].[DatabaseInstance] di ON
	[dip].[DatabaseInstanceGUID] = [di].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
	[di].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [scom].[SyncStatus]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[SyncStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementGroup] [nvarchar](128) NOT NULL,
	[ObjectClass] [nvarchar](128) NOT NULL,
	[SyncType] [nvarchar](64) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](128) NULL,
 CONSTRAINT [PK_scom_SyncStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[SyncHistory]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[SyncHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[ObjectClass] [nvarchar](255) NOT NULL,
	[SyncType] [nvarchar](255) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](255) NULL,
 CONSTRAINT [PK_scom_SyncHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [scom].[SyncStatusView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.SyncStatusView
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE VIEW [scom].[SyncStatusView]

AS

SELECT 
	[ss].[ManagementGroup],
	[ss].[ObjectClass],
	[ss].[Status] as [LastStatus],
	[ss].[SyncType] as [LastSyncType],
	[ss].[StartDate] as [LastStartDate],
	MAX(CASE WHEN [sh].[SyncType] = N'Full' AND [sh].[Status] like N'Success%' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastFullSync],
	MAX(CASE WHEN [sh].[SyncType] = N'Incremental' AND [sh].[Status] like N'Success%' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastIncrementalSync]
FROM
	[scom].[SyncStatus] ss inner join [scom].[SyncHistory] sh ON
		[ss].[ManagementGroup] = [sh].[ManagementGroup] AND
		[ss].[ObjectClass] = [sh].[ObjectClass]
GROUP BY
	[ss].[ManagementGroup],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType],
	[ss].[StartDate]
GO
/****** Object:  Table [cm].[DatabaseFile]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseFile](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseGUID] [uniqueidentifier] NOT NULL,
	[FileID] [int] NOT NULL,
	[FileGroup] [nvarchar](255) NOT NULL,
	[LogicalName] [nvarchar](255) NOT NULL,
	[PhysicalName] [nvarchar](2048) NOT NULL,
	[FileSize] [bigint] NOT NULL,
	[MaxSize] [bigint] NOT NULL,
	[SpaceUsed] [bigint] NOT NULL,
	[Growth] [bigint] NOT NULL,
	[GrowthType] [nvarchar](128) NOT NULL,
	[IsReadOnly] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseFile] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[Database]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Database](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[DatabaseID] [int] NOT NULL,
	[RecoveryModel] [nvarchar](128) NOT NULL,
	[Status] [nvarchar](128) NOT NULL,
	[ReadOnly] [bit] NOT NULL,
	[UserAccess] [nvarchar](128) NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[Owner] [nvarchar](128) NOT NULL,
	[LastFullBackup] [datetime2](3) NULL,
	[LastDiffBackup] [datetime2](3) NULL,
	[LastLogBackup] [datetime2](3) NULL,
	[CompatibilityLevel] [nvarchar](128) NOT NULL,
	[DataFileSize] [bigint] NOT NULL,
	[DataFileSpaceUsed] [bigint] NOT NULL,
	[LogFileSize] [bigint] NOT NULL,
	[LogFileSpaceUsed] [bigint] NOT NULL,
	[VirtualLogFileCount] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Database] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DatabaseFileView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabaseFileView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[DatabaseFileView]
AS
SELECT [di].[ComputerGUID]
      ,[d].[DatabaseInstanceGUID]
      ,[df].[DatabaseGUID]
	  ,[df].[objectGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[di].[ConnectionString]
	  ,[d].[DatabaseName]
      ,[df].[FileID]
      ,[df].[FileGroup]
      ,[df].[LogicalName]
      ,[df].[PhysicalName]
      ,[df].[FileSize]
      ,[df].[MaxSize]
      ,[df].[SpaceUsed]
      ,[df].[Growth]
      ,[df].[GrowthType]
      ,[df].[IsReadOnly]
      ,[df].[Active]
      ,[df].[dbAddDate]
      ,[df].[dbLastUpdate]
  FROM [cm].[DatabaseFile] df INNER JOIN [cm].[Database] d ON
		[df].[DatabaseGUID] = [d].[objectGUID]
	INNER JOIN [cm].[DatabaseInstance] di ON
		[d].[DatabaseInstanceGUID] = [di].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[di].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[WindowsUpdateInstallation]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[WindowsUpdateInstallation](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[WindowsUpdateGUID] [uniqueidentifier] NOT NULL,
	[InstallDate] [datetime2](3) NULL,
	[InstallBy] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WindowsUpdateInstallation] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[WindowsUpdate]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[WindowsUpdate](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[HotfixID] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](128) NOT NULL,
	[Caption] [nvarchar](128) NULL,
	[FixComments] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WindowsUpdate] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[WindowsUpdateInstallationView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[WindowsUpdateInstallationView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[WindowsUpdateInstallationView]

AS

SELECT
	[wu].objectGUID
	,[c].[objectGUID] as [ComputerGUID]
	,[c].[dnsHostName]
	,[wu].[HotfixID]
	,[wu].[Description]
	,[wu].[Caption]
	,[wu].[FixComments]
	,[wui].[InstallDate]
	,[wui].[InstallBy]
	,[wui].[Active]
	,[wui].[dbAddDate]
	,[wui].[dbLastUpdate]
FROM [cm].[WindowsUpdateInstallation] wui INNER JOIN [cm].[WindowsUpdate] wu ON
		[wui].[WindowsUpdateGUID] = [wu].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[c].[objectGUID] = [wui].[ComputerGUID]
GO
/****** Object:  Table [cm].[ComputerShare]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ComputerShare](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](128) NOT NULL,
	[Path] [nvarchar](2048) NOT NULL,
	[Status] [nvarchar](128) NULL,
	[Type] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ComputerShare] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ComputerShareView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[ComputerShareView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[ComputerShareView]
AS
SELECT [cs].[objectGUID]
      ,[cs].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[cs].[Name]
      ,[cs].[Description]
      ,[cs].[Path]
      ,[cs].[Status]
      ,[cs].[Type]
      ,[cs].[Active]
      ,[cs].[dbAddDate]
      ,[cs].[dbLastUpdate]
  FROM [cm].[ComputerShare] cs INNER JOIN [cm].[Computer] c ON
		[cs].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[ComputerSharePermission]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ComputerSharePermission](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerShareGUID] [uniqueidentifier] NOT NULL,
	[SecurityPrincipal] [nvarchar](128) NOT NULL,
	[FileSystemRights] [nvarchar](128) NOT NULL,
	[AccessControlType] [nvarchar](128) NOT NULL,
	[IsInherited] [bit] NOT NULL,
	[InheritanceFlags] [nvarchar](128) NOT NULL,
	[PropagationFlags] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ComputerSharePermission] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ComputerSharePermissionView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[ComputerSharePermissionView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ComputerSharePermissionView]

AS

SELECT [csp].[objectGUID]
      ,[c].[objectGUID] as [ComputerGUID]
      ,[csp].[ComputerShareGUID]
	  ,[c].[dnsHostName]
      ,[cs].[Name] as [ShareName]
      ,[csp].[SecurityPrincipal]
      ,[csp].[FileSystemRights]
      ,[csp].[AccessControlType]
      ,[csp].[IsInherited]
      ,[csp].[InheritanceFlags]
      ,[csp].[PropagationFlags]
      ,[csp].[Active]
      ,[csp].[dbAddDate]
      ,[csp].[dbLastUpdate]
  FROM [cm].[ComputerSharePermission] csp INNER JOIN [cm].[ComputerShare] cs ON
			[csp].[ComputerShareGUID] = [cs].[objectGUID] INNER JOIN [cm].[Computer] c ON
			[cs].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[ComputerGroupMember]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ComputerGroupMember](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[GroupName] [nvarchar](128) NOT NULL,
	[MemberName] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ComputerGroupMember] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ComputerGroupMemberView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [cm].[ApplicationInstallation]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ApplicationInstallation](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[ApplicationGUID] [uniqueidentifier] NOT NULL,
	[InstallDate] [datetime2](7) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ApplicationInstallation] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[Application]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Application](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Version] [nvarchar](128) NULL,
	[Vendor] [nvarchar](128) NULL,
	[Licensed] [bit] NULL,
	[LicenseMetric] [nvarchar](64) NULL,
	[AvailableLicenses] [int] NULL,
	[AllocatedLicenses] [int] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Application] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ApplicationInstallationView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[ApplicationInstallationView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ApplicationInstallationView]
AS
SELECT [ai].[objectGUID]
      ,[ai].[ComputerGUID]
      ,[ai].[ApplicationGUID]
	  ,[c].[dnsHostName]
	  ,[a].[Name]
	  ,[a].[Version]
	  ,[a].[Vendor]
	  ,[ai].[InstallDate]
      ,[ai].[Active]
      ,[ai].[dbAddDate]
      ,[ai].[dbLastUpdate]
  FROM [cm].[ApplicationInstallation] ai INNER JOIN [cm].[Application] a ON
		[ai].[ApplicationGUID] = [a].objectGUID
	INNER JOIN [cm].[Computer] c ON
		[ai].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[OperatingSystem]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[OperatingSystem](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[computerGUID] [uniqueidentifier] NOT NULL,
	[IPV4Address] [nvarchar](128) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[OSArchitecture] [nvarchar](128) NULL,
	[OSType] [nvarchar](128) NULL,
	[OperatingSystem] [nvarchar](128) NULL,
	[Description] [nvarchar](1024) NULL,
	[Version] [nvarchar](128) NULL,
	[ServicePack] [nvarchar](128) NULL,
	[ServicePackMajorVersion] [int] NULL,
	[ServicePackMinorVersion] [int] NULL,
	[BootDevice] [nvarchar](255) NULL,
	[SystemDevice] [nvarchar](255) NULL,
	[WindowsDirectory] [nvarchar](255) NULL,
	[SystemDirectory] [nvarchar](255) NULL,
	[TotalVisibleMemorySize] [bigint] NULL,
	[InstallDate] [datetime2](3) NULL,
	[LastBootUpTime] [datetime2](3) NULL,
	[Status] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_OperatingSystem] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[OperatingSystemView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[OperatingSystemView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[OperatingSystemView]
AS
SELECT [os].[objectGUID]
      ,[os].[computerGUID]
	  ,[c].[Domain]
	  ,[c].[DomainRole]
	  ,[c].[dnsHostName]
      ,[os].[IPV4Address]
      ,[os].[Manufacturer]
      ,[os].[OSArchitecture]
      ,[os].[OSType]
      ,[os].[OperatingSystem]
      ,[os].[Description]
      ,[os].[Version]
      ,[os].[ServicePack]
      ,[os].[ServicePackMajorVersion]
      ,[os].[ServicePackMinorVersion]
      ,[os].[BootDevice]
      ,[os].[SystemDevice]
      ,[os].[WindowsDirectory]
      ,[os].[SystemDirectory]
      ,[os].[TotalVisibleMemorySize]
      ,[os].[InstallDate]
      ,[os].[LastBootUpTime]
      ,[os].[Status]
	  ,[c].[IsClusterResource]
      ,[os].[Active]
      ,[os].[dbAddDate]
      ,[os].[dbLastUpdate]
  FROM [cm].[OperatingSystem] os INNER JOIN [cm].[Computer] [c] ON
		[os].[computerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[LogicalVolume]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[LogicalVolume](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DriveLetter] [nvarchar](128) NULL,
	[Label] [nvarchar](128) NULL,
	[FileSystem] [nvarchar](128) NOT NULL,
	[BlockSize] [int] NOT NULL,
	[SerialNumber] [nvarchar](128) NOT NULL,
	[Capacity] [bigint] NOT NULL,
	[SpaceUsed] [bigint] NULL,
	[SystemVolume] [bit] NOT NULL,
	[IsClustered] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_LogicalVolume] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[LogicalVolumeView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[LogicalVolumeView]    Script Date: 1/16/2019 8:32:48 AM ******/




CREATE VIEW [cm].[LogicalVolumeView]
AS
SELECT [lv].[objectGUID]
      ,[lv].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[lv].[Name]
      ,[lv].[DriveLetter]
      ,[lv].[Label]
      ,[lv].[FileSystem]
      ,[lv].[BlockSize]
	  ,[lv].[SerialNumber]
      ,[lv].[Capacity]
	  ,[lv].[SpaceUsed]
	  ,[lv].[SystemVolume]
	  ,[lv].[IsClustered]
      ,[lv].[Active]
      ,[lv].[dbAddDate]
      ,[lv].[dbLastUpdate]
  FROM [cm].[LogicalVolume] lv INNER JOIN [cm].[Computer] c ON
	[lv].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[DiskDrive]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DiskDrive](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DeviceID] [nvarchar](128) NOT NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL,
	[SerialNumber] [nvarchar](128) NULL,
	[FirmwareRevision] [nvarchar](128) NULL,
	[Partitions] [int] NULL,
	[InterfaceType] [nvarchar](128) NOT NULL,
	[SCSIBus] [int] NULL,
	[SCSIPort] [int] NULL,
	[SCSILogicalUnit] [int] NULL,
	[SCSITargetID] [int] NULL,
	[Size] [bigint] NOT NULL,
	[Status] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DiskDrive] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DiskDriveView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DiskDriveView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DiskDriveView] 
AS
SELECT [dd].[objectGUID]
      ,[dd].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[dd].[Name]
      ,[dd].[DeviceID]
      ,[dd].[Manufacturer]
      ,[dd].[Model]
      ,[dd].[SerialNumber]
      ,[dd].[FirmwareRevision]
      ,[dd].[Partitions]
      ,[dd].[InterfaceType]
      ,[dd].[SCSIBus]
      ,[dd].[SCSIPort]
      ,[dd].[SCSILogicalUnit]
      ,[dd].[SCSITargetID]
      ,[dd].[Size]
      ,[dd].[Status]
      ,[dd].[Active]
      ,[dd].[dbAddDate]
      ,[dd].[dbLastUpdate]
  FROM [cm].[DiskDrive] dd INNER JOIN [cm].[Computer] c ON
	[dd].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[DatabaseUser]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseUser](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](128) NOT NULL,
	[Login] [nvarchar](128) NOT NULL,
	[UserType] [nvarchar](128) NOT NULL,
	[LoginType] [nvarchar](128) NOT NULL,
	[HasDBAccess] [bit] NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[DateLastModified] [datetime2](3) NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseUser] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DatabaseUserView]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabaseUserView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DatabaseUserView] 

AS 

SELECT [du].[objectGUID]
      ,[du].[DatabaseInstanceGUID]
	  ,[c].[objectGUID] AS [ComputerGUID]
	  ,[c].[dnsHostName] 
	  ,[di].[InstanceName]
      ,[du].[DatabaseName]
      ,[du].[UserName]
      ,[du].[Login]
      ,[du].[UserType]
      ,[du].[LoginType]
      ,[du].[HasDBAccess]
      ,[du].[CreateDate]
      ,[du].[DateLastModified]
      ,[du].[State]
      ,[du].[Active]
      ,[du].[dbAddDate]
      ,[du].[dbLastUpdate]
  FROM 
	[cm].[DatabaseUser] du INNER JOIN [cm].[DatabaseInstance] [di] ON
		[du].[DatabaseInstanceGUID] = [di].[objectGUID] 
	INNER JOIN [cm].[Computer] c ON
		[di].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[DatabaseProperty]    Script Date: 2/12/2019 10:38:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseProperty](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseGUID] [uniqueidentifier] NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseProperty] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DatabasePropertyView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabasePropertyView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DatabasePropertyView] 
AS
SELECT [c].[objectGUID] as [ComputerGUID]
      ,[d].[DatabaseInstanceGUID]
      ,[dp].[DatabaseGUID]
	  ,[dp].[objectGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[d].[DatabaseName]
      ,[dp].[PropertyName]
      ,[dp].[PropertyValue]
      ,[dp].[Active]
      ,[dp].[dbAddDate]
      ,[dp].[dbLastUpdate]
  FROM [cm].[DatabaseProperty] dp INNER JOIN [cm].[Database] d ON
		[dp].[DatabaseGUID] = [d].[objectGUID]
	INNER JOIN [cm].[DatabaseInstance] di ON
		[d].[DatabaseInstanceGUID] = [di].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[di].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[DatabaseInstanceLogin]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseInstanceLogin](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Sid] [nvarchar](255) NOT NULL,
	[LoginType] [nvarchar](128) NOT NULL,
	[DefaultDatabase] [nvarchar](255) NOT NULL,
	[HasAccess] [bit] NOT NULL,
	[IsDisabled] [bit] NULL,
	[IsLocked] [bit] NULL,
	[IsPasswordExpired] [bit] NULL,
	[PasswordExpirationEnabled] [bit] NULL,
	[PasswordPolicyEnforced] [bit] NULL,
	[IsSysAdmin] [bit] NOT NULL,
	[IsSecurityAdmin] [bit] NOT NULL,
	[IsSetupAdmin] [bit] NOT NULL,
	[IsProcessAdmin] [bit] NOT NULL,
	[IsDiskAdmin] [bit] NOT NULL,
	[IsDBCreator] [bit] NOT NULL,
	[IsBulkAdmin] [bit] NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[DateLastModified] [datetime2](3) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseInstanceLogin] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[DatabaseInstanceLoginView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabaseInstanceLoginView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DatabaseInstanceLoginView]

AS

SELECT [dbl].[objectGUID]
      ,[dbl].[DatabaseInstanceGUID]
      ,[c].[objectGUID] as [ComputerGUID]
	  ,[c].[dnsHostName]
	  ,[dbi].[InstanceName] as [DatabaseInstance]
      ,[dbl].[Name]
      ,[dbl].[Sid]
      ,[dbl].[LoginType]
      ,[dbl].[DefaultDatabase]
      ,[dbl].[HasAccess]
      ,[dbl].[IsDisabled]
      ,[dbl].[IsLocked]
      ,[dbl].[IsPasswordExpired]
      ,[dbl].[PasswordExpirationEnabled]
      ,[dbl].[PasswordPolicyEnforced]
      ,[dbl].[IsSysAdmin]
      ,[dbl].[IsSecurityAdmin]
      ,[dbl].[IsSetupAdmin]
      ,[dbl].[IsProcessAdmin]
      ,[dbl].[IsDiskAdmin]
      ,[dbl].[IsDBCreator]
      ,[dbl].[IsBulkAdmin]
      ,[dbl].[CreateDate]
      ,[dbl].[DateLastModified]
      ,[dbl].[State]
      ,[dbl].[Active]
      ,[dbl].[dbAddDate]
      ,[dbl].[dbLastUpdate]
  FROM 
	[cm].[DatabaseInstanceLogin] dbl INNER JOIN [cm].[DatabaseInstance] dbi ON
		[dbl].[DatabaseInstanceGUID] = [dbi].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[dbi].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[Service]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Service](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Description] [nvarchar](2048) NULL,
	[Status] [nvarchar](128) NULL,
	[State] [nvarchar](128) NULL,
	[StartMode] [nvarchar](128) NULL,
	[StartName] [nvarchar](255) NULL,
	[PathName] [nvarchar](255) NULL,
	[AcceptStop] [bit] NOT NULL,
	[AcceptPause] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Service] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ServiceView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[ServiceView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ServiceView]
AS
SELECT [s].[objectGUID]
      ,[s].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[s].[Name]
      ,[s].[DisplayName]
      ,[s].[Description]
      ,[s].[Status]
      ,[s].[State]
      ,[s].[StartMode]
      ,[s].[StartName]
      ,[s].[PathName]
      ,[s].[AcceptStop]
      ,[s].[AcceptPause]
      ,[s].[Active]
      ,[s].[dbAddDate]
      ,[s].[dbLastUpdate]
  FROM [cm].[Service] s INNER JOIN [cm].[Computer] c ON
	[s].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  View [cm].[DatabaseView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[DatabaseView]    Script Date: 1/16/2019 8:32:48 AM ******/



CREATE VIEW [cm].[DatabaseView]
AS
SELECT
      [c].[objectGUID] as [ComputerGUID]
      ,[db].[DatabaseInstanceGUID]
      ,[db].[objectGUID] as [DatabaseObjectGUID]
	  ,[c].[dnsHostName]
	  ,[di].[InstanceName]
	  ,[di].[ConnectionString]
      ,[db].[DatabaseName]
      ,[db].[DatabaseID]
      ,[db].[RecoveryModel]
      ,[db].[Status]
      ,[db].[ReadOnly]
      ,[db].[UserAccess]
      ,[db].[CreateDate]
      ,[db].[Owner]
      ,[db].[LastFullBackup]
      ,[db].[LastDiffBackup]
      ,[db].[LastLogBackup]
      ,[db].[CompatibilityLevel]
	  ,[db].[DataFileSize]
	  ,[db].[DataFileSpaceUsed]
	  ,[db].[LogFileSize]
	  ,[db].[LogFileSpaceUsed]
	  ,[db].[VirtualLogFileCount]
      ,[db].[Active]
      ,[db].[dbAddDate]
      ,[db].[dbLastUpdate]
  FROM [cm].[Database] db INNER JOIN [cm].[DatabaseInstance] di ON
			[db].[DatabaseInstanceGUID] = [di].[objectGUID]
		INNER JOIN [cm].[Computer] c ON
			[di].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[Event]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Event](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[LogName] [nvarchar](255) NOT NULL,
	[MachineName] [nvarchar](255) NOT NULL,
	[EventId] [int] NOT NULL,
	[Source] [nvarchar](255) NOT NULL,
	[TimeGenerated] [datetime2](3) NOT NULL,
	[EntryType] [nvarchar](128) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[UserName] [nvarchar](255) NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Event] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [cm].[EventView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[EventView]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE VIEW [cm].[EventView]
AS
SELECT [e].[ID]
	  ,[c].[dnsHostName]
      ,[e].[ComputerGUID]
      ,[e].[LogName]
      ,[e].[MachineName]
      ,[e].[EventId]
      ,[e].[Source]
      ,[e].[TimeGenerated]
      ,[e].[EntryType]
      ,[e].[Message]
      ,[e].[UserName]
      ,[e].[dbAddDate]
  FROM [cm].[Event] e INNER JOIN [cm].[Computer] c ON
	[e].ComputerGUID = [c].[objectGUID]
GO
/****** Object:  Table [ad].[Computer]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Computer](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DNSHostName] [nvarchar](255) NOT NULL,
	[IPv4Address] [nvarchar](128) NULL,
	[Trusted] [bit] NOT NULL,
	[OperatingSystem] [nvarchar](128) NULL,
	[OperatingSystemVersion] [nvarchar](128) NULL,
	[OperatingSystemServicePack] [nvarchar](128) NULL,
	[Description] [nvarchar](1024) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastLogon] [datetime2](3) NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Computer] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT SELECT ON [ad].[Computer] TO [NT SERVICE\HealthService] AS [dbo]
GO
/****** Object:  Table [ad].[GroupMember]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[GroupMember](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[GroupGUID] [uniqueidentifier] NOT NULL,
	[MemberGUID] [uniqueidentifier] NOT NULL,
	[MemberType] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_ad_GroupMember] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Group]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Group](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Scope] [nvarchar](255) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[Email] [nvarchar](255) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Group] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[User]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[User](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](100) NULL,
	[Description] [nvarchar](255) NULL,
	[JobTitle] [nvarchar](255) NULL,
	[EmployeeNumber] [nvarchar](255) NULL,
	[ProfilePath] [nvarchar](1024) NULL,
	[HomeDirectory] [nvarchar](1024) NULL,
	[Company] [nvarchar](255) NULL,
	[Office] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[Division] [nvarchar](255) NULL,
	[StreetAddress] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](255) NULL,
	[Manager] [nvarchar](255) NULL,
	[MobilePhone] [nvarchar](20) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Pager] [nvarchar](20) NULL,
	[EMail] [nvarchar](255) NULL,
	[LockedOut] [bit] NULL,
	[PasswordExpired] [bit] NULL,
	[PasswordLastSet] [datetime2](3) NULL,
	[PasswordNeverExpires] [bit] NULL,
	[PasswordNotRequired] [bit] NULL,
	[TrustedForDelegation] [bit] NULL,
	[TrustedToAuthForDelegation] [bit] NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastLogon] [datetime2](3) NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_User] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [ad].[GroupMemberView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [ad].[GroupMemberView]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GO
/****** Object:  Table [ad].[SyncStatus]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[SyncStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[ObjectClass] [nvarchar](128) NOT NULL,
	[SyncType] [nvarchar](64) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](128) NULL,
 CONSTRAINT [PK_ad_SyncStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[SyncHistory]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[SyncHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](255) NOT NULL,
	[ObjectClass] [nvarchar](255) NOT NULL,
	[SyncType] [nvarchar](255) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](255) NULL,
 CONSTRAINT [PK_ad_SyncHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [ad].[SyncStatusView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [ad].[SyncStatusView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [ad].[SyncStatusView]

AS

SELECT 
	[ss].[Domain],
	[ss].[ObjectClass],
	[ss].[Status] as LastStatus,
	[ss].[SyncType] as LastSyncType,
	[ss].[StartDate] as LastStartDate,
	MAX(CASE WHEN [sh].[SyncType] = N'Full' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastFullSync],
	MAX(CASE WHEN [sh].[SyncType] = N'Incremental' THEN [sh].[EndDate]
		ELSE NULL
		END) as [LastIncrementalSync]
FROM
	[ad].[SyncStatus] ss inner join [ad].[SyncHistory] sh ON
		[ss].[Domain] = [sh].[Domain] AND
		[ss].[ObjectClass] = [sh].[ObjectClass]
GROUP BY
	[ss].[Domain],
	[ss].[ObjectClass],
	[ss].[Status],
	[ss].[SyncType],
	[ss].[StartDate]
GO
/****** Object:  Table [cm].[ReportingInstance]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ReportingInstance](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ProductName] [nvarchar](128) NOT NULL,
	[ProductEdition] [nvarchar](128) NOT NULL,
	[ProductVersion] [nvarchar](128) NOT NULL,
	[ProductServicePack] [nvarchar](128) NOT NULL,
	[ConnectionString] [nvarchar](255) NOT NULL,
	[ServiceState] [nvarchar](128) NOT NULL,
	[RSConfiguration] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportingInstance] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ReportingInstanceView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[ReportingInstanceView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[ReportingInstanceView]
AS
SELECT [ri].[objectGUID]
      ,[ri].[ComputerGUID]
	  ,[c].[dnsHostName]
      ,[ri].[InstanceName]
      ,[ri].[ProductName]
      ,[ri].[ProductEdition]
      ,[ri].[ProductVersion]
      ,[ri].[ProductServicePack]
      ,[ri].[ConnectionString]
      ,[ri].[ServiceState]
      ,[ri].[RSConfiguration]
      ,[ri].[Active]
      ,[ri].[dbAddDate]
      ,[ri].[dbLastUpdate]
  FROM [cm].[ReportingInstance] ri INNER JOIN [cm].[Computer] c ON
		[ri].[ComputerGUID] = [c].[objectGUID]
GO
/****** Object:  Table [cm].[ClusterNode]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ClusterNode](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ClusterGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ClusterNode] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[Cluster]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Cluster](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ClusterName] [nvarchar](255) NOT NULL,
	[OperatingSystem] [nvarchar](255) NULL,
	[OperatingSystemVersion] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Cluster] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [cm].[ClusterNodeView]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [cm].[ClusterNodeView]    Script Date: 1/16/2019 8:32:48 AM ******/


CREATE VIEW [cm].[ClusterNodeView]
AS
SELECT [cn].[objectGUID]
      ,[cn].[ClusterGUID]
      ,[cn].[ComputerGUID]
	  ,[cl].[ClusterName]
	  ,[c].[dnsHostName]
	  ,[cn].[State]
      ,[cn].[Active]
      ,[cn].[dbAddDate]
      ,[cn].[dbLastUpdate]
  FROM [cm].[ClusterNode] cn INNER JOIN [cm].[Computer] [c] ON
		[cn].[ComputerGUID] = [c].[objectGUID]
		INNER JOIN [cm].[Cluster] cl ON
		[cn].[ClusterGUID] = [cl].[objectGUID]
GO
/****** Object:  Table [ad].[ComputerImport]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[ComputerImport](
	[Description] [varchar](1024) NULL,
	[DNSHostName] [varchar](255) NULL,
	[DistinguishedName] [varchar](1024) NULL,
	[Enabled] [bit] NULL,
	[IPv4Address] [varchar](128) NULL,
	[LastLogonDate] [datetime2](3) NULL,
	[LastLogonTimeStamp] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[ObjectClass] [varchar](255) NULL,
	[objectGUID] [varchar](128) NULL,
	[OperatingSystem] [varchar](128) NULL,
	[OperatingSystemServicePack] [varchar](128) NULL,
	[OperatingSystemVersion] [varchar](128) NULL,
	[SamAccountName] [varchar](255) NULL,
	[SID] [varchar](255) NULL,
	[Trusted] [bit] NULL,
	[UserPrincipalName] [varchar](255) NULL,
	[whenCreated] [datetime2](3) NULL,
	[whenChanged] [datetime2](3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[DeletedObject]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[DeletedObject](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[objectType] [nvarchar](128) NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbDelDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_DeletedObject] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Domain]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Domain](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](128) NOT NULL,
	[Forest] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DNSRoot] [nvarchar](128) NOT NULL,
	[NetBIOSName] [nvarchar](128) NOT NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[InfrastructureMaster] [nvarchar](128) NOT NULL,
	[PDCEmulator] [nvarchar](128) NOT NULL,
	[RIDMaster] [nvarchar](128) NOT NULL,
	[DomainFunctionality] [nvarchar](128) NULL,
	[ForestFunctionality] [nvarchar](128) NULL,
	[UserName] [nvarchar](128) NULL,
	[Password] [varbinary](256) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Domain] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Forest]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Forest](
	[Name] [nvarchar](128) NOT NULL,
	[DomainNamingMaster] [nvarchar](128) NOT NULL,
	[SchemaMaster] [nvarchar](128) NOT NULL,
	[RootDomain] [nvarchar](128) NOT NULL,
	[ForestMode] [nvarchar](128) NULL,
	[UserName] [nvarchar](128) NULL,
	[Password] [varbinary](256) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_Forest] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Site]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Site](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[Location] [nvarchar](1024) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Site] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Subnet]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Subnet](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[Location] [nvarchar](1024) NULL,
	[Site] [nvarchar](255) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Subnet] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[AnalysisDatabase]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[AnalysisDatabase](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[AnalysisInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[UpdateAbility] [nvarchar](128) NOT NULL,
	[EstimatedSize] [bigint] NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[LastProcessedDate] [datetime2](3) NULL,
	[LastSchemaUpdate] [datetime2](3) NULL,
	[Collation] [nvarchar](128) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisDatabase] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[AnalysisDatabaseCube]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[AnalysisDatabaseCube](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[AnalysisInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[CubeName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[LastProcessedDate] [datetime2](3) NULL,
	[LastSchemaUpdate] [datetime2](3) NULL,
	[Collation] [nvarchar](128) NOT NULL,
	[StorageLocation] [nvarchar](255) NULL,
	[StorageMode] [nvarchar](128) NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisDatabaseCube] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[AnalysisInstanceProperty]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[AnalysisInstanceProperty](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[AnalysisInstanceGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[Category] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NOT NULL,
	[Type] [nvarchar](32) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisInstanceProperty] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[ClusterGroup]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ClusterGroup](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ClusterGUID] [uniqueidentifier] NOT NULL,
	[GroupName] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[OwnerNode] [nvarchar](255) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ClusterGroup] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[ClusterResource]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ClusterResource](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ClusterGUID] [uniqueidentifier] NOT NULL,
	[ResourceName] [nvarchar](255) NOT NULL,
	[ResourceType] [nvarchar](255) NOT NULL,
	[OwnerGroup] [nvarchar](255) NOT NULL,
	[OwnerNode] [nvarchar](255) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ClusterResource] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[DatabasePermission]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabasePermission](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[PermissionSource] [nvarchar](32) NOT NULL,
	[PermissionState] [nvarchar](128) NOT NULL,
	[PermissionType] [nvarchar](128) NOT NULL,
	[Grantor] [nvarchar](128) NOT NULL,
	[ObjectName] [nvarchar](128) NOT NULL,
	[Grantee] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabasePermission] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[DatabaseRoleMember]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DatabaseRoleMember](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[RoleName] [nvarchar](128) NOT NULL,
	[RoleMember] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseRoleMember] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[DiskPartition]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DiskPartition](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DiskIndex] [int] NOT NULL,
	[Index] [int] NOT NULL,
	[DeviceID] [nvarchar](255) NOT NULL,
	[Bootable] [bit] NOT NULL,
	[BootPartition] [bit] NOT NULL,
	[PrimaryPartition] [bit] NOT NULL,
	[StartingOffset] [bigint] NULL,
	[Size] [bigint] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DiskPartition] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[DrivePartitionMap]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[DrivePartitionMap](
	[ObjectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[PartitionName] [nvarchar](128) NOT NULL,
	[DriveName] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DrivePartitionMap] PRIMARY KEY CLUSTERED 
(
	[ObjectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[Job]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[Job](
	[JobID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[OriginatingServer] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[Description] [nvarchar](2048) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[Owner] [nvarchar](255) NOT NULL,
	[DateCreated] [datetime2](3) NULL,
	[DateModified] [datetime2](3) NULL,
	[VersionNumber] [int] NOT NULL,
	[LastRunDate] [datetime2](3) NULL,
	[NextRunDate] [datetime2](3) NULL,
	[CurrentRunStatus] [nvarchar](128) NOT NULL,
	[LastRunOutcome] [nvarchar](128) NOT NULL,
	[HasSchedule] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Job] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[LinkedServer]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[LinkedServer](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[ID] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DataSource] [nvarchar](255) NOT NULL,
	[Catalog2] [nvarchar](255) NULL,
	[ProductName] [nvarchar](255) NULL,
	[Provider] [nvarchar](255) NULL,
	[ProviderString] [nvarchar](1024) NULL,
	[DistPublisher] [bit] NOT NULL,
	[Distributor] [bit] NOT NULL,
	[Publisher] [bit] NOT NULL,
	[Subscriber] [bit] NOT NULL,
	[Rpc] [bit] NOT NULL,
	[RpcOut] [bit] NOT NULL,
	[DataAccess] [bit] NOT NULL,
	[DateLastModified] [datetime2](3) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_LinkedServer] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[LinkedServer] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[LinkedServer] TO [cmRead] AS [dbo]
GO
/****** Object:  Table [cm].[LinkedServerLogin]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[LinkedServerLogin](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[LinkedServerID] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Impersonate] [bit] NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[DateLastModified] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_LinkedServerLogin] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[NetworkAdapter]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[NetworkAdapter](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[NetConnectionID] [nvarchar](255) NULL,
	[AdapterType] [nvarchar](255) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[MACAddress] [nvarchar](128) NULL,
	[PhysicalAdapter] [bit] NULL,
	[Speed] [bigint] NULL,
	[NetEnabled] [int] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_NetworkAdapter] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[NetworkAdapterConfiguration]    Script Date: 2/12/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[NetworkAdapterConfiguration](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[MACAddress] [nvarchar](128) NULL,
	[IPV4Address] [nvarchar](255) NULL,
	[SubnetMask] [nvarchar](128) NULL,
	[DefaultIPGateway] [nvarchar](128) NULL,
	[DNSDomainSuffixSearchOrder] [nvarchar](255) NULL,
	[DNSServerSearchOrder] [nvarchar](255) NULL,
	[DNSEnabledForWINSResolution] [bit] NOT NULL,
	[FullDNSRegistrationEnabled] [bit] NOT NULL,
	[DHCPEnabled] [bit] NOT NULL,
	[DHCPLeaseObtained] [datetime2](3) NULL,
	[DHCPLeaseExpires] [datetime2](3) NULL,
	[DHCPServer] [nvarchar](128) NULL,
	[WINSPrimaryServer] [nvarchar](128) NULL,
	[WINSSecondaryServer] [nvarchar](128) NULL,
	[IPEnabled] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_NetworkAdapterConfiguration] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[ReportServerItem]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ReportServerItem](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ReportingInstanceGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](425) NOT NULL,
	[Path] [nvarchar](425) NOT NULL,
	[VirtualPath] [nvarchar](1024) NOT NULL,
	[TypeName] [nvarchar](128) NOT NULL,
	[Size] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[Hidden] [bit] NOT NULL,
	[CreationDate] [datetime2](3) NOT NULL,
	[ModifiedDate] [datetime2](3) NOT NULL,
	[ModifiedBy] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportServerItem] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[ReportServerSubscription]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ReportServerSubscription](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ReportingInstanceGUID] [uniqueidentifier] NOT NULL,
	[Owner] [nvarchar](255) NOT NULL,
	[Path] [nvarchar](1024) NOT NULL,
	[VirtualPath] [nvarchar](1024) NOT NULL,
	[Report] [nvarchar](1024) NOT NULL,
	[Description] [nvarchar](1204) NULL,
	[Status] [nvarchar](128) NOT NULL,
	[SubscriptionActive] [bit] NOT NULL,
	[LastExecuted] [datetime2](3) NULL,
	[ModifiedBy] [nvarchar](255) NOT NULL,
	[ModifiedDate] [datetime2](3) NOT NULL,
	[EventType] [nvarchar](128) NOT NULL,
	[IsDataDriven] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportServerSubscription] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[ReportServerSubscriptionParameter]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[ReportServerSubscriptionParameter](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ReportServerSubscriptionGUID] [uniqueidentifier] NOT NULL,
	[ParameterName] [nvarchar](255) NOT NULL,
	[ParameterValue] [nvarchar](255) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportServerSubscriptionParameter] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[WebApplication]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[WebApplication](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplication] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cm].[WebApplicationURL]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cm].[WebApplicationURL](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[WebApplicationGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[URL] [nvarchar](2048) NOT NULL,
	[UseDefaultCredential] [bit] NOT NULL,
	[FormData] [nvarchar](2048) NULL,
	[LastStatusCode] [nvarchar](128) NOT NULL,
	[LastStatusDescription] [nvarchar](128) NOT NULL,
	[LastResponseTime] [int] NOT NULL,
	[LastUpdate] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplicationURL] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Computer]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Computer](
	[ID] [uniqueidentifier] NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[dnsHostName] [nvarchar](255) NOT NULL,
	[CredentialName] [nvarchar](255) NULL,
	[AgentName] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_Computer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Config]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Config](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ConfigName] [nvarchar](255) NOT NULL,
	[ConfigValue] [nvarchar](255) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbAddBy] [nvarchar](255) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL,
	[dbModBy] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credential]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credential](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CredentialType] [nvarchar](128) NOT NULL,
	[AccountName] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](512) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_Credential] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcessLog]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Severity] [nvarchar](50) NULL,
	[Process] [nvarchar](50) NULL,
	[Object] [nvarchar](255) NULL,
	[Message] [nvarchar](max) NULL,
	[MessageDate] [datetime2](3) NULL,
 CONSTRAINT [PK_ProcessLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportContent]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportContent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [uniqueidentifier] NOT NULL,
	[SortSequence] [int] NOT NULL,
	[ItemBackground] [nvarchar](7) NOT NULL,
	[ItemFont] [nvarchar](255) NOT NULL,
	[ItemFontSize] [nvarchar](7) NOT NULL,
	[ItemFontColor] [nvarchar](7) NOT NULL,
	[ItemDisplay] [nvarchar](1024) NOT NULL,
	[ItemParameters] [nvarchar](max) NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ReportContent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportHeader]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportHeader](
	[Id] [uniqueidentifier] NOT NULL,
	[ReportName] [nvarchar](255) NOT NULL,
	[ReportDisplayName] [nvarchar](255) NOT NULL,
	[ReportBackground] [nvarchar](7) NOT NULL,
	[TitleBackground] [nvarchar](7) NOT NULL,
	[TitleFont] [nvarchar](255) NOT NULL,
	[TitleFontColor] [nvarchar](7) NOT NULL,
	[TitleFontSize] [nvarchar](5) NOT NULL,
	[SubTitleBackground] [nvarchar](7) NOT NULL,
	[SubTitleFont] [nvarchar](255) NOT NULL,
	[SubTitleFontColor] [nvarchar](7) NOT NULL,
	[SubTitleFontSize] [nvarchar](5) NOT NULL,
	[TableHeaderBackground] [nvarchar](7) NOT NULL,
	[TableHeaderFont] [nvarchar](255) NOT NULL,
	[TableHeaderFontColor] [nvarchar](7) NOT NULL,
	[TableHeaderFontSize] [nvarchar](5) NOT NULL,
	[TableFooterBackground] [nvarchar](7) NOT NULL,
	[TableFooterFont] [nvarchar](255) NOT NULL,
	[TableFooterFontColor] [nvarchar](7) NOT NULL,
	[TableFooterFontSize] [nvarchar](5) NOT NULL,
	[RowEvenBackground] [nvarchar](7) NOT NULL,
	[RowEvenFont] [nvarchar](255) NOT NULL,
	[RowEvenFontColor] [nvarchar](7) NOT NULL,
	[RowEvenFontSize] [nvarchar](5) NOT NULL,
	[RowOddBackground] [nvarchar](7) NOT NULL,
	[RowOddFont] [nvarchar](255) NOT NULL,
	[RowOddFontColor] [nvarchar](7) NOT NULL,
	[RowOddFontSize] [nvarchar](5) NOT NULL,
	[FooterBackground] [nvarchar](7) NOT NULL,
	[FooterFont] [nvarchar](255) NOT NULL,
	[FooterFontColor] [nvarchar](7) NOT NULL,
	[FooterFontSize] [nvarchar](5) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ReportHeader] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemTimeZone]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemTimeZone](
	[ZoneID] [uniqueidentifier] NOT NULL,
	[ID] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[StandardName] [nvarchar](255) NOT NULL,
	[DaylightName] [nvarchar](255) NOT NULL,
	[BaseUTCOffset] [int] NOT NULL,
	[CurrentUTCOffset] [int] NOT NULL,
	[SupportsDaylightSavingTime] [bit] NOT NULL,
	[Display] [bit] NULL,
	[DefaultTimeZone] [bit] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_SystemTimeZone] PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pm].[DatabaseSizeDaily]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pm].[DatabaseSizeDaily](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[DatabaseGUID] [uniqueidentifier] NOT NULL,
	[DataFileSize] [bigint] NOT NULL,
	[DataFileSpaceUsed] [bigint] NOT NULL,
	[LogFileSize] [bigint] NOT NULL,
	[LogFileSpaceUsed] [bigint] NOT NULL,
	[Count] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_DatabaseSizeDaily] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pm].[DatabaseSizeRaw]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pm].[DatabaseSizeRaw](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[DatabaseGUID] [uniqueidentifier] NOT NULL,
	[DataFileSize] [bigint] NOT NULL,
	[DataFileSpaceUsed] [bigint] NOT NULL,
	[LogFileSize] [bigint] NOT NULL,
	[LogFileSpaceUsed] [bigint] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_DatabaseSizeRaw] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pm].[LogicalVolumeSizeDaily]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pm].[LogicalVolumeSizeDaily](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[LogicalVolumeGUID] [uniqueidentifier] NOT NULL,
	[SpaceUsed] [bigint] NOT NULL,
	[MaxSpaceUsed] [bigint] NOT NULL,
	[MinSpaceUsed] [bigint] NOT NULL,
	[StDevSpaceUsed] [decimal](18, 3) NOT NULL,
	[Count] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_LogicalVolumeSizeDaily] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pm].[LogicalVolumeSizeRaw]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pm].[LogicalVolumeSizeRaw](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[LogicalVolumeGUID] [uniqueidentifier] NOT NULL,
	[SpaceUsed] [bigint] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_LogicalVolumeSizeRaw] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pm].[WebApplicationURLResponseDaily]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pm].[WebApplicationURLResponseDaily](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[WebApplicationURLGUID] [uniqueidentifier] NOT NULL,
	[FailedCheckCount] [int] NOT NULL,
	[SuccessCheckCount] [int] NOT NULL,
	[AvgResponseTime] [decimal](18, 3) NOT NULL,
	[MinResponseTime] [int] NOT NULL,
	[MaxResponseTime] [int] NOT NULL,
	[StDevResponseTime] [decimal](18, 3) NOT NULL,
	[Count] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplicationResponseDaily] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pm].[WebApplicationURLResponseRaw]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pm].[WebApplicationURLResponseRaw](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[WebApplicationURLGUID] [uniqueidentifier] NOT NULL,
	[StatusCode] [int] NOT NULL,
	[StatusDescription] [nvarchar](128) NOT NULL,
	[LastResponseTime] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplicationResponseRaw] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[Agent]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[Agent](
	[AgentID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](1024) NOT NULL,
	[Domain] [nvarchar](255) NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[PrimaryManagementServer] [nvarchar](255) NOT NULL,
	[Version] [nvarchar](255) NOT NULL,
	[PatchList] [nvarchar](255) NOT NULL,
	[ComputerName] [nvarchar](255) NOT NULL,
	[HealthState] [nvarchar](255) NOT NULL,
	[InstalledBy] [nvarchar](255) NOT NULL,
	[InstallTime] [datetime2](3) NOT NULL,
	[ManuallyInstalled] [bit] NOT NULL,
	[ProxyingEnabled] [bit] NOT NULL,
	[IPAddress] [nvarchar](1024) NULL,
	[LastModified] [datetime2](3) NOT NULL,
	[IsAvailable] [bit] NULL,
	[AvailabilityLastModified] [datetime2](3) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_Agent] PRIMARY KEY NONCLUSTERED 
(
	[AgentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_Agent_Name]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE CLUSTERED INDEX [IX_scom_Agent_Name] ON [scom].[Agent]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[AgentExclusions]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[AgentExclusions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[DNSHostName] [nvarchar](255) NOT NULL,
	[Reason] [nvarchar](1024) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_AgentExclusions_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[Alert]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[Alert](
	[AlertId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](2000) NOT NULL,
	[MonitoringObjectId] [uniqueidentifier] NOT NULL,
	[MonitoringClassId] [uniqueidentifier] NOT NULL,
	[MonitoringObjectDisplayName] [ntext] NOT NULL,
	[MonitoringObjectName] [ntext] NULL,
	[MonitoringObjectPath] [nvarchar](max) NULL,
	[MonitoringObjectFullName] [ntext] NOT NULL,
	[IsMonitorAlert] [bit] NOT NULL,
	[ProblemId] [uniqueidentifier] NOT NULL,
	[MonitoringRuleId] [uniqueidentifier] NOT NULL,
	[ResolutionState] [tinyint] NOT NULL,
	[ResolutionStateName] [nvarchar](50) NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[Severity] [tinyint] NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[Owner] [nvarchar](255) NULL,
	[ResolvedBy] [nvarchar](255) NULL,
	[TimeRaised] [datetime2](3) NOT NULL,
	[TimeAdded] [datetime2](3) NOT NULL,
	[LastModified] [datetime2](3) NOT NULL,
	[LastModifiedBy] [nvarchar](255) NOT NULL,
	[TimeResolved] [datetime2](3) NULL,
	[TimeResolutionStateLastModified] [datetime2](3) NOT NULL,
	[CustomField1] [nvarchar](255) NULL,
	[CustomField2] [nvarchar](255) NULL,
	[CustomField3] [nvarchar](255) NULL,
	[CustomField4] [nvarchar](255) NULL,
	[CustomField5] [nvarchar](255) NULL,
	[CustomField6] [nvarchar](255) NULL,
	[CustomField7] [nvarchar](255) NULL,
	[CustomField8] [nvarchar](255) NULL,
	[CustomField9] [nvarchar](255) NULL,
	[CustomField10] [nvarchar](255) NULL,
	[TicketId] [nvarchar](150) NULL,
	[Context] [ntext] NULL,
	[ConnectorId] [uniqueidentifier] NULL,
	[LastModifiedByNonConnector] [datetime2](3) NOT NULL,
	[MonitoringObjectInMaintenanceMode] [bit] NOT NULL,
	[MaintenanceModeLastModified] [datetime2](3) NOT NULL,
	[MonitoringObjectHealthState] [tinyint] NOT NULL,
	[StateLastModified] [datetime2](3) NOT NULL,
	[ConnectorStatus] [int] NOT NULL,
	[TopLevelHostEntityId] [uniqueidentifier] NULL,
	[RepeatCount] [int] NOT NULL,
	[AlertStringId] [uniqueidentifier] NULL,
	[AlertStringName] [nvarchar](max) NULL,
	[LanguageCode] [nvarchar](3) NULL,
	[AlertStringDescription] [ntext] NULL,
	[AlertParams] [ntext] NULL,
	[SiteName] [nvarchar](255) NULL,
	[TfsWorkItemId] [nvarchar](150) NULL,
	[TfsWorkItemOwner] [nvarchar](255) NULL,
	[HostID] [int] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_scom_Alert] PRIMARY KEY CLUSTERED 
(
	[AlertId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [scom].[AlertAgingBuckets]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[AlertAgingBuckets](
	[AgeID] [int] IDENTITY(1,1) NOT NULL,
	[LowValue] [int] NOT NULL,
	[HighValue] [int] NOT NULL,
	[Label] [nvarchar](128) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[AlertResolutionState]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[AlertResolutionState](
	[ResolutionStateID] [uniqueidentifier] NOT NULL,
	[ResolutionState] [tinyint] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ResolutionStateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[GroupHealthState]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[GroupHealthState](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](255) NOT NULL,
	[Path] [nvarchar](1024) NULL,
	[MonitoringClassIds] [nvarchar](255) NOT NULL,
	[HealthState] [nvarchar](255) NOT NULL,
	[StateLastModified] [datetime2](3) NULL,
	[IsAvailable] [bit] NOT NULL,
	[AvailabilityLastModified] [datetime2](3) NULL,
	[InMaintenanceMode] [bit] NOT NULL,
	[MaintenanceModeLastModified] [datetime2](3) NULL,
	[Display] [bit] NOT NULL DEFAULT [DF_scom_GroupHealthState_Display] (0),
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[Availability] [nvarchar](255) NULL,
	[Configuration] [nvarchar](255) NULL,
	[Performance] [nvarchar](255) NULL,
	[Security] [nvarchar](255) NULL,
	[Other] [nvarchar](255) NULL,
 CONSTRAINT [PK_scom_GroupHealthState] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_scom_GroupHealthState_FullName]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_GroupHealthState_FullName] ON [scom].[GroupHealthState]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[GroupHealthStateAlertRelationship]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[GroupHealthStateAlertRelationship](
	[GroupID] [uniqueidentifier] NOT NULL,
	[AlertID] [uniqueidentifier] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_GroupHealthStateAlertRelationship] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[AlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[MaintenanceReasonCode]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[MaintenanceReasonCode](
	[Id] [uniqueidentifier] NOT NULL,
	[ReasonCode] [smallint] NOT NULL,
	[Reason] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[ObjectAvailabilityHistory]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectAvailabilityHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ManagedEntityID] [uniqueidentifier] NOT NULL,
	[FullName] [nvarchar](2048) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[IntervalDurationMilliseconds] [int] NOT NULL,
	[InWhiteStateMilliseconds] [int] NOT NULL,
	[InGreenStateMilliseconds] [int] NOT NULL,
	[InYellowStateMilliseconds] [int] NOT NULL,
	[InRedStateMilliseconds] [int] NOT NULL,
	[InDisabledStateMilliseconds] [int] NOT NULL,
	[InPlannedMaintenanceMilliseconds] [int] NOT NULL,
	[InUnplannedMaintenanceMilliseconds] [int] NOT NULL,
	[HealthServiceUnavailableMilliseconds] [int] NOT NULL,
 CONSTRAINT [PK_ObjectAvailabilityHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[ObjectClass]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectClass](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[GenericName] [nvarchar](255) NOT NULL,
	[ManagementPackName] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[DistributedApplication] [bit] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_ObjectClass] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_scom_ObjectClass_Name]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_ObjectClass_Name] ON [scom].[ObjectClass]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[ObjectHealthState]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectHealthState](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](255) NOT NULL,
	[Path] [nvarchar](1024) NULL,
	[ObjectClass] [nvarchar](255) NOT NULL,
	[HealthState] [nvarchar](255) NOT NULL,
	[StateLastModified] [datetime2](3) NULL,
	[IsAvailable] [bit] NOT NULL,
	[AvailabilityLastModified] [datetime2](3) NULL,
	[InMaintenanceMode] [bit] NOT NULL,
	[MaintenanceModeLastModified] [datetime2](3) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[Availability] [nvarchar](255) NULL,
	[Configuration] [nvarchar](255) NULL,
	[Performance] [nvarchar](255) NULL,
	[Security] [nvarchar](255) NULL,
	[Other] [nvarchar](255) NULL,
 CONSTRAINT [PK_scom_Object] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_scom_Object_FullName]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_Object_FullName] ON [scom].[ObjectHealthState]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[ObjectHealthStateAlertRelationship]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectHealthStateAlertRelationship](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[AlertID] [uniqueidentifier] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_ObjectAlertRelationship] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[AlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[WindowsComputer]    Script Date: 2/12/2019 10:38:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[WindowsComputer](
	[ID] [uniqueidentifier] NOT NULL,
	[DNSHostName] [nvarchar](255) NOT NULL,
	[IPAddress] [nvarchar](255) NULL,
	[ObjectSID] [nvarchar](255) NULL,
	[NetBIOSDomainName] [nvarchar](255) NULL,
	[DomainDNSName] [nvarchar](255) NULL,
	[OrganizationalUnit] [nvarchar](2048) NULL,
	[ForestDNSName] [nvarchar](255) NULL,
	[ActiveDirectorySite] [nvarchar](255) NULL,
	[IsVirtualMachine] [bit] NULL,
	[HealthState] [nvarchar](255) NULL,
	[StateLastModified] [datetime2](3) NULL,
	[IsAvailable] [bit] NULL,
	[AvailabilityLastModified] [datetime2](3) NULL,
	[InMaintenanceMode] [bit] NULL,
	[MaintenanceModeLastModified] [datetime2](3) NULL,
	[ManagementGroup] [nvarchar](255) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_WindowsComputer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Computer_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Computer_Unique] ON [ad].[Computer]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Domain_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Domain_Unique] ON [ad].[Domain]
(
	[DistinguishedName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Forest_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Forest_Unique] ON [ad].[Forest]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Group_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Group_Unique] ON [ad].[Group]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_GroupMember_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_GroupMember_Unique] ON [ad].[GroupMember]
(
	[Domain] ASC,
	[GroupGUID] ASC,
	[MemberGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Site_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Site_Unique] ON [ad].[Site]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Subnet_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Subnet_Unique] ON [ad].[Subnet]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_SyncStatus_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_SyncStatus_Unique] ON [ad].[SyncStatus]
(
	[Domain] ASC,
	[ObjectClass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_User_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_User_Unique] ON [ad].[User]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_AnalysisDatabase_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisDatabase_Unique] ON [cm].[AnalysisDatabase]
(
	[AnalysisInstanceGUID] ASC,
	[DatabaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_AnalysisDatabaseCube_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisDatabaseCube_Unique] ON [cm].[AnalysisDatabaseCube]
(
	[AnalysisInstanceGUID] ASC,
	[DatabaseName] ASC,
	[CubeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_AnalysisInstance_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisInstance_Unique] ON [cm].[AnalysisInstance]
(
	[ComputerGUID] ASC,
	[InstanceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_AnalysisInstanceProperty_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisInstanceProperty_Unique] ON [cm].[AnalysisInstanceProperty]
(
	[AnalysisInstanceGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_Application_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Application_Unique] ON [cm].[Application]
(
	[Name] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_Application_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Application_Unique] ON [cm].[ApplicationInstallation]
(
	[ComputerGUID] ASC,
	[ApplicationGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_Cluster_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Cluster_Unique] ON [cm].[Cluster]
(
	[ClusterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_ClusterGroup_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ClusterGroup_Unique] ON [cm].[ClusterGroup]
(
	[ClusterGUID] ASC,
	[GroupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_ClusterNode_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ClusterNode_Unique] ON [cm].[ClusterNode]
(
	[ClusterGUID] ASC,
	[ComputerGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_ComputerGroupMember_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ComputerGroupMember_Unique] ON [cm].[ComputerGroupMember]
(
	[ComputerGUID] ASC,
	[GroupName] ASC,
	[MemberName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_ComputerShare_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ComputerShare_Unique] ON [cm].[ComputerShare]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_ComputerSharePermission_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ComputerSharePermission_Unique] ON [cm].[ComputerSharePermission]
(
	[ComputerShareGUID] ASC,
	[SecurityPrincipal] ASC,
	[AccessControlType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_Database_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Database_Unique] ON [cm].[Database]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_DatabaseFile_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseFile_Unique] ON [cm].[DatabaseFile]
(
	[DatabaseGUID] ASC,
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabaseInstance_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseInstance_Unique] ON [cm].[DatabaseInstance]
(
	[ComputerGUID] ASC,
	[InstanceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabaseInstanceLogin_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseInstanceLogin_Unique] ON [cm].[DatabaseInstanceLogin]
(
	[DatabaseInstanceGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabaseInstanceProperty_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseInstanceProperty_Unique] ON [cm].[DatabaseInstanceProperty]
(
	[DatabaseInstanceGUID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabasePermission_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabasePermission_Unique] ON [cm].[DatabasePermission]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC,
	[PermissionSource] ASC,
	[PermissionState] ASC,
	[PermissionType] ASC,
	[Grantor] ASC,
	[ObjectName] ASC,
	[Grantee] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabaseProperty_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseProperty_Unique] ON [cm].[DatabaseProperty]
(
	[DatabaseGUID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabaseRoleMember_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseRoleMember_Unique] ON [cm].[DatabaseRoleMember]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC,
	[RoleName] ASC,
	[RoleMember] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DatabaseUser_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseUser_Unique] ON [cm].[DatabaseUser]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC,
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DiskDrive_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DiskDrive_Unique] ON [cm].[DiskDrive]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DiskPartition_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DiskPartition_Unique] ON [cm].[DiskPartition]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_DrivePartitionMap_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DrivePartitionMap_Unique] ON [cm].[DrivePartitionMap]
(
	[ComputerGUID] ASC,
	[PartitionName] ASC,
	[DriveName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Event_ComputerGUID_LogName]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE NONCLUSTERED INDEX [IX_Event_ComputerGUID_LogName] ON [cm].[Event]
(
	[ComputerGUID] ASC,
	[LogName] ASC
)
INCLUDE ( 	[TimeGenerated]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Job_DatabaseInstanceGUID]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE NONCLUSTERED INDEX [IX_Job_DatabaseInstanceGUID] ON [cm].[Job]
(
	[DatabaseInstanceGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_LinkedServer_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LinkedServer_Unique] ON [cm].[LinkedServer]
(
	[DatabaseInstanceGUID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_LinkedServerLogin_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LinkedServerLogin_Unique] ON [cm].[LinkedServerLogin]
(
	[DatabaseInstanceGUID] ASC,
	[LinkedServerID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_LogicalVolume_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LogicalVolume_Unique] ON [cm].[LogicalVolume]
(
	[ComputerGUID] ASC,
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_NetworkAdapter_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_NetworkAdapter_Unique] ON [cm].[NetworkAdapter]
(
	[ComputerGUID] ASC,
	[Index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_NetworkAdapterConfiguration_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_NetworkAdapterConfiguration_Unique] ON [cm].[NetworkAdapterConfiguration]
(
	[ComputerGUID] ASC,
	[Index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_ReportingInstance_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ReportingInstance_Unique] ON [cm].[ReportingInstance]
(
	[ComputerGUID] ASC,
	[InstanceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_ReportServerItem_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ReportServerItem_Unique] ON [cm].[ReportServerItem]
(
	[ReportingInstanceGUID] ASC,
	[Path] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReportServerSubscriptionParameter_ReportServerSubscriptionGUID]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE NONCLUSTERED INDEX [IX_ReportServerSubscriptionParameter_ReportServerSubscriptionGUID] ON [cm].[ReportServerSubscriptionParameter]
(
	[ReportServerSubscriptionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_Service_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Service_Unique] ON [cm].[Service]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_WebApplication_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WebApplication_Unique] ON [cm].[WebApplication]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_WebApplicationURL_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WebApplicationURL_Unique] ON [cm].[WebApplicationURL]
(
	[WebApplicationGUID] ASC,
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_cm_WindowsUpdate]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WindowsUpdate] ON [cm].[WindowsUpdate]
(
	[HotfixID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_WindowsUpdateInstallation]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WindowsUpdateInstallation] ON [cm].[WindowsUpdateInstallation]
(
	[ComputerGUID] ASC,
	[WindowsUpdateGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Computer_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Computer_Unique] ON [dbo].[Computer]
(
	[Domain] ASC,
	[dnsHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Config_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Config_Unique] ON [dbo].[Config]
(
	[ConfigName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Credential_Unique]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Credential_Unique] ON [dbo].[Credential]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IXu_ReportContent]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE NONCLUSTERED INDEX [IXu_ReportContent] ON [dbo].[ReportContent]
(
	[ReportId] ASC,
	[SortSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IXu_ReportHeader]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IXu_ReportHeader] ON [dbo].[ReportHeader]
(
	[ReportName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_SystemTimeZone_ID]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_SystemTimeZone_ID] ON [dbo].[SystemTimeZone]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_Agent_Domain]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE NONCLUSTERED INDEX [IX_scom_Agent_Domain] ON [scom].[Agent]
(
	[Domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_AgentExclusion_DNSHostName]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE NONCLUSTERED INDEX [IX_scom_AgentExclusion_DNSHostName] ON [scom].[AgentExclusions]
(
	[DNSHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [IX_ObjectAvailabilityHistory]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ObjectAvailabilityHistory] ON [scom].[ObjectAvailabilityHistory]
(
	[ManagedEntityID] ASC,
	[DateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_WindowsComputer]    Script Date: 2/12/2019 10:38:47 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_scom_WindowsComputer] ON [scom].[WindowsComputer]
(
	[DNSHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [cm].[AnalysisDatabase] ADD  CONSTRAINT [DF_cm_AnalysisDatabase_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[AnalysisDatabaseCube] ADD  CONSTRAINT [DF_cm_AnalysisDatabaseCube_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[AnalysisInstance] ADD  CONSTRAINT [DF_cm_AnalysisInstance_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[AnalysisInstanceProperty] ADD  CONSTRAINT [DF_cm_AnalysisInstanceProperty_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_Licensed]  DEFAULT ((0)) FOR [Licensed]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_LicenseMetric]  DEFAULT (N'') FOR [LicenseMetric]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_AvailableLicenses]  DEFAULT ((0)) FOR [AvailableLicenses]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_AllocatedLicenses]  DEFAULT ((0)) FOR [AllocatedLicenses]
GO
ALTER TABLE [cm].[ApplicationInstallation] ADD  CONSTRAINT [DF_cm_ApplicationInstallation_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Cluster] ADD  CONSTRAINT [DF_cm_Cluster_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ClusterGroup] ADD  CONSTRAINT [DF_cm_ClusterGroup_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ClusterNode] ADD  CONSTRAINT [DF_cm_ClusterNode_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ClusterResource] ADD  CONSTRAINT [DF_cm_ClusterResource_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_cm_Computer_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_cm_Computer_Virtual]  DEFAULT ((0)) FOR [IsVirtual]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_dm_Computer_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_cm_Computer_IsClusterResource]  DEFAULT ((0)) FOR [IsClusterResource]
GO
ALTER TABLE [cm].[ComputerGroupMember] ADD  CONSTRAINT [DF_cm_ComputerGroupMember_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ComputerShare] ADD  CONSTRAINT [DF_cm_ComputerShare_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ComputerSharePermission] ADD  CONSTRAINT [DF_cm_ComputerSharePermission_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Database] ADD  CONSTRAINT [DF_cm_Database_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Database] ADD  CONSTRAINT [DF_cm_Database_DataFileSize]  DEFAULT ((0)) FOR [DataFileSize]
GO
ALTER TABLE [cm].[Database] ADD  CONSTRAINT [DF_cm_Database_DataFileSpaceUsed]  DEFAULT ((0)) FOR [DataFileSpaceUsed]
GO
ALTER TABLE [cm].[Database] ADD  CONSTRAINT [DF_cm_Database_LogFileSize]  DEFAULT ((0)) FOR [LogFileSize]
GO
ALTER TABLE [cm].[Database] ADD  CONSTRAINT [DF_cm_Database_LogFileSpaceUsed]  DEFAULT ((0)) FOR [LogFileSpaceUsed]
GO
ALTER TABLE [cm].[Database] ADD  CONSTRAINT [DF_cm_Database_VirtualLogFileCount]  DEFAULT ((0)) FOR [VirtualLogFileCount]
GO
ALTER TABLE [cm].[DatabaseFile] ADD  CONSTRAINT [DF_cm_DatabaseFile_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseInstance] ADD  CONSTRAINT [DF_cm_DatabaseInstance_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseInstanceLogin] ADD  CONSTRAINT [DF_cm_DatabaseInstanceLogin_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseInstanceProperty] ADD  CONSTRAINT [DF_cm_DatabaseInstanceProperty_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabasePermission] ADD  CONSTRAINT [DF_cm_DatabasePermission_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseProperty] ADD  CONSTRAINT [DF_cm_DatabaseProperty_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseRoleMember] ADD  CONSTRAINT [DF_cm_DatabaseRoleMember_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseUser] ADD  CONSTRAINT [DF_cm_DatabaseUser_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DiskDrive] ADD  CONSTRAINT [DF_cm_DiskDrive_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DiskPartition] ADD  CONSTRAINT [DF_cm_DiskPartition_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DrivePartitionMap] ADD  CONSTRAINT [DF_cm_DrivePartitionMap_objectGUID]  DEFAULT (newid()) FOR [ObjectGUID]
GO
ALTER TABLE [cm].[LinkedServer] ADD  CONSTRAINT [DF_cm_LinkedServer_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[LinkedServerLogin] ADD  CONSTRAINT [DF_cm_LinkedServerLogin_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[LogicalVolume] ADD  CONSTRAINT [DF_cm_LogicalVolume_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[LogicalVolume] ADD  CONSTRAINT [DF_cm_LogicalVolume_SpaceUsed]  DEFAULT ((0)) FOR [SpaceUsed]
GO
ALTER TABLE [cm].[NetworkAdapter] ADD  CONSTRAINT [DF_cm_NetworkAdapter_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[NetworkAdapterConfiguration] ADD  CONSTRAINT [DF_cm_NetworkAdapterConfiguration_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[OperatingSystem] ADD  CONSTRAINT [DF_cm_OperatingSystem_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[OperatingSystem] ADD  CONSTRAINT [DF_cm_OperatingSystem_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [cm].[ReportingInstance] ADD  CONSTRAINT [DF_cm_ReportingInstance_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ReportServerItem] ADD  CONSTRAINT [DF_cm_ReportServerItem_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ReportServerSubscription] ADD  CONSTRAINT [DF_cm_ReportServerSubscription_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ReportServerSubscriptionParameter] ADD  CONSTRAINT [DF_cm_ReportServerSubscriptionParameter_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Service] ADD  CONSTRAINT [DF_cm_Service_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[WebApplication] ADD  CONSTRAINT [DF_WebApplication_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastStatusCode]  DEFAULT (N'') FOR [LastStatusCode]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastStatusDescription]  DEFAULT (N'') FOR [LastStatusDescription]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastResponseTime]  DEFAULT ((0)) FOR [LastResponseTime]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [cm].[WindowsUpdate] ADD  CONSTRAINT [DF_cm_WindowsUpdate]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[WindowsUpdateInstallation] ADD  CONSTRAINT [DF_cm_WindowsUpdateInstallation]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [dbo].[Computer] ADD  CONSTRAINT [DF_Computer_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[Credential] ADD  CONSTRAINT [DF_Credential_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[ReportContent] ADD  CONSTRAINT [DF_ReportContent_dbAddDate]  DEFAULT (getdate()) FOR [dbAddDate]
GO
ALTER TABLE [dbo].[ReportContent] ADD  CONSTRAINT [DF_ReportContent_dbModDate]  DEFAULT (getdate()) FOR [dbModDate]
GO
ALTER TABLE [dbo].[ReportHeader] ADD  CONSTRAINT [DF_ReportHeader_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[SystemTimeZone] ADD  CONSTRAINT [DF_SystemTimeZone_ZoneID]  DEFAULT (newid()) FOR [ZoneID]
GO
ALTER TABLE [scom].[MaintenanceReasonCode] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [cm].[AnalysisDatabase]  WITH CHECK ADD  CONSTRAINT [FK_AnalysisDatabase_AnalysisInstance] FOREIGN KEY([AnalysisInstanceGUID])
REFERENCES [cm].[AnalysisInstance] ([objectGUID])
GO
ALTER TABLE [cm].[AnalysisDatabase] CHECK CONSTRAINT [FK_AnalysisDatabase_AnalysisInstance]
GO
ALTER TABLE [cm].[AnalysisDatabaseCube]  WITH CHECK ADD  CONSTRAINT [FK_AnalysisDatabaseCube_AnalysisInstance] FOREIGN KEY([AnalysisInstanceGUID])
REFERENCES [cm].[AnalysisInstance] ([objectGUID])
GO
ALTER TABLE [cm].[AnalysisDatabaseCube] CHECK CONSTRAINT [FK_AnalysisDatabaseCube_AnalysisInstance]
GO
ALTER TABLE [cm].[AnalysisInstanceProperty]  WITH CHECK ADD  CONSTRAINT [FK_AnalysisInstanceProperty_AnalysisInstance] FOREIGN KEY([AnalysisInstanceGUID])
REFERENCES [cm].[AnalysisInstance] ([objectGUID])
GO
ALTER TABLE [cm].[AnalysisInstanceProperty] CHECK CONSTRAINT [FK_AnalysisInstanceProperty_AnalysisInstance]
GO
ALTER TABLE [cm].[ApplicationInstallation]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationInstallation_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[ApplicationInstallation] CHECK CONSTRAINT [FK_ApplicationInstallation_Computer]
GO
ALTER TABLE [cm].[ClusterGroup]  WITH CHECK ADD  CONSTRAINT [FK_ClusterGroup_Cluster] FOREIGN KEY([ClusterGUID])
REFERENCES [cm].[Cluster] ([objectGUID])
GO
ALTER TABLE [cm].[ClusterGroup] CHECK CONSTRAINT [FK_ClusterGroup_Cluster]
GO
ALTER TABLE [cm].[ComputerGroupMember]  WITH CHECK ADD  CONSTRAINT [FK_ComputerGroupMember_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[ComputerGroupMember] CHECK CONSTRAINT [FK_ComputerGroupMember_Computer]
GO
ALTER TABLE [cm].[ComputerShare]  WITH CHECK ADD  CONSTRAINT [FK_ComputerShare_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[ComputerShare] CHECK CONSTRAINT [FK_ComputerShare_Computer]
GO
ALTER TABLE [cm].[DatabaseFile]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseFile_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseFile] CHECK CONSTRAINT [FK_DatabaseFile_Database]
GO
ALTER TABLE [cm].[DatabaseInstanceLogin]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseInstanceLogin_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseInstanceLogin] CHECK CONSTRAINT [FK_DatabaseInstanceLogin_DatabaseInstance]
GO
ALTER TABLE [cm].[DatabaseInstanceProperty]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseInstanceProperty_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseInstanceProperty] CHECK CONSTRAINT [FK_DatabaseInstanceProperty_DatabaseInstance]
GO
ALTER TABLE [cm].[DatabasePermission]  WITH CHECK ADD  CONSTRAINT [FK_DatabasePermission_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabasePermission] CHECK CONSTRAINT [FK_DatabasePermission_DatabaseInstance]
GO
ALTER TABLE [cm].[DatabaseProperty]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseProperty_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseProperty] CHECK CONSTRAINT [FK_DatabaseProperty_Database]
GO
ALTER TABLE [cm].[DatabaseUser]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseUser_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseUser] CHECK CONSTRAINT [FK_DatabaseUser_DatabaseInstance]
GO
ALTER TABLE [cm].[DiskDrive]  WITH CHECK ADD  CONSTRAINT [FK_DiskDrive_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[DiskDrive] CHECK CONSTRAINT [FK_DiskDrive_Computer]
GO
ALTER TABLE [cm].[DiskPartition]  WITH CHECK ADD  CONSTRAINT [FK_DiskPartition_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[DiskPartition] CHECK CONSTRAINT [FK_DiskPartition_Computer]
GO
ALTER TABLE [cm].[DrivePartitionMap]  WITH CHECK ADD  CONSTRAINT [FK_DrivePartitionMap_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[DrivePartitionMap] CHECK CONSTRAINT [FK_DrivePartitionMap_Computer]
GO
ALTER TABLE [cm].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Job_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[Job] CHECK CONSTRAINT [FK_Job_DatabaseInstance]
GO
ALTER TABLE [cm].[LinkedServer]  WITH CHECK ADD  CONSTRAINT [FK_LinkedServer_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[LinkedServer] CHECK CONSTRAINT [FK_LinkedServer_DatabaseInstance]
GO
ALTER TABLE [cm].[LinkedServerLogin]  WITH CHECK ADD  CONSTRAINT [FK_LinkedServerLogin_LinkedServer] FOREIGN KEY([DatabaseInstanceGUID], [LinkedServerID])
REFERENCES [cm].[LinkedServer] ([DatabaseInstanceGUID], [ID])
GO
ALTER TABLE [cm].[LinkedServerLogin] CHECK CONSTRAINT [FK_LinkedServerLogin_LinkedServer]
GO
ALTER TABLE [cm].[LogicalVolume]  WITH CHECK ADD  CONSTRAINT [FK_LogicalVolume_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[LogicalVolume] CHECK CONSTRAINT [FK_LogicalVolume_Computer]
GO
ALTER TABLE [cm].[NetworkAdapter]  WITH CHECK ADD  CONSTRAINT [FK_NetworkAdapter_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[NetworkAdapter] CHECK CONSTRAINT [FK_NetworkAdapter_Computer]
GO
ALTER TABLE [cm].[NetworkAdapterConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_NetworkAdapterConfiguration_NetworkAdapter] FOREIGN KEY([ComputerGUID], [Index])
REFERENCES [cm].[NetworkAdapter] ([ComputerGUID], [Index])
GO
ALTER TABLE [cm].[NetworkAdapterConfiguration] CHECK CONSTRAINT [FK_NetworkAdapterConfiguration_NetworkAdapter]
GO
ALTER TABLE [cm].[OperatingSystem]  WITH CHECK ADD  CONSTRAINT [FK_OperatingSystem_Computer] FOREIGN KEY([computerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[OperatingSystem] CHECK CONSTRAINT [FK_OperatingSystem_Computer]
GO
ALTER TABLE [cm].[ReportServerItem]  WITH CHECK ADD  CONSTRAINT [FK_ReportServerItem_ReportingInstance] FOREIGN KEY([ReportingInstanceGUID])
REFERENCES [cm].[ReportingInstance] ([objectGUID])
GO
ALTER TABLE [cm].[ReportServerItem] CHECK CONSTRAINT [FK_ReportServerItem_ReportingInstance]
GO
ALTER TABLE [cm].[ReportServerSubscription]  WITH CHECK ADD  CONSTRAINT [FK_ReportServerSubscription_ReportingInstance] FOREIGN KEY([ReportingInstanceGUID])
REFERENCES [cm].[ReportingInstance] ([objectGUID])
GO
ALTER TABLE [cm].[ReportServerSubscription] CHECK CONSTRAINT [FK_ReportServerSubscription_ReportingInstance]
GO
ALTER TABLE [cm].[ReportServerSubscriptionParameter]  WITH CHECK ADD  CONSTRAINT [FK_ReportServerSubscriptionParameter_ReportServerSubscription] FOREIGN KEY([ReportServerSubscriptionGUID])
REFERENCES [cm].[ReportServerSubscription] ([objectGUID])
GO
ALTER TABLE [cm].[ReportServerSubscriptionParameter] CHECK CONSTRAINT [FK_ReportServerSubscriptionParameter_ReportServerSubscription]
GO
ALTER TABLE [cm].[Service]  WITH CHECK ADD  CONSTRAINT [FK_Service_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[Service] CHECK CONSTRAINT [FK_Service_Computer]
GO
ALTER TABLE [pm].[DatabaseSizeDaily]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseSizeDaily_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [pm].[DatabaseSizeDaily] CHECK CONSTRAINT [FK_DatabaseSizeDaily_Database]
GO
ALTER TABLE [pm].[DatabaseSizeRaw]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseSizeRaw_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [pm].[DatabaseSizeRaw] CHECK CONSTRAINT [FK_DatabaseSizeRaw_Database]
GO
ALTER TABLE [pm].[LogicalVolumeSizeDaily]  WITH CHECK ADD  CONSTRAINT [FK_LogicalVolumeSizeDaily_LogicalVolume] FOREIGN KEY([ComputerGUID], [LogicalVolumeGUID])
REFERENCES [cm].[LogicalVolume] ([ComputerGUID], [objectGUID])
GO
ALTER TABLE [pm].[LogicalVolumeSizeDaily] CHECK CONSTRAINT [FK_LogicalVolumeSizeDaily_LogicalVolume]
GO
ALTER TABLE [pm].[LogicalVolumeSizeRaw]  WITH CHECK ADD  CONSTRAINT [FK_LogicalVolumeSizeRaw_LogicalVolume] FOREIGN KEY([ComputerGUID], [LogicalVolumeGUID])
REFERENCES [cm].[LogicalVolume] ([ComputerGUID], [objectGUID])
GO
ALTER TABLE [pm].[LogicalVolumeSizeRaw] CHECK CONSTRAINT [FK_LogicalVolumeSizeRaw_LogicalVolume]
GO
ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD  CONSTRAINT [FK_ReportContent_ReportHeader] FOREIGN KEY([ReportId])
REFERENCES [dbo].[ReportHeader] ([Id])
GO
ALTER TABLE [scom].[GroupHealthStateAlertRelationship]  WITH CHECK ADD  CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_GroupHealthState] FOREIGN KEY([GroupId])
REFERENCES [scom].[GroupHealthState] ([Id])
GO
ALTER TABLE [scom].[GroupHealthStateAlertRelationship]  WITH CHECK ADD  CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_Alert] FOREIGN KEY([AlertId])
REFERENCES [scom].[Alert] ([AlertId])
GO
ALTER TABLE [scom].[ObjectHealthStateAlertRelationship]  WITH CHECK ADD  CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_ObjectHealthState] FOREIGN KEY([ObjectId])
REFERENCES [scom].[ObjectHealthState] ([Id])
GO
ALTER TABLE [scom].[ObjectHealthStateAlertRelationship]  WITH CHECK ADD  CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_Alert] FOREIGN KEY([AlertId])
REFERENCES [scom].[Alert] ([AlertId])
GO
/****** Object:  StoredProcedure [ad].[spComputerDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spComputerInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerInactivate
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Computer]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spComputerInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerInactivateByDate
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Computer]
	SET [Active] = 0--, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < DateAdd(Minute, -15, @BeforeDate)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spComputerSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerSelect] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Computer] 
	WHERE  ([dnsHostName] = @dnsHostName) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spComputerUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(255),
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @DNSHostName nvarchar(255),
    @IPv4Address nvarchar(128) = NULL,
    @Trusted bit,
    @OperatingSystem nvarchar(128) = NULL,
    @OperatingSystemVersion nvarchar(128) = NULL,
    @OperatingSystemServicePack nvarchar(128) = NULL,
    @Description nvarchar(1024) = NULL,
    @DistinguishedName nvarchar(1024),
    @Enabled bit,
    @Active bit,
    @LastLogon datetime2(3) = NULL,
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [Name] FROM [ad].[Computer] WHERE Name = @Name AND Domain = @Domain AND [objectGUID] != @objectGUID)
	BEGIN
		BEGIN TRAN
		
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
		SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'Computer', dbAddDate, CURRENT_TIMESTAMP 
		FROM [ad].[Computer]
		WHERE [Name] = @Name AND Domain = @Domain

		DELETE FROM [ad].[Computer] 
		WHERE Name = @Name AND Domain = @Domain

		COMMIT
	END

	
	BEGIN TRAN

	MERGE [ad].[Computer] AS target
	USING (SELECT @SID, @Domain, @Name, @DNSHostName, @IPv4Address, @Trusted, @OperatingSystem, @OperatingSystemVersion, @OperatingSystemServicePack, @Description, @DistinguishedName, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SID] = @SID, [Domain] = @Domain, [Name] = @Name, [DNSHostName] = @DNSHostName, [IPv4Address] = @IPv4Address, [Trusted] = @Trusted, [OperatingSystem] = @OperatingSystem, [OperatingSystemVersion] = @OperatingSystemVersion, [OperatingSystemServicePack] = @OperatingSystemServicePack, [Description] = @Description, [DistinguishedName] = @DistinguishedName, [Enabled] = @Enabled, [Active] = @Active, [LastLogon] = @LastLogon, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Domain, @Name, @DNSHostName, @IPv4Address, @Trusted, @OperatingSystem, @OperatingSystemVersion, @OperatingSystemServicePack, @Description, @DistinguishedName, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spComputerUpsert_Import]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************
* Name: ad.spComputerUpsert_Import
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerUpsert_Import] 

AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	-- TEST FOR UNIQUENESS
	--IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Computer] WHERE [DistinguishedName] = DistinguishedName AND [objectGUID] != objectGUID)
	--BEGIN
	--	INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
	--	SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'Computer', dbAddDate, CURRENT_TIMESTAMP 
	--	FROM [ad].[Computer]
	--	WHERE [DistinguishedName] = DistinguishedName

	--	DELETE FROM [ad].[Computer] 
	--	WHERE DistinguishedName = DistinguishedName
	--END
	
	BEGIN TRAN

	MERGE [ad].[Computer] AS [target]
	USING (SELECT [objectGUID], [SID], right(DNSHostName, len(DNSHostName) - (len([Name])+1)) as [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [LastLogonDate] as LastLogon, [whenCreated], [whenChanged] 
			FROM ad.ComputerImport
			WHERE (LEN(DNSHostName) > 0 AND CHARINDEX('.',DNSHostName) > 0)) 
		AS source 
		([objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [LastLogon], [whenCreated], [whenChanged])
	-- !!!! Check the criteria for match
	ON (source.[objectGUID] = [target].[objectGUID])
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SID] = source.[SID], [Domain] = source.[Domain], [Name] = source.[Name], [DNSHostName] = source.[DNSHostName], [IPv4Address] = source.IPv4Address, [Trusted] = source.Trusted, [OperatingSystem] = source.OperatingSystem, [OperatingSystemVersion] = source.OperatingSystemVersion, [OperatingSystemServicePack] = source.OperatingSystemServicePack, [Description] = source.Description, [DistinguishedName] = source.DistinguishedName, [Enabled] = source.Enabled, [LastLogon] = source.LastLogon, [whenCreated] = source.whenCreated, [Active] = 1, [whenChanged] = source.whenChanged, [dbLastUpdate] = current_timestamp
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
		VALUES (source.objectGUID, source.SID, source.Domain, source.Name, source.DNSHostName, source.IPv4Address, source.Trusted, source.OperatingSystem, source.OperatingSystemVersion, source.OperatingSystemServicePack, source.Description, source.DistinguishedName, source.Enabled, 1, source.LastLogon, source.whenCreated, source.whenChanged, current_timestamp, current_timestamp)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spDomainDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spDomainDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Domain]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spDomainInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spDomainInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Domain]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Domain]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spDomainSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spDomainSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Domain] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spDomainUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spDomainUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(128),
    @Forest nvarchar(128),
    @Name nvarchar(128),
    @DNSRoot nvarchar(128),
    @NetBIOSName nvarchar(128),
    @DistinguishedName nvarchar(255),
    @InfrastructureMaster nvarchar(128),
    @PDCEmulator nvarchar(128),
    @RIDMaster nvarchar(128),
    @DomainFunctionality nvarchar(128) = NULL,
    @ForestFunctionality nvarchar(128) = NULL,
    @UserName nvarchar(128) = NULL,
    @Password varbinary(256) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[Domain] AS target
	USING (SELECT @SID, @Forest, @Name, @DNSRoot, @NetBIOSName, @DistinguishedName, @InfrastructureMaster, @PDCEmulator, @RIDMaster, @DomainFunctionality, @ForestFunctionality, @UserName, @Password, @dbLastUpdate, @Active, @dbLastUpdate) 
		AS source 
		([SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [objectGUID] = @objectGUID, [SID] = @SID, [Forest] = @Forest, [Name] = @Name, [DNSRoot] = @DNSRoot, [NetBIOSName] = @NetBIOSName, [DistinguishedName] = @DistinguishedName, [InfrastructureMaster] = @InfrastructureMaster, [PDCEmulator] = @PDCEmulator, [RIDMaster] = @RIDMaster, [DomainFunctionality] = @DomainFunctionality, [ForestFunctionality] = @ForestFunctionality, [UserName] = @UserName, [Password] = @Password, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Forest, @Name, @DNSRoot, @NetBIOSName, @DistinguishedName, @InfrastructureMaster, @PDCEmulator, @RIDMaster, @DomainFunctionality, @ForestFunctionality, @UserName, @Password, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Domain]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spForestDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [ad].[spForestDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spForestDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spForestDelete] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Forest]
	WHERE  [Name] = @Name

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spForestInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spForestInactivate
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spForestInactivate] 
    @ForestName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Forest]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @ForestName
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate], [dbDelDate]
	FROM   [ad].[Forest]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spForestSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spForestSelect
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/

CREATE PROC [ad].[spForestSelect] 
    @Name nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Forest] 
	WHERE  ([Name] = @Name OR @Name IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spForestUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************
* Name: ad.spForestUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spForestUpsert] 
    @Name nvarchar(128),
    @DomainNamingMaster nvarchar(128),
    @SchemaMaster nvarchar(128),
    @RootDomain nvarchar(128),
    @ForestMode nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[Forest] AS target
	USING (SELECT @DomainNamingMaster, @SchemaMaster, @RootDomain, @ForestMode, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DomainNamingMaster] = @DomainNamingMaster, [SchemaMaster] = @SchemaMaster, [RootDomain] = @RootDomain, [ForestMode] = @ForestMode, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @DomainNamingMaster, @SchemaMaster, @RootDomain, @ForestMode, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Forest]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Group]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Group]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberDelete] 
    @ID bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[GroupMember]
	WHERE  [ID] = @ID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivate] 
    @ID bigint,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ID] = @ID
	              
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	              
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByGroup]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberInactivateByGroup
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivateByGroup] 
    @Domain nvarchar(128),
    @GroupGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain
		AND [GroupGUID] = @GroupGUID
	
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByMember]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberInactivateByMember
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivateByMember] 
    @Domain nvarchar(128),
    @MemberGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain
		AND [MemberGUID] = @MemberGUID
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberSelect] 
    @ID bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [GroupGUID], [MemberGUID], [MemberType], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[GroupMember] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupMemberUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupMemberUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberUpsert] 
    @Domain nvarchar(128),
    @GroupGUID uniqueidentifier,
    @MemberGUID uniqueidentifier,
    @MemberType nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[GroupMember] AS target
	USING (SELECT @MemberType, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([MemberType], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Domain] = @Domain AND [GroupGUID] = @GroupGUID AND [MemberGUID] = @MemberGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [GroupGUID] = @GroupGUID, [MemberGUID] = @MemberGUID, [MemberType] = @MemberType, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [GroupGUID], [MemberGUID], [MemberType], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @GroupGUID, @MemberGUID, @MemberType, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [GroupGUID], [MemberGUID], [MemberType], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[GroupMember]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Group] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spGroupUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spGroupUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(255),
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @Scope nvarchar(255),
    @Category nvarchar(255),
    @Description nvarchar(2048) = NULL,
    @Email nvarchar(255) = NULL,
    @DistinguishedName nvarchar(1024),
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Group] WHERE [Name] = @Name AND [Domain] = @Domain AND [objectGUID] != @objectGUID)
	BEGIN
		BEGIN TRAN
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
		SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'Group', [dbAddDate], [dbLastUpdate] 
		FROM [ad].[Group]
		WHERE [Name] = @Name AND [Domain] = @Domain

		DELETE FROM [ad].[Group] 
		WHERE [Name] = @Name AND [Domain] = @Domain
		COMMIT
	END

	BEGIN TRAN

	MERGE [ad].[Group] AS target
	USING (SELECT @SID, @Name, @Scope, @Category, @Description, @Email, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([SID], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID )
       WHEN MATCHED THEN 
		UPDATE 
		SET    [objectGUID] = @objectGUID, [SID] = @SID, [Name] = @Name, [Scope] = @Scope, [Category] = @Category, [Description] = @Description, [Email] = @Email, [DistinguishedName] = @DistinguishedName, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Domain, @Name, @Scope, @Category, @Description, @Email, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSiteDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSiteDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSiteInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSiteInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Site]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSiteInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSiteInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Site]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSiteSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSiteSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Site] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSiteUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSiteUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSiteUpsert] 
    @objectGUID uniqueidentifier,
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @Description nvarchar(1024) = NULL,
    @Location nvarchar(1024) = NULL,
    @DistinguishedName nvarchar(1024),
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Site] WHERE [Domain] = @Domain AND [Name] = @Name AND [objectGUID] != @objectGUID)
	BEGIN
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate], [dbDelDate])
		SELECT [objectGUID], '', [Domain], [Name], [DistinguishedName], N'Site', [dbAddDate], [dbLastUpdate] 
		FROM [ad].[Site]
		WHERE [Domain] = @Domain AND [Name] = @Name

		DELETE FROM [ad].[Site] 
		WHERE [Domain] = @Domain AND [Name] = @Name
	END

	MERGE [ad].[Site] AS target
	USING (SELECT @Domain, @Name, @Description, @Location, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [Domain] = @Domain, [Name] = @Name, [Description] = @Description, [Location] = @Location, [DistinguishedName] = @DistinguishedName, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @Domain, @Name, @Description, @Location, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Site]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSubnetDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSubnetDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[Subnet]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSubnetInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSubnetInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Subnet]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Subnet]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSubnetInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSubnetInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Subnet]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Subnet]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSubnetSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSubnetSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Subnet] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSubnetSelectBySubnet]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************
* Name: ad.spSubnetSelectBySubnet
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetSelectBySubnet] 
    @Name varchar(255) = NULL,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Subnet] 
	WHERE  ([Name] = @Name OR @Name IS NULL) and Active >= @Active

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSubnetUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSubnetUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSubnetUpsert] 
    @objectGUID uniqueidentifier,
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @Description nvarchar(1024) = NULL,
    @Location nvarchar(1024) = NULL,
    @Site nvarchar(255) = NULL,
    @DistinguishedName nvarchar(1024),
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	-- TEST FOR UNIQUENESS
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Subnet] WHERE 	[Domain] = @Domain AND [Name] = @Name AND [objectGUID] != @objectGUID)
	BEGIN
		BEGIN TRAN

		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate], [dbDelDate])
		SELECT [objectGUID], '', [Domain], [Name], [DistinguishedName], N'Subnet', [dbAddDate], [dbLastUpdate]
		FROM [ad].[Subnet]
		WHERE [Domain] = @Domain AND [Name] = @Name

		DELETE FROM [ad].[Subnet] 
		WHERE [Domain] = @Domain AND [Name] = @Name

		COMMIT
	END

	MERGE [ad].[Subnet] AS target
	USING (SELECT @Domain, @Name, @Description, @Location, @Site, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate) 
		AS source 
		([Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [Name] = @Name, [Description] = @Description, [Location] = @Location, [Site] = @Site, [DistinguishedName] = @DistinguishedName, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @Domain, @Name, @Description, @Location, @Site, @DistinguishedName, @whenCreated, @whenChanged, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Subnet]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSyncHistoryDeleteByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSyncHistoryDeleteByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncHistoryDeleteByDate]
	@DaysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM [ad].[SyncHistory]
      WHERE [EndDate] < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSyncHistoryInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSyncHistoryInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncHistoryInsert] 
    @Domain nvarchar(128),
    @ObjectClass nvarchar(128),
    @SyncType nvarchar(64),
    @StartDate datetime2(3) = NULL,
    @EndDate datetime2(3) = NULL,
    @Count int = NULL,
    @Status nvarchar(255) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN


	INSERT INTO ad.SyncHistory ([Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
	VALUES (@Domain, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [ad].[SyncHistory]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSyncHistorySelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSyncHistorySelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncHistorySelect] 
    @ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [ad].[SyncHistory] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSyncStatusSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSyncStatusSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncStatusSelect] 
    @Domain nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [ad].[SyncStatus] 
	WHERE  ([Domain] = @Domain AND [ObjectClass] = @ObjectClass) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSyncStatusUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSyncStatusUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncStatusUpsert] 
    @Domain nvarchar(128),
    @ObjectClass nvarchar(128),
    @SyncType nvarchar(64),
    @StartDate datetime2(3) = NULL,
    @EndDate datetime2(3) = NULL,
    @Count int = NULL,
    @Status nvarchar(128) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[SyncStatus] AS target
	USING (SELECT @SyncType, @StartDate, @EndDate, @Count, @Status) 
		AS source 
		([SyncType], [StartDate], [EndDate], [Count], [Status])
	-- !!!! Check the criteria for match
	ON ([Domain] = @Domain AND [ObjectClass] = @ObjectClass)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SyncType] = @SyncType, [StartDate] = @StartDate, [EndDate] = @EndDate, [Count] = @Count, [Status] = @Status
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
		VALUES (@Domain, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [ad].[SyncStatus]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spSyncStatusViewSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spSyncStatusViewSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncStatusViewSelect] 
    @Domain nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Domain], [ObjectClass], [LastStatus], [LastSyncType], [LastStartDate], [LastFullSync], [LastIncrementalSync]
	FROM   [ad].[SyncStatusView] 
	WHERE  ([Domain] = @Domain AND [ObjectClass] = @ObjectClass) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spUserDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spUserDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spUserInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spUserInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[User]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spUserInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spUserInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[User]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spUserSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spUserSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[User] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [ad].[spUserUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spUserUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(255),
    @Domain nvarchar(128),
    @Name nvarchar(255),
    @FirstName nvarchar(50) = NULL,
    @LastName nvarchar(50) = NULL,
    @DisplayName nvarchar(100) = NULL,
    @Description nvarchar(255) = NULL, -- new
    @JobTitle nvarchar(255) = NULL, -- new
    @EmployeeNumber nvarchar(255) = NULL, -- new
    @ProfilePath nvarchar(255) = NULL, -- new
    @HomeDirectory nvarchar(255) = NULL, -- new
    @Company nvarchar(255) = NULL,
    @Office nvarchar(255) = NULL,
    @Department nvarchar(255) = NULL,
    @Division nvarchar(255) = NULL,
    @StreetAddress nvarchar(255) = NULL,
    @City nvarchar(255) = NULL,
    @State nvarchar(255) = NULL,
    @PostalCode nvarchar(255) = NULL,
    @Manager nvarchar(255) = NULL,
    @MobilePhone nvarchar(20) = NULL,
    @PhoneNumber nvarchar(20) = NULL,
    @Fax nvarchar(20) = NULL,
    @Pager nvarchar(20) = NULL,
    @EMail nvarchar(255) = NULL,
    @LockedOut bit = NULL, -- new
    @PasswordExpired bit = NULL, -- new
    @PasswordLastSet datetime2(3) = NULL, -- new
    @PasswordNeverExpires bit = NULL, -- new
    @PasswordNotRequired bit = NULL, -- new
    @TrustedForDelegation bit = NULL, -- new
    @TrustedToAuthForDelegation bit = NULL, -- new
    @DistinguishedName nvarchar(1024),
    @Enabled bit,
    @Active bit,
    @LastLogon datetime2(3) = NULL,
    @whenCreated datetime2(3),
    @whenChanged datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	-- TEST FOR UNIQUENESS; CHECK FOR SAME DISTINGUISHED NAME BUT UNMATCHED OBJECTGUID
	IF EXISTS (SELECT [DistinguishedName] FROM [ad].[User] WHERE [Name] = @Name AND [Domain] = @Domain AND [objectGUID] != @objectGUID)
	BEGIN
		INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbDelDate])
		SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'User', [dbLastUpdate] 
		FROM [ad].[User]
		WHERE [Name] = @Name AND [Domain] = @Domain

		DELETE FROM [ad].[User] 
		WHERE [Name] = @Name AND [Domain] = @Domain
	END

	MERGE [ad].[User] AS target
	USING (SELECT @SID, @Domain, @Name, @FirstName, @LastName, @DisplayName, @Description, @JobTitle, @EmployeeNumber, @ProfilePath, @HomeDirectory, @Company, @Office, @Department, @Division, @StreetAddress, @City, @State, @PostalCode, @Manager, @MobilePhone, @PhoneNumber, @Fax, @Pager, @EMail, @LockedOut, @PasswordExpired, @PasswordLastSet, @PasswordNeverExpires, @PasswordNotRequired, @TrustedForDelegation, @TrustedToAuthForDelegation, @DistinguishedName, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [Name], [SID], [FirstName], [LastName], [DisplayName], [Description], [JobTitle], [EmployeeNumber], [ProfilePath], [HomeDirectory], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [LockedOut], [PasswordExpired], [PasswordLastSet], [PasswordNeverExpires], [PasswordNotRequired], [TrustedForDelegation], [TrustedToAuthForDelegation], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SID] = @SID, [Domain] = @Domain, [Name] = @Name, [FirstName] = @FirstName, [LastName] = @LastName, [DisplayName] = @DisplayName, [Description] = @Description, [JobTitle] = @Jobtitle, [EmployeeNumber] = @EmployeeNumber, [ProfilePath] = @ProfilePath, [HomeDirectory] = @HomeDirectory, [Company] = @Company, [Office] = @Office, [Department] = @Department, [Division] = @Division, [StreetAddress] = @StreetAddress, [City] = @City, [State] = @State, [PostalCode] = @PostalCode, [Manager] = @Manager, [MobilePhone] = @MobilePhone, [PhoneNumber] = @PhoneNumber, [Fax] = @Fax, [Pager] = @Pager, [EMail] = @EMail, [LockedOut] = @LockedOut, [PasswordExpired] = @PasswordExpired, [PasswordLastSet] = @PasswordLastSet, [PasswordNeverExpires] = @PasswordNeverExpires, [PasswordNotRequired] = @PasswordNotRequired, [TrustedForDelegation] = @TrustedForDelegation, [TrustedToAuthForDelegation] = @TrustedToAuthForDelegation, [DistinguishedName] = @DistinguishedName, [Enabled] = @Enabled, [Active] = @Active, [LastLogon] = @LastLogon, [whenCreated] = @whenCreated, [whenChanged] = @whenChanged, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Description], [JobTitle], [EmployeeNumber], [ProfilePath], [HomeDirectory], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [LockedOut], [PasswordExpired], [PasswordLastSet], [PasswordNeverExpires], [PasswordNotRequired], [TrustedForDelegation], [TrustedToAuthForDelegation], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Domain, @Name, @FirstName, @LastName, @DisplayName, @Description, @JobTitle, @EmployeeNumber, @ProfilePath, @HomeDirectory, @Company, @Office, @Department, @Division, @StreetAddress, @City, @State, @PostalCode, @Manager, @MobilePhone, @PhoneNumber, @Fax, @Pager, @EMail, @LockedOut, @PasswordExpired, @PasswordLastSet, @PasswordNeverExpires, @PasswordNotRequired, @TrustedForDelegation, @TrustedToAuthForDelegation, @DistinguishedName, @Enabled, @Active, @LastLogon, @whenCreated, @whenChanged, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseCubeDeleteByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseCubeDeleteByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseCubeDeleteByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[AnalysisDatabaseCube]
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseCubeInactivateByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseCubeInactivateByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseCubeInactivateByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[AnalysisDatabaseCube]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabaseCube]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseCubeSelectByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseCubeSelectByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseCubeSelectByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisDatabaseCube] 
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseCubeUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseCubeUpsert
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseCubeUpsert] 
    @AnalysisInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @CubeName nvarchar(128),
    @Description nvarchar(1024) = NULL,
    @CreateDate datetime2(3),
    @LastProcessedDate datetime2(3) = NULL,
    @LastSchemaUpdate datetime2(3) = NULL,
    @Collation nvarchar(128),
	@StorageLocation nvarchar(255),
	@StorageMode nvarchar(128),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[AnalysisDatabaseCube] AS target
	USING (SELECT @Description, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @StorageLocation, @StorageMode, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([AnalysisInstanceGUID] = @AnalysisInstanceGUID AND [DatabaseName] = @DatabaseName AND [CubeName] = @CubeName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [CreateDate] = @CreateDate, [LastProcessedDate] = @LastProcessedDate, [LastSchemaUpdate] = @LastSchemaUpdate, [Collation] = @Collation, [StorageLocation] = @StorageLocation, [StorageMode] = @StorageMode, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([AnalysisInstanceGUID], [DatabaseName], [CubeName], [Description],[CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@AnalysisInstanceGUID, @DatabaseName, @CubeName, @Description, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @StorageLocation, @StorageMode, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [StorageLocation], [StorageMode], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabaseCube]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseDeleteByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseDeleteByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseDeleteByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[AnalysisDatabase]
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseInactivateByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseInactivateByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseInactivateByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[AnalysisDatabase]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabase]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseSelectByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseSelectByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseSelectByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisDatabase] 
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisDatabaseUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisDatabaseUpsert
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisDatabaseUpsert] 
    @AnalysisInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @Description nvarchar(1024) = NULL,
    @UpdateAbility nvarchar(128),
    @EstimatedSize bigint,
    @CreateDate datetime2(3),
    @LastProcessedDate datetime2(3) = NULL,
    @LastSchemaUpdate datetime2(3) = NULL,
    @Collation nvarchar(128),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[AnalysisDatabase] AS target
	USING (SELECT @Description, @UpdateAbility, @EstimatedSize, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([AnalysisInstanceGUID] = @AnalysisInstanceGUID AND [DatabaseName] = @DatabaseName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [UpdateAbility] = @UpdateAbility, [EstimatedSize] = @EstimatedSize, [CreateDate] = @CreateDate, [LastProcessedDate] = @LastProcessedDate, [LastSchemaUpdate] = @LastSchemaUpdate, [Collation] = @Collation, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@AnalysisInstanceGUID, @DatabaseName, @Description, @UpdateAbility, @EstimatedSize, @CreateDate, @LastProcessedDate, @LastSchemaUpdate, @Collation, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [DatabaseName], [Description], [UpdateAbility], [EstimatedSize], [CreateDate], [LastProcessedDate], [LastSchemaUpdate], [Collation], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisDatabase]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstanceDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstanceDeleteByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceDeleteByComputer]  
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[AnalysisInstance]
	WHERE  ([ComputerGUID] = @ComputerGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstanceInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstanceInactivate
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceInactivate]  
    @AnalysisInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[AnalysisInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate, ServiceState = N'Removed'
	WHERE  ([objectGUID] = @AnalysisInstanceGUID)

	IF @IncludeChildObjects = 1
	BEGIN

		UPDATE [cm].[AnalysisDatabase]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID)

		UPDATE [cm].[AnalysisDatabaseCube]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID)

		UPDATE [cm].[AnalysisInstanceProperty]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID)

	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstanceInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstanceInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceInactivateByComputer]  
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[AnalysisInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstancePropertyDeleteByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstancePropertyDeleteByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertyDeleteByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[AnalysisInstanceProperty]
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstancePropertyInactivateByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstancePropertyInactivateByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertyInactivateByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[AnalysisInstanceProperty]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstanceProperty]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstancePropertySelectByAnalysisInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstancePropertySelectByAnalysisInstance
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertySelectByAnalysisInstance] 
    @AnalysisInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [AnalysisInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisInstanceProperty] 
	WHERE  ([AnalysisInstanceGUID] = @AnalysisInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstancePropertyUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstancePropertyUpsert
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertyUpsert] 
    @AnalysisInstanceGUID uniqueidentifier,
	@Name nvarchar(128),
    @PropertyName nvarchar(128),
	@Category nvarchar(128),
    @PropertyValue nvarchar(128),
	@Type nvarchar(32),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[AnalysisInstanceProperty] AS target
	USING (SELECT @PropertyName, @Category, @PropertyValue, @Type, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([PropertyName], [Category], [PropertyValue], [Type], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([AnalysisInstanceGUID] = @AnalysisInstanceGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [PropertyName] = @PropertyName, [Category] = @Category, [PropertyValue] = @PropertyValue, [Type] = @Type, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([AnalysisInstanceGUID], [Name], [PropertyName], [Category], [PropertyValue], [Type], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@AnalysisInstanceGUID, @Name, @PropertyName, @Category, @PropertyValue, @Type, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [Name], [PropertyName], [Category], [PropertyValue], [Type], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstanceProperty]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstanceSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstanceSelectByComputer
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceSelectByComputer]  
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisInstance] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstanceSelectByServiceState]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstanceSelectByServiceState
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceSelectByServiceState] 
    @ServiceState nvarchar(128),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[AnalysisInstance] 
	WHERE  ([ServiceState] = @ServiceState AND [Active] >= @Active)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spAnalysisInstanceUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spAnalysisInstanceUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceUpsert]  
    @dnsHostName nvarchar(255),
    @InstanceName nvarchar(128),
    @ProductName nvarchar(128),
    @ProductEdition nvarchar(128),
    @ProductVersion nvarchar(128),
    @ProductServicePack nvarchar(128),
    @ConnectionString nvarchar(255) = NULL,
	@ServiceState nvarchar(128),
    @IsClustered bit,
    @ActiveNode nvarchar(255),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[AnalysisInstance] AS target
	USING (SELECT @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @IsClustered, @ActiveNode, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [InstanceName] = @InstanceName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ProductName] = @ProductName, [ProductEdition] = @ProductEdition, [ProductVersion] = @ProductVersion, [ProductServicePack] = @ProductServicePack, [ServiceState] = @ServiceState, [IsClustered] = @IsClustered, [ActiveNode] = @ActiveNode, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @InstanceName, @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @IsClustered, @ActiveNode, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstance]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationDelete
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationDelete] 
    @Name nvarchar(255),
    @Version nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Application]
	WHERE  [Name] = @Name and [Version] = @Version

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationInactivate
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInactivate] 
    @Name nvarchar(255),
    @Version nvarchar(128),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[Application]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @Name and [Version] = @Version
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Application]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationInstallationDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationInstallationDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationDeleteByComputer] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ApplicationInstallation]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationInstallationInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationInstallationInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[ApplicationInstallation]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE   ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ApplicationInstallation]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationInstallationSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationInstallationSelectByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ApplicationInstallation] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationInstallationUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationInstallationUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationUpsert] 
    @dnsHostName nvarchar(255),
	@Name nvarchar(255),
	@Version nvarchar(128),
	@Vendor nvarchar(128),
	@InstallDate datetime2(0) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ApplicationGUID uniqueidentifier
	SELECT @ApplicationGUID = objectGUID
	FROM [cm].[Application]
	WHERE [Name] = @Name AND [Version] = @Version

	BEGIN TRAN

	IF @ApplicationGUID is null
	BEGIN
		EXEC cm.spApplicationUpsert @Name = @Name, @Version = @Version, @Vendor = @Vendor, @Active = 1, @dbLastUpdate = @dbLastUpdate
		SELECT @ApplicationGUID = objectGUID
		FROM [cm].[Application]
		WHERE [Name] = @Name AND [Version] = @Version		
	END

	COMMIT

	BEGIN TRAN

	MERGE [cm].[ApplicationInstallation] AS target
	USING (SELECT @InstallDate, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([InstallDate], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ApplicationGUID] = @ApplicationGUID and [ComputerGUID] = @ComputerGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [InstallDate] = @InstallDate, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [ApplicationGUID], [InstallDate], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @ApplicationGUID, @InstallDate, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ApplicationInstallation]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationSelect
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationSelect] 
    @Name nvarchar(255),
    @Version nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Application] 
	WHERE  [Name] = @Name and [Version] = @Version

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spApplicationUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spApplicationUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationUpsert] 
    @Name nvarchar(255),
    @Version nvarchar(128) = NULL,
    @Vendor nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Application] AS target
	USING (SELECT @Vendor, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Vendor], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name and [Version] = @Version)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Vendor] = @Vendor, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @Version, @Vendor, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Application]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterDeleteByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterDeleteByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterDeleteByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Cluster]
	WHERE  ([ClusterName] = @ClusterName)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterGroupDeleteByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterGroupDeleteByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterGroupDeleteByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	DELETE
	FROM   [cm].[ClusterGroup]
	WHERE  ([ClusterGUID] = @ClusterGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterGroupInactivateByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterGroupInactivateByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterGroupInactivateByClusterName] 
    @ClusterName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName
	
	UPDATE [cm].[ClusterGroup]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ClusterGUID] = @ClusterGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ClusterGroupGUID], [GroupName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterGroup]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterGroupSelectByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterGroupSelectByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterGroupSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	SELECT [objectGUID], [ClusterGUID], [GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ClusterGroup] 
	WHERE  ([ClusterGUID] = @ClusterGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterGroupUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterGroupUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterGroupUpsert] 
    @objectGUID uniqueidentifier,
    @ClusterName nvarchar(255),
    @GroupName nvarchar(255),
    @Description nvarchar(1024) = NULL,
    @OwnerNode nvarchar(255),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	MERGE [cm].[ClusterGroup] AS target
	USING (SELECT @GroupName, @Description, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterGUID] = @ClusterGUID AND [objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [GroupName] = @GroupName, [Description] = @Description, [OwnerNode] = @OwnerNode, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [ClusterGUID], [GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @ClusterGUID, @GroupName, @Description, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ClusterGroupGUID], [GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterGroup]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterInactivateByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterInactivateByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterInactivateByClusterName] 
    @ClusterName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[Cluster]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ClusterName] = @ClusterName)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Cluster]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterNodeDeleteByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterNodeDeleteByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeDeleteByClusterName]
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	DELETE
	FROM   [cm].[ClusterNode]
	WHERE  ([ClusterGUID] = @ClusterGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterNodeInactivateByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterNodeInactivateByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeInactivateByClusterName] 
    @ClusterName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName
	
	UPDATE [cm].[ClusterNode]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ClusterGUID] = @ClusterGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ComputerGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterNode]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterNodeSelectByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterNodeSelectByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	SELECT [objectGUID], [ClusterGUID], [ComputerGUID], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ClusterNode] 
	WHERE  ([ClusterGUID] = @ClusterGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterNodeUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterNodeUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeUpsert] 
    @ClusterName nvarchar(255),
    @NodeName nvarchar(255),
	@State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @NodeName

	MERGE [cm].[ClusterNode] AS target
	USING (SELECT @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterGUID] = @ClusterGUID AND [ComputerGUID] = @ComputerGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ClusterGUID] = @ClusterGUID, [ComputerGUID] = @ComputerGUID, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ClusterGUID], [ComputerGUID], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ClusterGUID, @ComputerGUID, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ComputerGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterNode]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterResourceDeleteByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterResourceDeleteByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterResourceDeleteByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	DELETE
	FROM   [cm].[ClusterResource]
	WHERE ([ClusterGUID] = @ClusterGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterResourceInactivateByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterResourceInactivateByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterResourceInactivateByClusterName]
    @ClusterName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName
	
	UPDATE [cm].[ClusterResource]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([ClusterGUID] = @ClusterGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ResourceGUID], [ResourceName], [ResourceType], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterResource]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterResourceSelectByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterResourceSelectByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterResourceSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	SELECT [objectGUID], [ClusterGUID], [ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ClusterResource] 
	WHERE  ([ClusterGUID] = @ClusterGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterResourceUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterResourceUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterResourceUpsert] 
	@objectGUID uniqueidentifier,
    @ClusterName nvarchar(255),
    @ResourceName nvarchar(255),
    @ResourceType nvarchar(255),
    @OwnerGroup nvarchar(255),
	@OwnerNode nvarchar(255),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	MERGE [cm].[ClusterResource] AS target
	USING (SELECT @ResourceName, @ResourceType, @OwnerGroup, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterGUID] = @ClusterGUID AND [objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ResourceName] = @ResourceName, [ResourceType] = @ResourceType, [OwnerGroup] = @OwnerGroup, [OwnerNode] = @OwnerNode, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [ClusterGUID], [ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @ClusterGUID, @ResourceName, @ResourceType, @OwnerGroup, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterResource]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterSelectByClusterName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterSelectByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Cluster] 
	WHERE  ([ClusterName] = @ClusterName) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spClusterUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spClusterUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterUpsert] 
    @ClusterName nvarchar(255),
    @OperatingSystem nvarchar(255) = NULL,
    @OperatingSystemVersion nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Cluster] AS target
	USING (SELECT @OperatingSystem, @OperatingSystemVersion, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterName] = @ClusterName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [OperatingSystem] = @OperatingSystem, [OperatingSystemVersion] = @OperatingSystemVersion, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ClusterName, @OperatingSystem, @OperatingSystemVersion, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Cluster]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerDelete] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerGroupMemberDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerGroupMemberDelete
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerGroupMemberDelete] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[ComputerGroupMember]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerGroupMemberInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerGroupMemberInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerGroupMemberInactivateByComputer] 
    @dnsHostName nvarchar(255),
	@GroupName nvarchar(255),
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[ComputerGroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID AND [GroupName] = @GroupName) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerGroupMember]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerGroupMemberSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerGroupMemberSelectByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerGroupMemberSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ComputerGroupMember] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerGroupMemberUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerGroupMemberUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerGroupMemberUpsert] 
    @dnsHostName nvarchar(255),
    @GroupName nvarchar(128),
    @MemberName nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[ComputerGroupMember] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [GroupName] = @GroupName AND [MemberName] = @MemberName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @GroupName, @MemberName, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerGroupMember]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerInactivate] 
    @dnsHostName nvarchar(255),
	@IncludeChildObject bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] WHERE [dnsHostName] = @dnsHostName

	UPDATE [cm].[Computer]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @ComputerGUID

	IF @IncludeChildObject = 1
	BEGIN

		UPDATE [cm].[Service]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[ApplicationInstallation]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[DiskDrive]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[LogicalVolume]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[DrivePartitionMap]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[NetworkAdapter]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[NetworkAdapterConfiguration]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[DrivePartitionMap]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[WindowsUpdateInstallation]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[OperatingSystem]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [computerGUID] = @ComputerGUID

		UPDATE [cm].[ClusterNode]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

		UPDATE [cm].[ComputerShare]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

			UPDATE [cm].[ComputerSharePermission]
			SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
			WHERE [ComputerShareGUID] IN (SELECT [ComputerShareGUID] FROM [cm].[ComputerShare] WHERE [ComputerGUID] = @ComputerGUID)

		UPDATE [cm].[ComputerGroupMember]
		SET [Active] = 0, [dbLastUpdate] = @dbLastUpdate
		WHERE [ComputerGUID] = @ComputerGUID

	END

	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [InstallDate], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSelect] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [SystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [IsClusterResource], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Computer] 
	WHERE  ([dnsHostName] = @dnsHostName) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerShareDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spComputerShareDeleteByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerShareDeleteByComputer]  
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[ComputerShare]
	WHERE  ([ComputerGUID] = @ComputerGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerShareInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerShareInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerShareInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerShareInactivateByComputer]  
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[ComputerShare]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerShare]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionDeleteByShare]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionDeleteByShare]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerSharePermissionDeleteByShare
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSharePermissionDeleteByShare] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ComputerShareGUID uniqueidentifier
	SELECT @ComputerShareGUID = [objectGUID]
	FROM [cm].[ComputerShare]
	WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @ShareName

	DELETE
	FROM   [cm].[ComputerSharePermission]
	WHERE  [ComputerShareGUID] = @computerShareGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionInactivateByShare]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionInactivateByShare]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerSharePermissionInactivateByShare
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSharePermissionInactivateByShare] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ComputerShareGUID uniqueidentifier
	SELECT @ComputerShareGUID = [objectGUID]
	FROM [cm].[ComputerShare]
	WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @ShareName
	
	UPDATE [cm].[ComputerSharePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerShareGUID] = @computerShareGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerSharePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionSelectByShare]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionSelectByShare]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spComputerSharePermissionSelectByShare] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ComputerShareGUID uniqueidentifier
	SELECT @ComputerShareGUID = [objectGUID]
	FROM [cm].[ComputerShare]
	WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @ShareName

	SELECT [objectGUID], [ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ComputerSharePermission] 
	WHERE  ([ComputerShareGUID] = @computerShareGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerSharePermissionUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerSharePermissionUpsert
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSharePermissionUpsert] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255),
    @SecurityPrincipal nvarchar(128),
    @FileSystemRights nvarchar(128),
    @AccessControlType nvarchar(128),
    @IsInherited bit,
    @InheritanceFlags nvarchar(128),
    @PropagationFlags nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @ComputerShareGUID uniqueidentifier
	SELECT @ComputerShareGUID = [objectGUID]
	FROM [cm].[ComputerShare]
	WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @ShareName

	MERGE [cm].[ComputerSharePermission] AS target
	USING (SELECT @FileSystemRights, @IsInherited, @InheritanceFlags, @PropagationFlags, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([FileSystemRights], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerShareGUID] = @ComputerShareGUID AND [SecurityPrincipal] = @SecurityPrincipal AND [AccessControlType] = @AccessControlType)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [FileSystemRights] = @FileSystemRights, [IsInherited] = @IsInherited, [InheritanceFlags] = @InheritanceFlags, [PropagationFlags] = @PropagationFlags, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerShareGUID, @SecurityPrincipal, @FileSystemRights, @AccessControlType, @IsInherited, @InheritanceFlags, @PropagationFlags, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerSharePermission]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerShareSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerShareSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spComputerShareSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ComputerShare] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerShareUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerShareUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerShareUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerShareUpsert]  
    @dnsHostName nvarchar(255),
    @Name nvarchar(128),
    @Description nvarchar(128),
    @Path nvarchar(2048),
    @Status nvarchar(128) = NULL,
    @Type nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[ComputerShare] AS target
	USING (SELECT @Description, @Path, @Status, @Type, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [Path] = @Path, [Status] = @Status, [Type] = @Type, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @Description, @Path, @Status, @Type, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerShare]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerUpsert] 
    @Domain nvarchar(128),
    @dnsHostName nvarchar(255),
    @netBIOSName nvarchar(255),
    @IPv4Address nvarchar(128) = NULL,
    @DomainRole nvarchar(128) = NULL,
    @CurrentTimeZone int = NULL,
    @DaylightInEffect bit = NULL,
    @Status nvarchar(50) = NULL,
    @Manufacturer nvarchar(128) = NULL,
    @Model nvarchar(128) = NULL,
	@PCSystemType nvarchar(128) = NULL,
	@SystemType nvarchar(128) = NULL,
    @AssetTag nvarchar(128) = NULL,
    @SerialNumber nvarchar(128) = NULL,
    @TotalPhysicalMemory bigint = NULL,
    @NumberOfLogicalProcessors int = NULL,
    @NumberOfProcessors int = NULL,
    @IsVirtual bit,
    @PendingReboot bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Computer] AS target
	USING (SELECT @Domain, @netBIOSName, @IPv4Address, @DomainRole, @CurrentTimeZone, @DaylightInEffect, @Status, @Manufacturer, @Model, @PCSystemType, @SystemType, @AssetTag, @SerialNumber, @TotalPhysicalMemory, @NumberOfLogicalProcessors, @NumberOfProcessors, @IsVirtual, @PendingReboot, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [SystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [PendingReboot], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([dnsHostName] = @dnsHostName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [netBIOSName] = @netBIOSName, [IPv4Address] = @IPv4Address, [DomainRole] = @DomainRole, [CurrentTimeZone] = @CurrentTimeZone, [DaylightInEffect] = @DaylightInEffect, [Status] = @Status, [Manufacturer] = @Manufacturer, [Model] = @Model, [PCSystemType] = @PCSystemType, [SystemType] = @SystemType, [AssetTag] = @AssetTag, [SerialNumber] = @SerialNumber, [TotalPhysicalMemory] = @TotalPhysicalMemory, [NumberOfLogicalProcessors] = @NumberOfLogicalProcessors, [NumberOfProcessors] = @NumberOfProcessors, [IsVirtual] = @IsVirtual, [PendingReboot] = @PendingReboot, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [SystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [PendingReboot], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @dnsHostName, @netBIOSName, @IPv4Address, @DomainRole, @CurrentTimeZone, @DaylightInEffect, @Status, @Manufacturer, @Model, @PCSystemType, @SystemType, @AssetTag, @SerialNumber, @TotalPhysicalMemory, @NumberOfLogicalProcessors, @NumberOfProcessors, @IsVirtual, @PendingReboot, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spComputerUpsertForCluster]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spComputerUpsertForCluster]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spComputerUpsertForCluster
* Author: huscott
* Date: 2015-02-24
*
* Description:
* cm.Computer is the pk table for many objects such as SQL
* instances.  An entry is needed in the table for virtual network
* names that represent these objects.
*
****************************************************************/
CREATE PROC [cm].[spComputerUpsertForCluster] 
    @Domain nvarchar(128),
    @dnsHostName nvarchar(255),
    @netBIOSName nvarchar(255),
	@IsClusterResource bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Computer] AS target
	USING (SELECT @Domain, @netBIOSName, @IsClusterResource, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [netBIOSName], [IsClusterResource], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([dnsHostName] = @dnsHostName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [netBIOSName] = @netBIOSName, [IsVirtual] = 0, [IsClusterResource] = @IsClusterResource, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [dnsHostName], [netBIOSName], [IsVirtual], [IsClusterResource], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @dnsHostName, @netBIOSName, 0, @IsClusterResource, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseDeleteByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Database]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileDeleteByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileDeleteByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseFileDeleteByDatabase
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseFileDeleteByDatabase] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseFile]
	WHERE  ([DatabaseGUID] = @DatabaseGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileInactivateByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileInactivateByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseFileInactivate
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseFileInactivateByDatabase] 
    @DatabaseGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseFile]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([DatabaseGUID] = @DatabaseGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseFile]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseFileSelect] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseFile] 
	WHERE  ([databaseGUID] = @DatabaseGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseFileUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseFileUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseFileUpsert] 
    @DatabaseGUID uniqueidentifier,
    @FileID int,
    @FileGroup nvarchar(255),
    @LogicalName nvarchar(255),
    @PhysicalName nvarchar(2048),
    @FileSize bigint,
    @MaxSize bigint,
    @SpaceUsed bigint,
    @Growth bigint,
    @GrowthType nvarchar(128),
    @IsReadOnly bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseFile] AS target
	USING (SELECT  @FileGroup, @LogicalName, @PhysicalName, @FileSize, @MaxSize, @SpaceUsed, @Growth, @GrowthType, @IsReadOnly, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		( [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseGUID] = @DatabaseGUID AND [FileID] = @FileID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [FileGroup] = @FileGroup, [LogicalName] = @LogicalName, [PhysicalName] = @PhysicalName, [FileSize] = @FileSize, [MaxSize] = @MaxSize, [SpaceUsed] = @SpaceUsed, [Growth] = @Growth, [GrowthType] = @GrowthType, [IsReadOnly] = @IsReadOnly, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseGUID, @FileID, @FileGroup, @LogicalName, @PhysicalName, @FileSize, @MaxSize, @SpaceUsed, @Growth, @GrowthType, @IsReadOnly, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseFile]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[Database]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	IF @IncludeChildObjects = 1
	BEGIN
		UPDATE [cm].[DatabaseFile]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @DatabaseInstanceGUID) )

		UPDATE [cm].[DatabaseProperty]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @DatabaseInstanceGUID) )
	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Database]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceDelete
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[DatabaseInstance]
	WHERE ([ComputerGUID] = @ComputerGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceInactivate
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceInactivate] 
    @DatabaseInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseInstance]
	SET [Active] = 0, ServiceState = N'Removed', dbLastUpdate = @dbLastUpdate
	WHERE ([objectGUID] = @DatabaseInstanceGUID) 

	IF @IncludeChildObjects = 1
	BEGIN

		UPDATE [cm].[Database]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

			UPDATE [cm].[DatabaseFile]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @DatabaseInstanceGUID) )

			UPDATE [cm].[DatabaseUser]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseInstanceGUID] = @databaseInstanceGUID)

			UPDATE [cm].[DatabaseRoleMember]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseInstanceGUID] = @databaseInstanceGUID) 

			UPDATE [cm].[DatabaseProperty]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseGUID] IN (SELECT [objectGUID] FROM [cm].[Database] WHERE [DatabaseInstanceGUID] = @DatabaseInstanceGUID) )

		UPDATE [cm].[DatabaseInstanceProperty]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

		UPDATE [cm].[DatabaseInstanceLogin]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

		UPDATE [cm].[Job]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

		UPDATE [cm].[LinkedServer]
		SET [Active] = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

			UPDATE [cm].[LinkedServerLogin]
			SET [Active] = 0, dbLastUpdate = @dbLastUpdate
			WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Database]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[DatabaseInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginDeleteByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceLoginDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceLoginDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseInstanceLogin]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceLoginInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceLoginInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseInstanceLogin]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceLogin]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginSelectByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseInstanceLoginSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseInstanceLogin] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceLoginUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceLoginUpsert
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceLoginUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @Name nvarchar(255),
    @Sid nvarchar(255),
    @LoginType nvarchar(128),
    @DefaultDatabase nvarchar(255),
    @HasAccess bit,
    @IsDisabled bit = null,
    @IsLocked bit = null,
    @IsPasswordExpired bit = null,
    @PasswordExpirationEnabled bit = null,
	@PasswordPolicyEnforced bit = null,
    @IsSysAdmin bit,
    @IsSecurityAdmin bit,
    @IsSetupAdmin bit,
    @IsProcessAdmin bit,
    @IsDiskAdmin bit,
    @IsDBCreator bit,
    @IsBulkAdmin bit,
    @CreateDate datetime2(3),
	@DateLastModified datetime2(3),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseInstanceLogin] AS target
	USING (SELECT @Sid, @LoginType, @DefaultDatabase, @HasAccess, @IsDisabled, @IsLocked, @IsPasswordExpired, @PasswordExpirationEnabled, @PasswordPolicyEnforced, @IsSysAdmin, @IsSecurityAdmin, @IsSetupAdmin, @IsProcessAdmin, @IsDiskAdmin, @IsDBCreator, @IsBulkAdmin, @CreateDate, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Sid] = @Sid, [LoginType] = @LoginType, [DefaultDatabase] = @DefaultDatabase, [HasAccess] = @HasAccess, [IsDisabled] = @IsDisabled, [IsLocked] = @IsLocked, [IsPasswordExpired] = @IsPasswordExpired, [PasswordExpirationEnabled] = @PasswordExpirationEnabled, [PasswordPolicyEnforced] = @PasswordPolicyEnforced, [IsSysAdmin] = @IsSysAdmin, [IsSecurityAdmin] = @IsSecurityAdmin, [IsSetupAdmin] = @IsSetupAdmin, [IsProcessAdmin] = @IsProcessAdmin, [IsDiskAdmin] = @IsDiskAdmin, [IsDBCreator] = @IsDBCreator, [IsBulkAdmin] = @IsBulkAdmin, [CreateDate] = @CreateDate, [State] = @State, [DateLastModified] = @DateLastModified, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @Name, @Sid, @LoginType, @DefaultDatabase, @HasAccess, @IsDisabled, @IsLocked, @IsPasswordExpired, @PasswordExpirationEnabled, @PasswordPolicyEnforced, @IsSysAdmin, @IsSecurityAdmin, @IsSetupAdmin, @IsProcessAdmin, @IsDiskAdmin, @IsDBCreator, @IsBulkAdmin, @CreateDate, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceLogin]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePermissionInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePermissionInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstancePermissionInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePermissionInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabasePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [PermissionSource] = 'SERVER_PERMISSION') 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyDeleteByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstancePropertyDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePropertyDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseInstanceProperty]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstancePropertyInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePropertyInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseInstanceProperty]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceProperty]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertySelectByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertySelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseInstancePropertySelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseInstanceProperty] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstancePropertyUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePropertyUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @PropertyName nvarchar(128),
    @PropertyValue nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseInstanceProperty] AS target
	USING (SELECT  @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [PropertyName] = @PropertyName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [PropertyValue] = @PropertyValue, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @PropertyName, @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceProperty]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseInstanceSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseInstance] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceSelectByServiceState]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceSelectByServiceState]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spDatabaseInstanceSelectByServiceState] 
    @ServiceState nvarchar(128),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseInstance] 
	WHERE  ([ServiceState] = @ServiceState AND [Active] >= @Active ) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseInstanceUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceUpsert] 
    @dnsHostName nvarchar(255),
    @InstanceName nvarchar(128),
    @ProductName nvarchar(128),
    @ProductEdition nvarchar(128),
    @ProductVersion nvarchar(128),
    @ProductServicePack nvarchar(128),
	@ConnectionString nvarchar(255),
	@ServiceState nvarchar(128),
    @IsClustered bit,
    @ActiveNode nvarchar(255),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[DatabaseInstance] AS target
	USING (SELECT @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @IsClustered, @ActiveNode, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [InstanceName] = @InstanceName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ProductName] = @ProductName, [ProductEdition] = @ProductEdition, [ProductVersion] = @ProductVersion, [ProductServicePack] = @ProductServicePack, [ServiceState] = @ServiceState, [IsClustered] = @IsClustered, [ActiveNode] = @ActiveNode, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @InstanceName, @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @IsClustered, @ActiveNode, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstance]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionDeleteByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionDeleteByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePermissionDeleteByDatabase
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionDeleteByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabasePermission]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionInactivateByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionInactivateByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePermissionInactivateByDatabase
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionInactivateByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabasePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND [PermissionSource] = N'DATABASE_PERMISSION') 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePermissionInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabasePermission]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [PermissionSource] IN (N'DATABASE_PERMISSION', N'SERVER_PERMISSION') )
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionSelectByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionSelectByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabasePermissionSelectByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabasePermission] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePermissionUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePermissionUpsert
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePermissionUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @PermissionSource nvarchar(32),
    @PermissionState nvarchar(128),
    @PermissionType nvarchar(128),
    @Grantor nvarchar(128),
    @ObjectName nvarchar(128),
    @Grantee nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabasePermission] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID]=@DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND PermissionSource=@PermissionSource AND [PermissionState]=@PermissionState AND [PermissionType]=@PermissionType AND [Grantor]=@Grantor AND [ObjectName] = @ObjectName AND [Grantee]=@Grantee)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @DatabaseName, @PermissionSource, @PermissionState, @PermissionType, @Grantor, @ObjectName, @Grantee, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [PermissionSource], [PermissionState], [PermissionType], [Grantor], [ObjectName], [Grantee], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabasePermission]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertyDeleteByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertyDeleteByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePropertyDeleteByDatabase
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePropertyDeleteByDatabase] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseProperty]
	WHERE  [DatabaseGUID] = @DatabaseGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertyInactivateByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertyInactivateByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePropertyInactivateByDatabase
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePropertyInactivateByDatabase] 
    @DatabaseGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseProperty]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [DatabaseGUID] = @DatabaseGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseProperty]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertySelectByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertySelectByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabasePropertySelectByDatabase] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseProperty] 
	WHERE  ([DatabaseGUID] = @DatabaseGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertyUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabasePropertyUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabasePropertyUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePropertyUpsert] 
    @DatabaseGUID uniqueidentifier,
    @PropertyName nvarchar(128),
    @PropertyValue nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseProperty] AS target
	USING (SELECT @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseGUID]=@DatabaseGUID AND [PropertyName]=@PropertyName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [PropertyValue] = @PropertyValue, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseGUID, @PropertyName, @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseProperty]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberDeleteByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberDeleteByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseRoleMemberDeleteByDatabase
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberDeleteByDatabase]  
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseRoleMember]
	WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberInactivateByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberInactivateByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseRoleMemberInactivateByDatabase
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberInactivateByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @dbLastUpdate datetime2(3)

AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseRoleMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseRoleMember]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spDatabaseRoleMemberInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)

AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseRoleMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseRoleMember]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberSelectByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberSelectByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseRoleMemberSelectByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseRoleMember] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseRoleMemberUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseRoleMemberUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @RoleName nvarchar(128),
    @RoleMember nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseRoleMember] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND [RoleName] = @RoleName AND [RoleMember] = @RoleMember)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ( [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate])
		VALUES ( @DatabaseInstanceGUID, @DatabaseName, @RoleName, @RoleMember, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseRoleMember]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseSelectByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Database] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseSizeUpdate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseSizeUpdate]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseSizeUpdate]
	@DatabaseGUID uniqueidentifier,
	@DataFileSize bigint,
	@DataFileSpaceUsed bigint,
	@LogFileSize bigint,
	@LogFileSpaceUsed bigint,
	@VirtualLogFileCount int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE [cm].[Database]
SET [DataFileSize] = @DataFileSize, 
	[DataFileSpaceUsed] = @DataFileSpaceUsed,
	[LogFileSize] = @LogFileSize,
	[LogFileSpaceUsed] = @LogFileSpaceUsed,
	[VirtualLogFileCount] = @VirtualLogFileCount
WHERE [objectGUID] = @DatabaseGUID

COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @DatabaseID int,
    @RecoveryModel nvarchar(128),
    @Status nvarchar(128),
    @ReadOnly bit,
    @UserAccess nvarchar(128),
    @CreateDate datetime2(3),
    @Owner nvarchar(128),
    @LastFullBackup datetime2(3),
    @LastDiffBackup datetime2(3),
    @LastLogBackup datetime2(3),
    @CompatibilityLevel nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Database] AS target
	USING (SELECT @DatabaseID, @RecoveryModel, @Status, @ReadOnly, @UserAccess, @CreateDate, @Owner, @LastFullBackup, @LastDiffBackup, @LastLogBackup, @CompatibilityLevel, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DatabaseID] = @DatabaseID, [RecoveryModel] = @RecoveryModel, [Status] = @Status, [ReadOnly] = @ReadOnly, [UserAccess] = @UserAccess, [CreateDate] = @CreateDate, [Owner] = @Owner, [LastFullBackup] = @LastFullBackup, [LastDiffBackup] = @LastDiffBackup, [LastLogBackup] = @LastLogBackup, [CompatibilityLevel] = @CompatibilityLevel, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @DatabaseName, @DatabaseID, @RecoveryModel, @Status, @ReadOnly, @UserAccess, @CreateDate, @Owner, @LastFullBackup, @LastDiffBackup, @LastLogBackup, @CompatibilityLevel, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [DatabaseID], [RecoveryModel], [Status], [ReadOnly], [UserAccess], [CreateDate], [Owner], [LastFullBackup], [LastDiffBackup], [LastLogBackup], [CompatibilityLevel], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Database]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserDeleteByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUserDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseUser]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserInactivateByDatabase]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserInactivateByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUserInactivateByDatabase
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserInactivateByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseUser]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseUser]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUserInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseUser]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseUser]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserSelectByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabaseUserSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseUser] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDatabaseUserUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUserUpsert
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
	@DatabaseName nvarchar(128),
    @UserName nvarchar(128),
    @Login nvarchar(128),
    @UserType nvarchar(128),
    @LoginType nvarchar(128),
    @HasDBAccess bit,
    @CreateDate datetime2(3),
	@DateLastModified datetime2(3),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseUser] AS target
	USING (SELECT @Login, @UserType, @LoginType, @HasDBAccess, @CreateDate, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName AND [UserName] = @UserName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Login] = @Login, [UserType] = @UserType, [LoginType] = @LoginType, [HasDBAccess] = @HasDBAccess, [CreateDate] = @CreateDate, [DateLastModified] = @DateLastModified, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [DatabaseName], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @DatabaseName, @UserName, @Login, @UserType, @LoginType, @HasDBAccess, @CreateDate, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseUser]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskDriveDelete
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskDriveDeleteByComputer] 
    @dnsHostName nvarchar(255) 
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[DiskDrive]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskDriveInactivate
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskDriveInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[DiskDrive]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @ComputerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskDrive]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDiskDriveSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Status], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DiskDrive] 
	WHERE  ([ComputerGUID] = @computerGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskDriveUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskDriveUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskDriveUpsert] 
	@dnsHostName nvarchar(255),
    @Name nvarchar(128),
    @DeviceID nvarchar(128),
    @Manufacturer nvarchar(255) = NULL,
    @Model nvarchar(255) = NULL,
    @SerialNumber nvarchar(128) = NULL,
    @FirmwareRevision nvarchar(128) = NULL,
    @Partitions int = NULL,
    @InterfaceType nvarchar(128),
    @SCSIBus int = NULL,
    @SCSIPort int = NULL,
    @SCSILogicalUnit int = NULL,
    @SCSITargetID int = NULL,
	@Size bigint,
    @Status nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[DiskDrive] AS target
	USING (SELECT @DeviceID, @Manufacturer, @Model, @SerialNumber, @FirmwareRevision, @Partitions, @InterfaceType, @SCSIBus, @SCSIPort, @SCSILogicalUnit, @SCSITargetID, @Size, @Status, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Size], [Status], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DeviceID] = @DeviceID, [Manufacturer] = @Manufacturer, [Model] = @Model, [SerialNumber] = @SerialNumber, [FirmwareRevision] = @FirmwareRevision, [Partitions] = @Partitions, [InterfaceType] = @InterfaceType, [SCSIBus] = @SCSIBus, [SCSIPort] = @SCSIPort, [SCSILogicalUnit] = @SCSILogicalUnit, [SCSITargetID] = @SCSITargetID, [Size] = @Size, [Status] = @Status, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Size], [Status], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @DeviceID, @Manufacturer, @Model, @SerialNumber, @FirmwareRevision, @Partitions, @InterfaceType, @SCSIBus, @SCSIPort, @SCSILogicalUnit, @SCSITargetID, @Size, @Status, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DeviceID], [Manufacturer], [Model], [SerialNumber], [FirmwareRevision], [Partitions], [InterfaceType], [SCSIBus], [SCSIPort], [SCSILogicalUnit], [SCSITargetID], [Size], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskDrive]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskPartitionDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskPartitionDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[DiskPartition]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskPartitionInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskPartitionInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[DiskPartition]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskPartition]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDiskPartitionSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DiskPartition] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDiskPartitionUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskPartitionUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskPartitionUpsert] 
    @dnsHostName nvarchar(255),
    @Name nvarchar(255),
    @DiskIndex int,
    @Index int,
    @DeviceID nvarchar(255),
    @Bootable bit,
    @BootPartition bit,
    @PrimaryPartition bit,
    @StartingOffset bigint = NULL,
    @Size bigint,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[DiskPartition] AS target
	USING (SELECT @DiskIndex, @Index, @DeviceID, @Bootable, @BootPartition, @PrimaryPartition, @StartingOffset, @Size, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DiskIndex] = @DiskIndex, [Index] = @Index, [DeviceID] = @DeviceID, [Bootable] = @Bootable, [BootPartition] = @BootPartition, [PrimaryPartition] = @PrimaryPartition, [StartingOffset] = @StartingOffset, [Size] = @Size, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate])		
		VALUES (@ComputerGUID, @Name, @DiskIndex, @Index, @DeviceID, @Bootable, @BootPartition, @PrimaryPartition, @StartingOffset, @Size, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DiskIndex], [Index], [DeviceID], [Bootable], [BootPartition], [PrimaryPartition], [StartingOffset], [Size], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DiskPartition]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDrivePartitionMapDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDrivePartitionMapDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[DrivePartitionMap]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDrivePartitionMapInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDrivePartitionMapInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[DrivePartitionMap]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @ComputerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ObjectGUID], [ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DrivePartitionMap]
	WHERE  [ObjectGUID] = @ObjectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDrivePartitionMapSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [ObjectGUID], [ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DrivePartitionMap] 
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spDrivePartitionMapUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDrivePartitionMapUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDrivePartitionMapUpsert] 
    @dnsHostName nvarchar(255),
    @PartitionName nvarchar(128),
    @DriveName nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[DrivePartitionMap] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [PartitionName] = @PartitionName AND [DriveName] = @DriveName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @PartitionName, @DriveName, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ObjectGUID], [ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DrivePartitionMap]
	WHERE  [ObjectGUID] = @ObjectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spEventDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spEventDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spEventDelete
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventDelete] 
    @daysRetain int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @CurrentDate datetime2
	SET @CurrentDate = CURRENT_TIMESTAMP

	DELETE
	FROM   [cm].[Event]
	WHERE  [TimeGenerated] < DATEADD(DAY, -@daysRetain, @CurrentDate)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spEventDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spEventDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spEventDeleteByComputer
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[Event]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spEventGetMaxDateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spEventGetMaxDateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spEventGetMaxDateByComputer
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventGetMaxDateByComputer]
    @dnsHostName nvarchar(255),
	@LogName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName 

	SELECT MAX(TimeGenerated) as MaxTimeGenerated
	FROM [cm].[Event]
	WHERE [ComputerGUID] = @ComputerGUID AND [LogName] = @LogName

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spEventInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spEventInsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spEventInsert
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventInsert] 
    @ComputerGUID uniqueidentifier,
	@LogName nvarchar(255),
    @MachineName nvarchar(255),
    @EventId int,
    @Source nvarchar(255),
    @TimeGenerated datetime2(3),
    @EntryType nvarchar(128),
    @Message nvarchar(max),
    @UserName nvarchar(255) = NULL,
    @dbAddDate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	INSERT INTO [cm].[Event] ([ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate])
	VALUES (@ComputerGUID, @LogName, @MachineName, @EventId, @Source, @TimeGenerated, @EntryType, @Message, @UserName, @dbAddDate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate]
	FROM   [cm].[Event]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spEventSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spEventSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spEventSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [ID], [ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate] 
	FROM   [cm].[Event] 
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spEventSelectByComputerAndLogName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spEventSelectByComputerAndLogName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spEventSelectByComputerAndLogName] 
    @dnsHostName nvarchar(255),
	@LogName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [ID], [ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate] 
	FROM   [cm].[Event] 
	WHERE  [ComputerGUID] = @ComputerGUID AND [LogName] = @LogName

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spJobDeleteByInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spJobDeleteByInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spJobDeleteByInstance
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spJobDeleteByInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Job]
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spJobInactivateByInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spJobInactivateByInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spJobInactivateByInstance
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spJobInactivateByInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[Job]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Job]
	WHERE  [JobID] = @JobID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spJobSelectByInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spJobSelectByInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spJobSelectByInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutcome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Job] 
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spJobUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spJobUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spJobUpsert
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spJobUpsert] 
    @JobID uniqueidentifier,
    @DatabaseInstanceGUID uniqueidentifier,
    @OriginatingServer nvarchar(255),
    @Name nvarchar(255),
    @IsEnabled bit,
    @Description nvarchar(2048),
    @Category nvarchar(255),
    @Owner nvarchar(255),
    @DateCreated datetime2(3) = NULL,
    @DateModified datetime2(3) = NULL,
    @VersionNumber int,
    @LastRunDate datetime2(3) = NULL,
    @NextRunDate datetime2(3) = NULL,
    @CurrentRunStatus nvarchar(128),
	@LastRunOutcome nvarchar(128),
	@HasSchedule bit ,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Job] AS target
	USING (SELECT @OriginatingServer, @Name, @IsEnabled, @Description, @Category, @Owner, @DateCreated, @DateModified, @VersionNumber, @LastRunDate, @NextRunDate, @CurrentRunStatus, @LastRunOutcome, @HasSchedule, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutcome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([JobID] = @JobID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [OriginatingServer] = @OriginatingServer, [Name] = @Name, [IsEnabled] = @IsEnabled, [Description] = @Description, [Category] = @Category, [Owner] = @Owner, [DateCreated] = @DateCreated, [DateModified] = @DateModified, [VersionNumber] = @VersionNumber, [LastRunDate] = @LastRunDate, [NextRunDate] = @NextRunDate, [CurrentRunStatus] = @CurrentRunStatus, [LastRunOutcome] = @LastRunOutcome, [HasSchedule] = @HasSchedule, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutcome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@JobID, @DatabaseInstanceGUID, @OriginatingServer, @Name, @IsEnabled, @Description, @Category, @Owner, @DateCreated, @DateModified, @VersionNumber, @LastRunDate, @NextRunDate, @CurrentRunStatus, @LastRunOutcome, @HasSchedule, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutCome], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Job]
	WHERE  [JobID] = @JobID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerDeleteByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[LinkedServer]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerInactivateByDatabaseInstance]  
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[LinkedServer]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginDeleteByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginDeleteByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerLoginDeleteByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerLoginDeleteByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[LinkedServerLogin]
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginInactivateByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginInactivateByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerLoginInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerLoginInactivateByDatabaseInstance]  
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[LinkedServerLogin]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServerLogin]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginSelectByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spLinkedServerLoginSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[LinkedServerLogin] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerLoginUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerLoginUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerLoginUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @LinkedServerID int,
    @Name nvarchar(255),
    @Impersonate bit,
    @State nvarchar(128),
    @DateLastModified datetime2(3),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[LinkedServerLogin] AS target
	USING (SELECT @Name, @Impersonate, @State, @DateLastModified, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [LinkedServerID] = @LinkedServerID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [Name] = @Name, [Impersonate] = @Impersonate, [State] = @State, [DateLastModified] = @DateLastModified, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @LinkedServerID, @Name, @Impersonate, @State, @DateLastModified, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [LinkedServerID], [Name], [Impersonate], [State], [DateLastModified], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServerLogin]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerSelectByDatabaseInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerSelectByDatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spLinkedServerSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[LinkedServer] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLinkedServerUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLinkedServerUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLinkedServerUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @ID int,
    @Name nvarchar(255),
    @DataSource nvarchar(255),
    @Catalog nvarchar(255) = NULL,
    @ProductName nvarchar(255) = NULL,
    @Provider nvarchar(255) = NULL,
    @ProviderString nvarchar(1024) = NULL,
    @DistPublisher bit,
    @Distributor bit,
    @Publisher bit,
    @Subscriber bit,
    @Rpc bit,
    @RpcOut bit,
    @DataAccess bit,
    @DateLastModified datetime2(3),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[LinkedServer] AS target
	USING (SELECT @Name, @DataSource, @Catalog, @ProductName, @Provider, @ProviderString, @DistPublisher, @Distributor, @Publisher, @Subscriber, @Rpc, @RpcOut, @DataAccess, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [ID] = @ID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Name] = @Name, [DataSource] = @DataSource, [Catalog2] = @Catalog, [ProductName] = @ProductName, [Provider] = @Provider, [ProviderString] = @ProviderString, [DistPublisher] = @DistPublisher, [Distributor] = @Distributor, [Publisher] = @Publisher, [Subscriber] = @Subscriber, [Rpc] = @Rpc, [RpcOut] = @RpcOut, [DataAccess] = @DataAccess, [DateLastModified] = @DateLastModified, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @ID, @Name, @DataSource, @Catalog, @ProductName, @Provider, @ProviderString, @DistPublisher, @Distributor, @Publisher, @Subscriber, @Rpc, @RpcOut, @DataAccess, @DateLastModified, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [ID], [Name], [DataSource], [Catalog2], [ProductName], [Provider], [ProviderString], [DistPublisher], [Distributor], [Publisher], [Subscriber], [Rpc], [RpcOut], [DataAccess], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LinkedServer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLogicalVolumeDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLogicalVolumeDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[LogicalVolume]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLogicalVolumeInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLogicalVolumeInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	UPDATE [cm].[LogicalVolume]
	SET Active = 0, dbLastUpdate = @dbLastUpdate
	WHERE ComputerGUID = @computerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [Capacity], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LogicalVolume]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spLogicalVolumeSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUsed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[LogicalVolume] 
	WHERE  ([ComputerGUID] = @computerGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeSizeUpdate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeSizeUpdate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spLogicalVolumeSizeUpdate]
	@dnsHostName nvarchar(255),
	@LogicalVolumeName nvarchar(255),
	@Capacity bigint,
	@SpaceUsed bigint

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @ComputerGUID uniqueidentifier
SELECT @ComputerGUID = [objectGUID]
FROM [cm].[Computer]
WHERE [dnsHostName] = @dnsHostName

UPDATE [cm].[LogicalVolume]
SET [Capacity] = @Capacity, [SpaceUsed] = @SpaceUsed
WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @LogicalVolumeName

COMMIT
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spLogicalVolumeUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLogicalVolumeUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLogicalVolumeUpsert] 
    @dnsHostName nvarchar(255),
    @Name nvarchar(128),
    @DriveLetter nvarchar(128) = NULL,
    @Label nvarchar(128) = NULL,
    @FileSystem nvarchar(128),
    @BlockSize int,
	@SerialNumber nvarchar(128),
    @Capacity bigint,
	@SpaceUsed bigint,
	@SystemVolume bit,
	@IsClustered bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[LogicalVolume] AS target
	USING (SELECT @DriveLetter, @Label, @FileSystem, @BlockSize, @SerialNumber, @Capacity, @SpaceUsed, @SystemVolume, @IsClustered, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUSed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name) 
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DriveLetter] = @DriveLetter, [Label] = @Label, [FileSystem] = @FileSystem, [BlockSize] = @BlockSize, [SerialNumber] = @SerialNumber, [Capacity] = @Capacity, [SpaceUsed] = @SpaceUsed, [SystemVolume] = @SystemVolume, [IsClustered] = @IsClustered, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUsed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @DriveLetter, @Label, @FileSystem, @BlockSize, @SerialNumber, @Capacity, @SpaceUsed, @SystemVolume, @IsClustered, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUsed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LogicalVolume]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterConfigurationDelete
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterConfigurationDelete] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[NetworkAdapterConfiguration]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterConfigurationInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterConfigurationInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[NetworkAdapterConfiguration]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapterConfiguration]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spNetworkAdapterConfigurationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[NetworkAdapterConfiguration] 
	WHERE  ([computerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterConfigurationUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterConfigurationUpsert] 
    @dnsHostName nvarchar(255),
    @Index int,
    @MACAddress nvarchar(128) = NULL,
    @IPV4Address nvarchar(255) = NULL,
    @SubnetMask nvarchar(128) = NULL,
    @DefaultIPGateway nvarchar(128) = NULL,
    @DNSDomainSuffixSearchOrder nvarchar(255) = NULL,
    @DNSServerSearchOrder nvarchar(255) = NULL,
    @DNSEnabledForWINSResolution bit,
    @FullDNSRegistrationEnabled bit,
    @DHCPEnabled bit,
    @DHCPLeaseObtained datetime2(3) = NULL,
    @DHCPLeaseExpires datetime2(3) = NULL,
    @DHCPServer nvarchar(128) = NULL,
    @WINSPrimaryServer nvarchar(128) = NULL,
    @WINSSecondaryServer nvarchar(128) = NULL,
    @IPEnabled bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[NetworkAdapterConfiguration] AS target
	USING (SELECT @MACAddress, @IPV4Address, @SubnetMask, @DefaultIPGateway, @DNSDomainSuffixSearchOrder, @DNSServerSearchOrder, @DNSEnabledForWINSResolution, @FullDNSRegistrationEnabled, @DHCPEnabled, @DHCPLeaseObtained, @DHCPLeaseExpires, @DHCPServer, @WINSPrimaryServer, @WINSSecondaryServer, @IPEnabled, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Index] = @Index)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [MACAddress] = @MACAddress, [IPV4Address] = @IPV4Address, [SubnetMask] = @SubnetMask, [DefaultIPGateway] = @DefaultIPGateway, [DNSDomainSuffixSearchOrder] = @DNSDomainSuffixSearchOrder, [DNSServerSearchOrder] = @DNSServerSearchOrder, [DNSEnabledForWINSResolution] = @DNSEnabledForWINSResolution, [FullDNSRegistrationEnabled] = @FullDNSRegistrationEnabled, [DHCPEnabled] = @DHCPEnabled, [DHCPLeaseObtained] = @DHCPLeaseObtained, [DHCPLeaseExpires] = @DHCPLeaseExpires, [DHCPServer] = @DHCPServer, [WINSPrimaryServer] = @WINSPrimaryServer, [WINSSecondaryServer] = @WINSSecondaryServer, [IPEnabled] = @IPEnabled, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Index, @MACAddress, @IPV4Address, @SubnetMask, @DefaultIPGateway, @DNSDomainSuffixSearchOrder, @DNSServerSearchOrder, @DNSEnabledForWINSResolution, @FullDNSRegistrationEnabled, @DHCPEnabled, @DHCPLeaseObtained, @DHCPLeaseExpires, @DHCPServer, @WINSPrimaryServer, @WINSSecondaryServer, @IPEnabled, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapterConfiguration]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[NetworkAdapter]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[NetworkAdapter]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapter]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spNetworkAdapterSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[NetworkAdapter] 
	WHERE  ([computerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spNetworkAdapterUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterUpsert] 
    @dnsHostName nvarchar(255),
    @Index int,
    @Name nvarchar(255),
    @NetConnectionID nvarchar(255) = NULL,
    @AdapterType nvarchar(255) = NULL,
    @Manufacturer nvarchar(255) = NULL,
    @MACAddress nvarchar(128) = NULL,
    @PhysicalAdapter bit = NULL,
    @Speed bigint = NULL,
	@NetEnabled bit = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[NetworkAdapter] AS target
	USING (SELECT @Name, @NetConnectionID, @AdapterType, @Manufacturer, @MACAddress, @PhysicalAdapter, @Speed, @NetEnabled, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [NetEnabled], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Index] = @Index)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Name] = @Name, [NetConnectionID] = @NetConnectionID, [AdapterType] = @AdapterType, [Manufacturer] = @Manufacturer, [MACAddress] = @MACAddress, [PhysicalAdapter] = @PhysicalAdapter, [Speed] = @Speed, [NetEnabled] = @NetEnabled, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [NetEnabled], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Index, @Name, @NetConnectionID, @AdapterType, @Manufacturer, @MACAddress, @PhysicalAdapter, @Speed, @NetEnabled, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [NetEnabled], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapter]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spOperatingSystemDeleteByComputer
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spOperatingSystemDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[OperatingSystem]
	WHERE  [computerGUID] = @computerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spOperatingSystemInactivateByComputer
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spOperatingSystemInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[OperatingSystem]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [computerGUID] = @computerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[OperatingSystem]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spOperatingSystemSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [computerGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[OperatingSystem] 
	WHERE  ([computerGUID] = @computerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spOperatingSystemUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spOperatingSystemUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spOperatingSystemUpsert] 
    @dnsHostName nvarchar(255),
    @IPV4Address nvarchar(128) = NULL,
    @Manufacturer nvarchar(255) = NULL,
    @OSArchitecture nvarchar(128) = NULL,
    @OSType nvarchar(128) = NULL,
    @OperatingSystem nvarchar(128) = NULL,
    @Description nvarchar(1024) = NULL,
    @Version nvarchar(128) = NULL,
    @ServicePack nvarchar(128) = NULL,
    @ServicePackMajorVersion int = NULL,
    @ServicePackMinorVersion int = NULL,
    @BootDevice nvarchar(255) = NULL,
    @SystemDevice nvarchar(255) = NULL,
    @WindowsDirectory nvarchar(255) = NULL,
    @SystemDirectory nvarchar(255) = NULL,
    @TotalVisibleMemorySize bigint = NULL,
    @InstallDate datetime2(3) = NULL,
    @LastBootUpTime datetime2(3) = NULL,
    @Status nvarchar(50) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	MERGE [cm].[OperatingSystem] AS target
	USING (SELECT @IPV4Address, @Manufacturer, @OSArchitecture, @OSType, @OperatingSystem, @Description, @Version, @ServicePack, @ServicePackMajorVersion, @ServicePackMinorVersion, @BootDevice, @SystemDevice, @WindowsDirectory, @SystemDirectory, @TotalVisibleMemorySize, @InstallDate, @LastBootUpTime, @Status, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([computerGUID] = @ComputerGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [IPV4Address] = @IPV4Address, [Manufacturer] = @Manufacturer, [OSArchitecture] = @OSArchitecture, [OSType] = @OSType, [OperatingSystem] = @OperatingSystem, [Description] = @Description, [Version] = @Version, [ServicePack] = @ServicePack, [ServicePackMajorVersion] = @ServicePackMajorVersion, [ServicePackMinorVersion] = @ServicePackMinorVersion, [BootDevice] = @BootDevice, [SystemDevice] = @SystemDevice, [WindowsDirectory] = @WindowsDirectory, [SystemDirectory] = @SystemDirectory, [TotalVisibleMemorySize] = @TotalVisibleMemorySize, [InstallDate] = @InstallDate, [LastBootUpTime] = @LastBootUpTime, [Status] = @Status, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([computerGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@computerGUID, @IPV4Address, @Manufacturer, @OSArchitecture, @OSType, @OperatingSystem, @Description, @Version, @ServicePack, @ServicePackMajorVersion, @ServicePackMinorVersion, @BootDevice, @SystemDevice, @WindowsDirectory, @SystemDirectory, @TotalVisibleMemorySize, @InstallDate, @LastBootUpTime, @Status, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [IPV4Address], [Manufacturer], [OSArchitecture], [OSType], [OperatingSystem], [Description], [Version], [ServicePack], [ServicePackMajorVersion], [ServicePackMinorVersion], [BootDevice], [SystemDevice], [WindowsDirectory], [SystemDirectory], [TotalVisibleMemorySize], [InstallDate], [LastBootUpTime], [Status], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[OperatingSystem]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportingInstanceDeleteByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportingInstanceDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[ReportingInstance]
	WHERE  ([ComputerGUID] = @ComputerGUID)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spReportingInstanceInactivate
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportingInstanceInactivate] 
    @ReportingInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[ReportingInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate, ServiceState = N'Removed'
	WHERE  ([objectGUID] = @ReportingInstanceGUID)

	IF @IncludeChildObjects = 1
	BEGIN
		UPDATE [cm].[ReportServerItem]
		SET Active = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([ReportingInstanceGUID] = @ReportingInstanceGUID)

		UPDATE [cm].[ReportServerSubscription]
		SET Active = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([ReportingInstanceGUID] = @ReportingInstanceGUID)

		UPDATE [cm].[ReportServerSubscriptionParameter]
		SET Active = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([ReportServerSubscriptionGUID] IN (SELECT [objectGUID] FROM [cm].ReportServerSubscription WHERE [ReportingInstanceGUID] = @ReportingInstanceGUID))

	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportingInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportingInstanceInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportingInstanceInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[ReportingInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportingInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spReportingInstanceSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportingInstance] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceSelectByServiceState]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceSelectByServiceState]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spReportingInstanceSelectByServiceState] 
    @ServiceState nvarchar(128),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportingInstance] 
	WHERE  ([ServiceState] = @ServiceState AND [Active] >= @Active)

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportingInstanceUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportingInstanceUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportingInstanceUpsert] 
    @dnsHostName nvarchar(255),
    @InstanceName nvarchar(128),
    @ProductName nvarchar(128),
    @ProductEdition nvarchar(128),
    @ProductVersion nvarchar(128),
    @ProductServicePack nvarchar(128),
    @ConnectionString nvarchar(255),
	@ServiceState nvarchar(128),
    @RSConfiguration nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[ReportingInstance] AS target
	USING (SELECT @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @RSConfiguration, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [InstanceName] = @InstanceName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ProductName] = @ProductName, [ProductEdition] = @ProductEdition, [ProductVersion] = @ProductVersion, [ProductServicePack] = @ProductServicePack, [ServiceState] = @ServiceState, [RSConfiguration] = @RSConfiguration, [Active] = @Active,[dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @InstanceName, @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @RSConfiguration, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportingInstance]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemDeleteByReportingInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemDeleteByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerItemDeleteByReportingInstance
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerItemDeleteByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ReportServerItem]
	WHERE  [ReportingInstanceGUID] = @ReportingInstanceGUID 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemInactivateByReportingInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemInactivateByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerItemInactivateByReportingInstance
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerItemInactivateByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[ReportServerItem]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ReportingInstanceGUID] = @ReportingInstanceGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerItem]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemSelectByReportingInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemSelectByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spReportServerItemSelectByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerItem] 
	WHERE  ([ReportingInstanceGUID] = @ReportingInstanceGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerItemUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerItemUpsert
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerItemUpsert] 
    @ReportingInstanceGUID uniqueidentifier,
    @Name nvarchar(128),
    @Path nvarchar(512),
    @VirtualPath nvarchar(1024),
    @TypeName nvarchar(128),
    @Size int,
    @Description nvarchar(1024) = NULL,
    @Hidden bit,
    @CreationDate datetime2(3),
    @ModifiedDate datetime2(3),
    @ModifiedBy nvarchar(255),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[ReportServerItem] AS target
	USING (SELECT @VirtualPath, @TypeName, @Size, @Description, @Hidden, @CreationDate, @ModifiedDate, @ModifiedBy, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ReportingInstanceGUID] = @ReportingInstanceGUID AND [Name] = @Name AND [Path] = @Path)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [VirtualPath] = @VirtualPath, [TypeName] = @TypeName, [Size] = @Size, [Description] = @Description, [Hidden] = @Hidden, [CreationDate] = @CreationDate, [ModifiedDate] = @ModifiedDate, [ModifiedBy] = @ModifiedBy, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ReportingInstanceGUID, @Name, @Path, @VirtualPath, @TypeName, @Size, @Description, @Hidden, @CreationDate, @ModifiedDate, @ModifiedBy, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Name], [Path], [VirtualPath], [TypeName], [Size], [Description], [Hidden], [CreationDate], [ModifiedDate], [ModifiedBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerItem]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionDeleteByReportingInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionDeleteByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionDeleteByReportingInstance
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionDeleteByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ReportServerSubscription]
	WHERE  [ReportingInstanceGUID] = @ReportingInstanceGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionInactivateByReportingInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionInactivateByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionInactivateByReportingInstance
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionInactivateByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[ReportServerSubscription]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ReportingInstanceGUID] = @ReportingInstanceGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscription]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterDeleteBySubscription]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterDeleteBySubscription]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionParameterDeleteBySubscription
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionParameterDeleteBySubscription]
    @ReportServerSubscriptionGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ReportServerSubscriptionParameter]
	WHERE  [ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterInactivateBySubscription]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterInactivateBySubscription]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionParameterInactivateBySubscription
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionParameterInactivateBySubscription] 
    @ReportServerSubscriptionGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[ReportServerSubscriptionParameter]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscriptionParameter]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterSelectBySubscription]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterSelectBySubscription]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spReportServerSubscriptionParameterSelectBySubscription] 
    @ReportServerSubscriptionGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerSubscriptionParameter] 
	WHERE  [ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID AND [Active] >= @Active

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionParameterUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionParameterUpsert
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionParameterUpsert] 
    @ReportServerSubscriptionGUID uniqueidentifier,
    @ParameterName nvarchar(255),
    @ParameterValue nvarchar(255) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[ReportServerSubscriptionParameter] AS target
	USING (SELECT @ParameterValue, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		( [ParameterValue], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID AND [ParameterName] = @ParameterName)
       WHEN MATCHED THEN 
		UPDATE 
		SET     [ParameterValue] = @ParameterValue, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ReportServerSubscriptionGUID, @ParameterName, @ParameterValue, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscriptionParameter]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionSelectByReportingInstance]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionSelectByReportingInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spReportServerSubscriptionSelectByReportingInstance] 
    @ReportingInstanceGUID uniqueidentifier,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ReportServerSubscription] 
	WHERE  ([ReportingInstanceGUID] = @ReportingInstanceGUID AND [Active] = @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spReportServerSubscriptionUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportServerSubscriptionUpsert
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionUpsert] 
	@objectGUID uniqueidentifier,
    @ReportingInstanceGUID uniqueidentifier,
    @Owner nvarchar(255),
    @Path nvarchar(1024),
    @VirtualPath nvarchar(1024),
    @Report nvarchar(1024),
    @Description nvarchar(1204) = NULL,
    @Status nvarchar(128),
    @SubscriptionActive bit,
    @LastExecuted datetime2(3) = NULL,
    @ModifiedBy nvarchar(255),
    @ModifiedDate datetime2(3),
    @EventType nvarchar(128),
    @IsDataDriven bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[ReportServerSubscription] AS target
	USING (SELECT @ReportingInstanceGUID, @Owner, @Path, @VirtualPath, @Report, @Description, @Status, @SubscriptionActive, @LastExecuted, @ModifiedBy, @ModifiedDate, @EventType, @IsDataDriven, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [VirtualPath] = @VirtualPath, [Report] = @Report, [Description] = @Description, [Status] = @Status, [SubscriptionActive] = @SubscriptionActive, [LastExecuted] = @LastExecuted, [ModifiedBy] = @ModifiedBy, [ModifiedDate] = @ModifiedDate, [EventType] = @EventType, [IsDataDriven] = @IsDataDriven, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @ReportingInstanceGUID, @Owner, @Path, @VirtualPath, @Report, @Description, @Status, @SubscriptionActive, @LastExecuted, @ModifiedBy, @ModifiedDate, @EventType, @IsDataDriven, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscription]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spServiceDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spServiceDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spServiceDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spServiceDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] 
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[Service]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spServiceInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spServiceInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spServiceInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spServiceInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] 
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[Service]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Service]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spServiceSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spServiceSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spServiceSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] 
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Service] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spServiceUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spServiceUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spServiceUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spServiceUpsert] 
    @dnsHostName nvarchar(255),
    @Name nvarchar(255),
    @DisplayName nvarchar(255) = NULL,
    @Description nvarchar(2048) = NULL,
    @Status nvarchar(128) = NULL,
    @State nvarchar(128) = NULL,
    @StartMode nvarchar(128) = NULL,
    @StartName nvarchar(255) = NULL,
    @PathName nvarchar(255) = NULL,
    @AcceptStop bit,
    @AcceptPause bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] 
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[Service] AS target
	USING (SELECT @DisplayName, @Description, @Status, @State, @StartMode, @StartName, @PathName, @AcceptStop, @AcceptPause, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [DisplayName] = @DisplayName, [Description] = @Description, [Status] = @Status, [State] = @State, [StartMode] = @StartMode, [StartName] = @StartName, [PathName] = @PathName, [AcceptStop] = @AcceptStop, [AcceptPause] = @AcceptPause, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Name, @DisplayName, @Description, @Status, @State, @StartMode, @StartName, @PathName, @AcceptStop, @AcceptPause, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Service]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationDeleteByApplication]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationDeleteByApplication]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationDeleteByApplication
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationDeleteByApplication] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WebApplication]
	WHERE  [Name] = @Name

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationInactivateByApplication]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationInactivateByApplication]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationInactivateByApplication
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationInactivateByApplication] 
    @Name nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[WebApplication]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @Name
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplication]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationSelectByApplication]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationSelectByApplication]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spWebApplicationSelectByApplication] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Name], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplication] 
	WHERE  ([Name] = @Name) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationUpsert
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationUpsert] 
    @Name nvarchar(255),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[WebApplication] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbAddDate] = @dbLastUpdate, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplication]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLDeleteByName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLDeleteByName]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationURLDeleteByName
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLDeleteByName] 
    @Name uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WebApplicationURL]
	WHERE  [Name] = @Name

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLInactivateByName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLInactivateByName]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationURLInactivateByName
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLInactivateByName]
    @Name nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[WebApplicationURL]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Name] = @Name
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplicationURL]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spWebApplicationURLSelect] 
    @Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplicationURL] 
	WHERE  ([Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spWebApplicationURLSelectByComputer] 
	@dnsHostName nvarchar(255),
    @Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [WebApplicationGUID], [ComputerGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplicationURL] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelectByName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLSelectByName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spWebApplicationURLSelectByName] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplicationURL] 
	WHERE  ([Name] = @Name) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLUpdateLastResult]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLUpdateLastResult]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spWebApplicationURLUpsertLastResult
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLUpdateLastResult] 
    @WebApplicationURLGUID uniqueidentifier,
	@LastStatusCode nvarchar(128), 
	@LastStatusDescription nvarchar(128) = NULL, 
	@LastResponseTime int = NULL, 
	@LastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[WebApplicationURL]
	SET   [LastStatusCode] = @LastStatusCode, [LastStatusDescription] = @LastStatusDescription, [LastResponseTime] = @LastResponseTime, [LastUpdate] = @LastUpdate
	WHERE [objectGUID] = @WebApplicationURLGUID 
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [WebApplicationGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplicationURL]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWebApplicationURLUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWebApplicationURLUpsert
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationURLUpsert] 
    @WebApplicationGUID uniqueidentifier,
	@dnsHostName nvarchar(255),
    @Name nvarchar(255),
    @URL nvarchar(2048),
    @UseDefaultCredential bit,
    @FormData nvarchar(2048) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[WebApplicationURL] AS target
	USING (SELECT @URL, @UseDefaultCredential, @FormData, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([URL], [UseDefaultCredential], [FormData], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([WebApplicationGUID] = @WebApplicationGUID AND [ComputerGUID] = @ComputerGUID AND [Name] = @Name )
       WHEN MATCHED THEN 
		UPDATE 
		SET   [URL] = @URL, [UseDefaultCredential] = @UseDefaultCredential, [FormData] = @FormData, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([WebApplicationGUID], [ComputerGUID], [Name], [URL], [UseDefaultCredential], [FormData], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@WebApplicationGUID, @ComputerGUID, @Name, @URL, @UseDefaultCredential, @FormData, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [WebApplicationGUID], [ComputerGUID], [Name], [URL], [UseDefaultCredential], [FormData], [LastStatusCode], [LastStatusDescription], [LastResponseTime], [LastUpdate], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplicationURL]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateDelete
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateDelete] 
    @HotfixID nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[WindowsUpdate]
	WHERE  [HotfixID] = @HotfixID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateInactivate
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInactivate] 
    @HotfixID nvarchar(128),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[WindowsUpdate]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [HotfixID] = @HotfixID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdate]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateInstallationDeleteByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateInstallationDeleteByComputer
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[WindowsUpdateInstallation]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateInstallationInactivateByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateInstallationInactivateByComputer
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[WindowsUpdateInstallation]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @ComputerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdateInstallation]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateInstallationSelectByComputer]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateInstallationSelectByComputer
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WindowsUpdateInstallation] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateInstallationUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateInstallationUpsert
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateInstallationUpsert] 
    @dnsHostName nvarchar(255),
    @HotfixID nvarchar(128),
    @Description nvarchar(128),
    @Caption nvarchar(128) = NULL,
    @FixComments nvarchar(128) = NULL,
    @InstallDate datetime2(3) = NULL,
    @InstallBy nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DECLARE @WindowsUpdateGUID uniqueidentifier
	SELECT @WindowsUpdateGUID = objectGUID
	FROM [cm].[WindowsUpdate]
	WHERE [HotfixID] = @HotfixID

	BEGIN TRAN

	IF @WindowsUpdateGUID is null
	BEGIN
		EXEC cm.spWindowsUpdateUpsert @HotfixID = @HotFixID, @Description = @Description, @Caption = @Caption, @FixComments = @FixComments, @Active = 1, @dbLastUpdate = @dbLastUpdate
		SELECT @WindowsUpdateGUID = objectGUID
		FROM [cm].[WindowsUpdate]
		WHERE [HotfixID] = @HotfixID	
	END

	COMMIT

	BEGIN TRAN

	MERGE [cm].[WindowsUpdateInstallation] AS target
	USING (SELECT @InstallDate, @InstallBy, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [WindowsUpdateGUID] = @WindowsUpdateGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [InstallDate] = @InstallDate, [InstallBy] = @InstallBy, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @WindowsUpdateGUID, @InstallDate, @InstallBy, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [WindowsUpdateGUID], [InstallDate], [InstallBy], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdateInstallation]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateSelect
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateSelect] 
    @HotfixID nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WindowsUpdate] 
	WHERE  ([HotfixID] = @HotfixID OR @HotfixID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [cm].[spWindowsUpdateUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spWindowsUpdateUpsert
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateUpsert] 
    @HotfixID nvarchar(128),
    @Description nvarchar(128),
    @Caption nvarchar(128) = NULL,
    @FixComments nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[WindowsUpdate] AS target
	USING (SELECT @Description, @Caption, @FixComments, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([HotfixID] = @HotfixID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [Caption] = @Caption, [FixComments] = @FixComments, [Active] = @Active, [dbAddDate] = @dbLastUpdate, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@HotfixID, @Description, @Caption, @FixComments, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdate]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spComputerDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spComputerDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spComputerDelete
* Author: huscott
* Date: 2015-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerDelete] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Computer]
	WHERE  [dnsHostName] = @dnsHostName

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spComputerInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spComputerInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spComputerInactivate
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerInactivate] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [dbo].[Computer]
	SET [Active] = 0, dbLastUpdate = GETUTCDATE()
	WHERE  [dnsHostName] = @dnsHostName
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [dnsHostName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Computer]
	WHERE  [ID] = @ID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spComputerReactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spComputerReactivate]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: dbo.spComputerReactivate
* Author: huscott
* Date: 2015-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerReactivate] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [dbo].[Computer]
	SET [Active] = 1, dbLastUpdate = GETUTCDATE()
	WHERE  [dnsHostName] = @dnsHostName
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [dnsHostName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Computer]
	WHERE  [ID] = @ID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spComputerSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spComputerSelect
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerSelect] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [dnsHostName], [AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [dbo].[Computer] 
	WHERE  ([dnsHostName] = @dnsHostName OR (@dnsHostName IS NULL AND [Active] >= @Active))

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spComputerSelectByAgentName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spComputerSelectByAgentName
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerSelectByAgentName]
	@AgentName nvarchar(128) = NULL,
	@Active bit = 1

AS

SELECT [dnsHostName]
  FROM [dbo].[Computer]
 WHERE ([AgentName] = @AgentName OR @AgentName is NULL)
       AND [Active] >= @Active
GO
/****** Object:  StoredProcedure [dbo].[spComputerUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spComputerUpsert
* Author: huscott
* Date: 2015-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerUpsert] 
	@Domain nvarchar(128),
    @dnsHostName nvarchar(255),
	@AgentName nvarchar(128),
    @CredentialName nvarchar(255) = NULL,
    @Active bit,
    @dbAddDate datetime2(3) = NULL,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [dbo].[Computer] AS target
	USING (SELECT @AgentName, @CredentialName, @Active, @dbAddDate, @dbLastUpdate) 
		AS source 
		([AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Domain] = @Domain AND [dnsHostName] = @dnsHostName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [AgentName] = @AgentName, [CredentialName] = @CredentialName, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [dnsHostName], [AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @dnsHostName, @AgentName, @CredentialName, @Active, @dbAddDate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [dnsHostName], [AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Computer]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spConfigDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spConfigDelete
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spConfigDelete] 
    @ConfigName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Config]
	WHERE  [ConfigName] = @ConfigName

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spConfigSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spConfigSelect
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spConfigSelect] 
    @ConfigName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy] 
	FROM   [dbo].[Config] 
	WHERE  ([ConfigName] = @ConfigName OR @ConfigName IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spConfigUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spConfigUpsert
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spConfigUpsert] 
    @ConfigName nvarchar(255),
    @ConfigValue nvarchar(255),
    @dbModDate datetime2(3),
    @dbModBy nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [dbo].[Config] AS target
	USING (SELECT @ConfigValue, @dbModDate, @dbModBy, @dbModDate, @dbModBy) 
		AS source 
		([ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy])
	-- !!!! Check the criteria for match
	ON ([ConfigName] = @ConfigName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ConfigValue] = @ConfigValue, [dbModDate] = @dbModDate, [dbModBy] = @dbModBy
	WHEN NOT MATCHED THEN
		INSERT ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy])
		VALUES (@ConfigName, @ConfigValue, @dbModDate, @dbModBy, @dbModDate, @dbModBy)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]
	FROM   [dbo].[Config]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spCredentialDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialDelete
* Author: huscott
* Date: 2015-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialDelete] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Credential]
	WHERE  [Name] = @Name

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spCredentialInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialInactivate
* Author: huscott
* Date: 2015-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialInactivate] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [dbo].[Credential]
	SET [Active] = 0, dbLastUpdate = GETUTCDATE()
	WHERE  [Name] = @Name
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Credential]
	WHERE  [ID] = @ID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spCredentialSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialSelect
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialSelect] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [dbo].[Credential] 
	WHERE  ([Name] = @Name OR @Name IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spCredentialUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialUpsert
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spCredentialUpsert] 
    @Name nvarchar(255),
    @CredentialType nvarchar(128),
    @AccountName nvarchar(255),
    @Password nvarchar(512) = NULL,
    @Active bit,
    @dbAddDate datetime2(3) = NULL,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [dbo].[Credential] AS target
	USING (SELECT @CredentialType, @AccountName, @Password, @Active, @dbAddDate, @dbLastUpdate) 
		AS source 
		([CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [CredentialType] = @CredentialType, [AccountName] = @AccountName, [Password] = @Password, [Active] = @Active, [dbAddDate] = @dbAddDate, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @CredentialType, @AccountName, @Password, @Active, @dbAddDate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Name], [CredentialType], [AccountName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Credential]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spProcessLogDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spProcessLogDelete
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [dbo].[spProcessLogDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM dbo.ProcessLog 
WHERE MessageDate < DATEADD(DAY, -@daysRetain, GetDate())

COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spProcessLogInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spProcessLogInsert
* Author: huscott
* Date: 2018-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spProcessLogInsert] 
    @Severity nvarchar(50) = NULL,
    @Process nvarchar(50) = NULL,
    @Object nvarchar(255) = NULL,
    @Message nvarchar(max) = NULL,
    @MessageDate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	INSERT INTO dbo.ProcessLog ([Severity], [Process], [Object], [Message], [MessageDate])
	VALUES (@Severity, @Process, @Object, @Message, @MessageDate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Severity], [Process], [Object], [Message], [MessageDate]
	FROM   [cm].[ProcessLog]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spProcessLogSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: cm.spProcessLogSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spProcessLogSelect] 
    @ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Severity], [Process], [Object], [Message], [MessageDate] 
	FROM   [dbo].[ProcessLog] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spReportContentSelectByReportID]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spReportContentSelectByReportID]
@ReportID uniqueidentifier

AS

SET NOCOUNT ON
SET XACT_ABORT ON

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportID
  ORDER BY [SortSequence]
GO
/****** Object:  StoredProcedure [dbo].[spReportContentSelectByReportName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spReportContentSelectByReportName]
@ReportName nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @ReportID uniqueidentifier

SELECT @ReportID = ID
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportID
  ORDER BY [SortSequence]
GO
/****** Object:  StoredProcedure [dbo].[spReportContentSelectByReportNameAndSortSequence]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spReportContentSelectByReportNameAndSortSequence]
@ReportName nvarchar(255),
@SortSequence int 

AS

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @ReportID uniqueidentifier

SELECT @ReportID = ID
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportID
  AND [SortSequence] = @SortSequence
GO
/****** Object:  StoredProcedure [dbo].[spReportHeaderSelectByReportName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spReportHeaderSelectByReportName]
@ReportName nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


SELECT TOP 1 [Id]
      ,[ReportName]
      ,[ReportDisplayName]
      ,[ReportBackground]
      ,[TitleBackground]
      ,[TitleFont]
      ,[TitleFontColor]
      ,[TitleFontSize]
      ,[SubTitleBackground]
      ,[SubTitleFont]
      ,[SubTitleFontColor]
      ,[SubTitleFontSize]
      ,[TableHeaderBackground]
      ,[TableHeaderFont]
      ,[TableHeaderFontColor]
      ,[TableHeaderFontSize]
      ,[TableFooterBackground]
      ,[TableFooterFont]
      ,[TableFooterFontColor]
      ,[TableFooterFontSize]
      ,[RowEvenBackground]
      ,[RowEvenFont]
      ,[RowEvenFontColor]
      ,[RowEvenFontSize]
      ,[RowOddBackground]
      ,[RowOddFont]
      ,[RowOddFontColor]
      ,[RowOddFontSize]
      ,[dbAddDate]
      ,[dbModDate]
      ,[FooterBackground]
      ,[FooterFont]
      ,[FooterFontColor]
      ,[FooterFontSize]
  FROM [dbo].[ReportHeader]
  WHERE [ReportName] = @ReportName OR [ReportName] = '<default>'
  ORDER BY [ReportName] DESC
GO
/****** Object:  StoredProcedure [dbo].[spSystemTimeZoneSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************
* Name: dbo.spSystemTimeZoneSelect
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spSystemTimeZoneSelect] (
	@Display bit = 1
)

AS

SET NOCOUNT ON

SELECT [ZoneID]
      ,[ID]
      ,[DisplayName]
      ,[StandardName]
      ,[DaylightName]
      ,[BaseUTCOffset]
      ,[CurrentUTCOffset]
      ,[SupportsDaylightSavingTime]
      ,[Display]
      ,[DefaultTimeZone]
      ,[Active]
      ,[dbAddDate]
      ,[dbLastUpdate]
  FROM [dbo].[SystemTimeZone]
  WHERE [Display] >= @Display
  ORDER BY [CurrentUTCOffset]
GO
/****** Object:  StoredProcedure [dbo].[spSystemTimeZoneUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spSystemTimeZoneUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spSystemTimeZoneUpsert] (
	@ID nvarchar(255),
	@DisplayName nvarchar(255),
	@StandardName nvarchar(255),
	@DaylightName nvarchar(255),
	@BaseUTCOffset [int],
	@CurrentUTCOffset [int],
	@SupportsDaylightSavingTime bit,
	@Active bit,
	@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS(SELECT ZoneID FROM dbo.SystemTimeZone WHERE ID = @ID)
BEGIN
	UPDATE [dbo].[SystemTimeZone]
		SET 
			[ID] = @ID
			,[DisplayName] = @DisplayName
			,[StandardName] = @StandardName
			,[DaylightName] = @DaylightName
			,[BaseUTCOffset] = @BaseUTCOffset
			,[CurrentUTCOffset] = @CurrentUTCOffset
			,[SupportsDaylightSavingTime] = @SupportsDaylightSavingTime
			,[Active] = @Active
			,[dbLastUpdate] = @dbLastUpdate
		WHERE ID = @ID
END

ELSE

BEGIN

INSERT INTO [dbo].[SystemTimeZone]
           ([ID]
           ,[DisplayName]
           ,[StandardName]
           ,[DaylightName]
           ,[BaseUTCOffset]
           ,[CurrentUTCOffset]
           ,[SupportsDaylightSavingTime]
		   ,[Active]
           ,[dbAddDate]
           ,[dbLastUpdate])
     VALUES
           (@ID
           ,@DisplayName
           ,@StandardName
           ,@DaylightName
           ,@BaseUTCOffset
           ,@CurrentUTCOffset
           ,@SupportsDaylightSavingTime
		   ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate)

END
GO
/****** Object:  StoredProcedure [pm].[spDatabaseSizeDailyDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spDatabaseSizeDailyDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spDatabaseSizeDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[DatabaseSizeDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spDatabaseSizeDailyUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spDatabaseSizeDailyUpsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spDatabaseSizeDailyUpsert]
	@ForDate DateTime2 = null

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF @ForDate IS NULL
BEGIN
	SET @ForDate = Cast(Convert(varchar(10), CURRENT_TIMESTAMP, 120) AS DATETIME2)
END

DECLARE @CurrentTime datetime2
SET @CurrentTime = CURRENT_TIMESTAMP


	MERGE [pm].[DatabaseSizeDaily] AS [target]
	USING (
		SELECT 
			@ForDate as [Date]
			, [DatabaseGUID]
			, AVG([DataFileSize]) as [DataFileSize]
			, AVG([DataFileSpaceUsed]) as [DataFileSpaceUsed]
			, AVG([LogFileSize]) as [LogFileSize]
			, AVG([LogFileSpaceUsed]) as [LogFileSpaceUsed]
			, COUNT(*) AS [Count]
			, @CurrentTime as [dbAddDate]
		FROM
			[pm].[DatabaseSizeRaw]
		WHERE 
			[DateTime] BETWEEN @ForDate AND DateAdd(DAY, 1, @ForDate)
		GROUP BY
			[DatabaseGUID]
	)
	AS [source] (
		[Date]
        ,[DatabaseGUID]
        ,[DataFileSize]
        ,[DataFileSpaceUsed]
        ,[LogFileSize]
        ,[LogFileSpaceUsed]
        ,[Count]
        ,[dbAddDate]
	)
	ON ([target].[Date] = [source].[Date] AND [target].[DatabaseGUID] = [source].[DatabaseGUID])

	WHEN MATCHED THEN
	UPDATE
	SET [target].[DataFileSize] = [source].[DataFileSize], [target].[DataFileSpaceUsed] = [source].[DataFileSpaceUsed], [target].[LogFileSize] = [source].[LogFileSize], [target].[LogFileSpaceUsed] = [source].[LogFileSpaceUsed], [target].[Count] = [source].[Count], [target].[dbAddDate] = [source].[dbAddDate]

	WHEN NOT MATCHED THEN
	INSERT ([Date]
           ,[DatabaseGUID]
           ,[DataFileSize]
           ,[DataFileSpaceUsed]
           ,[LogFileSize]
           ,[LogFileSpaceUsed]
           ,[Count]
           ,[dbAddDate])
	VALUES ([source].[Date]
           ,[source].[DatabaseGUID]
           ,[source].[DataFileSize]
           ,[DataFileSpaceUsed]
           ,[source].[LogFileSize]
           ,[source].[LogFileSpaceUsed]
           ,[source].[Count]
           ,[source].[dbAddDate])
	;
GO
/****** Object:  StoredProcedure [pm].[spDatabaseSizeRawDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [pm].[spDatabaseSizeRawDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spDatabaseSizeRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime2
SET @CurrentDate = GetDate()

DELETE FROM [pm].[DatabaseSizeRaw]
WHERE [DateTime] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spDatabaseSizeRawInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [pm].[spDatabaseSizeRawInsert]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spDatabaseSizeRawInsert]
	@DateTime datetime2(3),
	@DatabaseGUID uniqueidentifier,
	@DataFileSize bigint,
	@DataFileSpaceUsed bigint,
	@LogFileSize bigint,
	@LogFileSpaceUsed bigint,
	@dbAddDate datetime2(3)
AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

INSERT INTO [pm].[DatabaseSizeRaw]
           ([DateTime]
           ,[DatabaseGUID]
           ,[DataFileSize]
           ,[DataFileSpaceUsed]
           ,[LogFileSize]
           ,[LogFileSpaceUsed]
           ,[dbAddDate])
     VALUES
           (@DateTime
           ,@DatabaseGUID
           ,@DataFileSize
           ,@DataFileSpaceUsed
           ,@LogFileSize
           ,@LogFileSpaceUsed
           ,@dbAddDate)
COMMIT
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeDailyDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeDailyDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spLogicalVolumeSizeDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate smalldatetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[LogicalVolumeSizeDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeDailyUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeDailyUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [pm].[spLogicalVolumeSizeDailyUpsert]
	@ForDate [Date] = null

AS

	SET NOCOUNT ON
	SET XACT_ABORT ON

	IF @ForDate IS NULL
	BEGIN
		SET @ForDate = Cast(Convert(varchar(10), CURRENT_TIMESTAMP, 120) AS DATETIME2)
	END

	DECLARE @CurrentTime datetime2
	SET @CurrentTime = CURRENT_TIMESTAMP

	MERGE [pm].[LogicalVolumeSizeDaily] AS target
	USING (
	SELECT
		@ForDate as [Date]
		,[ComputerGUID]
		,[LogicalVolumeGUID]
		,AVG([SpaceUsed]) as AvgSpaceUsed
		,Max([SpaceUsed]) as MaxSpaceUsed
		,Min([SpaceUsed]) as MinSpaceUsed
		,IsNULL(StDev([SpaceUsed]),0) as StDevSpaceUsed
		,COUNT(*) as [Count]
		,@CurrentTime as [dbAddDate]
	FROM
		[pm].[LogicalVolumeSizeRaw]
	WHERE 
		[DateTime] BETWEEN @ForDate AND DateAdd(DAY, 1, @ForDate)
	GROUP BY 
		[ComputerGUID], [LogicalVolumeGUID])
	AS source
		(	[Date]
           ,[ComputerGUID]
		   ,[LogicalVolumeGUID]
           ,[AvgSpaceUsed]
           ,[MaxSpaceUsed]
           ,[MinSpaceUsed]
           ,[StDevSpaceUsed]
           ,[Count]
           ,[dbAddDate])
	ON (target.[Date] = source.[Date] AND target.[ComputerGUID] = source.[ComputerGUID] AND target.[LogicalVolumeGUID] = source.[LogicalVolumeGUID])

	WHEN MATCHED THEN
		UPDATE
		SET [target].[SpaceUsed] = source.[AvgSpaceUsed], target.[MaxSpaceUsed] = source.[MaxSpaceUsed], target.MinSpaceUsed = source.MinSpaceUsed, target.StDevSpaceUsed = source.StDevSpaceUsed, target.[Count] = source.[Count], target.dbAddDate = source.dbAddDate
	WHEN NOT MATCHED THEN
		INSERT ([Date], [ComputerGUID], [LogicalVolumeGUID], [SpaceUsed], [MaxSpaceUsed], [MinSpaceUsed], [StDevSpaceUsed], [Count], [dbAddDate])
		VALUES (source.[Date], source.[ComputerGUID], source.[LogicalVolumeGUID], source.[AvgSpaceUsed], source.[MaxSpaceUsed], source.[MinSpaceUsed], source.[StDevSpaceUsed], source.[Count], source.[dbAddDate])
	;
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeRawDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeRawDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [pm].[spLogicalVolumeSizeRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime2
SET @CurrentDate = GetDate()

DELETE FROM [pm].[LogicalVolumeSizeRaw]
WHERE [DateTime] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeRawInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spLogicalVolumeSizeRawInsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spLogicalVolumeSizeRawInsert] 
	@DateTime datetime2(3),
	@dnsHostName nvarchar(255),
	@LogicalVolumeName nvarchar(255),
	@SpaceUsed bigint,
	@dbAddDate datetime2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @ComputerGUID uniqueidentifier
DECLARE @LogicalVolumeGUID uniqueidentifier

SELECT @ComputerGUID = [objectGUID]
FROM [cm].[Computer]
WHERE [dnsHostName] = @dnsHostName

SELECT @LogicalVolumeGUID = [objectGUID]
FROM [cm].[LogicalVolume] 
WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @LogicalVolumeName

INSERT INTO [pm].[LogicalVolumeSizeRaw]
           ([DateTime]
           ,[ComputerGUID]
           ,[LogicalVolumeGUID]
           ,[SpaceUsed]
           ,[dbAddDate])
     VALUES
           (@DateTime
           ,@ComputerGUID
           ,@LogicalVolumeGUID
           ,@SpaceUsed
           ,@dbAddDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseDailyDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spWebApplicationURLResponseDailyDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spWebApplicationURLResponseDailyDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseDaily]
WHERE [Date] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseDailyUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spWebApplicationURLResponseDailyUpsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [pm].[spWebApplicationURLResponseDailyUpsert]
	@ForDate [Date] = null

AS

	SET NOCOUNT ON
	SET XACT_ABORT ON

	IF @ForDate IS NULL
	BEGIN
		SET @ForDate = Cast(Convert(varchar(10), CURRENT_TIMESTAMP, 120) AS Date)
	END

	DECLARE @CurrentTime datetime2(3)
	SET @CurrentTime = CURRENT_TIMESTAMP


	MERGE [pm].[WebApplicationURLResponseDaily] AS [target]
	USING (
		SELECT @ForDate AS [Date]
			, [WebApplicationURLGUID]
			, SUM(CASE WHEN [StatusCode] < 400 THEN 0 ELSE 1 END) AS [FailedCheckCount]
			, SUM(CASE WHEN [StatusCode] < 400 THEN 1 ELSE 0 END) AS [SuccessCheckCount]
			, AVG([LastResponseTime]) AS [AvgResponseTime]
			, MIN([LastResponseTime]) AS [MinResponseTime]
			, MAX([LastResponseTime]) AS [MaxResponseTime]
			, ISNULL(STDEV([LastResponseTime]),0) AS [StDevResponseTime]
			, COUNT(*) AS [COUNT]
			, @CurrentTime AS [dbAddDate]	
		FROM
			[pm].[WebApplicationURLResponseRaw]
		WHERE 
			[DateTime] BETWEEN @ForDate AND DateAdd(DAY, 1, @ForDate)
		GROUP BY
			[WebApplicationURLGUID]
		) 
	AS [source]
           ([Date]
           ,[WebApplicationURLGUID]
           ,[FailedCheckCount]
           ,[SuccessCheckCount]
           ,[AvgResponseTime]
           ,[MinResponseTime]
           ,[MaxResponseTime]
           ,[StDevResponseTime]
           ,[Count]
           ,[dbAddDate])
	ON ([target].[Date] = [source].[Date] AND [target].[WebApplicationURLGUID] = [source].[WebApplicationURLGUID])
	WHEN MATCHED THEN
		UPDATE
		SET [target].[FailedCheckCount] = [source].[FailedCheckCount], [target].[SuccessCheckCount] = [source].[SuccessCheckCount], [target].[AvgResponseTime] = [source].[AvgResponseTime], [target].[MinResponseTime] = [source].[MinResponseTime], [target].[MaxResponseTime] = [source].[MaxResponseTime], [target].[StDevResponseTime] = [source].[StDevResponseTime], [target].[Count] = [source].[Count], [target].[dbAddDate] = [source].[dbAddDate]

	WHEN NOT MATCHED THEN
		INSERT (
			[Date]
           ,[WebApplicationURLGUID]
           ,[FailedCheckCount]
           ,[SuccessCheckCount]
           ,[AvgResponseTime]
           ,[MinResponseTime]
           ,[MaxResponseTime]
           ,[StDevResponseTime]
           ,[Count]
           ,[dbAddDate])
		VALUES (
			[source].[Date]
           ,[source].[WebApplicationURLGUID]
           ,[source].[FailedCheckCount]
           ,[source].[SuccessCheckCount]
           ,[source].[AvgResponseTime]
           ,[source].[MinResponseTime]
           ,[source].[MaxResponseTime]
           ,[source].[StDevResponseTime]
           ,[source].[Count]
           ,[source].[dbAddDate])
	;
GO
/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseRawDelete]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spWebApplicationURLResponseRawDelete
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spWebApplicationURLResponseRawDelete]
	@daysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @CurrentDate datetime
SET @CurrentDate = GetDate()

DELETE FROM [pm].[WebApplicationURLResponseRaw]
WHERE [DateTime] < DateAdd(Day,-@daysRetain,@CurrentDate)

COMMIT
GO
/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseRawInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spWebApplicationURLResponseRawInsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spWebApplicationURLResponseRawInsert] (
	@WebApplicationURLGUID uniqueidentifier,
	@StatusCode int,
	@StatusDescription nvarchar(128),
	@LastResponseTime int,
	@dbAddDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

	INSERT INTO [pm].[WebApplicationURLResponseRaw]
			   ([DateTime]
			   ,[WebApplicationURLGUID]
			   ,[StatusCode]
			   ,[StatusDescription]
			   ,[LastResponseTime]
			   ,[dbAddDate])
		 VALUES
			   (@dbAddDate
			   ,@WebApplicationURLGUID
			   ,@StatusCode
			   ,@StatusDescription
			   ,@LastResponseTime
			   ,@dbAddDate)

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spAgentAvailabilityUpdate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAgentAvailabilityUpdate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAgentAvailabilityUpdate] (
	@DisplayName nvarchar(255),
	@IsAvailable bit,
	@AvailabilityLastModified datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.Agent
SET IsAvailable = @IsAvailable, AvailabilityLastModified = @AvailabilityLastModified
WHERE DisplayName = @DisplayName

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spAgentExclusionsInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
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
GO
/****** Object:  StoredProcedure [scom].[spAgentInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************
* Name: scom.spAgentInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAgentInactivate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.Agent
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) AND Active = 1

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spAgentUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAgentUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAgentUpsert]
	@AgentID uniqueidentifier,
	@Name nvarchar(255), 
	@DisplayName nvarchar(1024), 
	@Domain nvarchar(255), 
	@ManagementGroup nvarchar(255), 
	@PrimaryManagementServer nvarchar(255), 
	@Version nvarchar(255), 
	@PatchList nvarchar(255), 
	@ComputerName nvarchar(255), 
	@HealthState nvarchar(255), 
	@InstalledBy nvarchar(255), 
	@InstallTime datetime, 
	@ManuallyInstalled bit, 
	@ProxyingEnabled bit, 
	@IPAddress nvarchar(1024), 
	@LastModified datetime2(3),
	@Active bit,
	@dbLastUpdate datetime2(3)
AS


SET NOCOUNT ON 
SET XACT_ABORT ON  

IF EXISTS (SELECT Name FROM scom.Agent WHERE (Name = @Name AND [AgentID] != @AgentID))
BEGIN
	DELETE 
	FROM scom.Agent 
	WHERE Name = @Name
END

BEGIN TRAN

	MERGE [scom].[Agent] AS target
	USING (SELECT @AgentID
           ,@Name
           ,@DisplayName
           ,@Domain
           ,@ManagementGroup
           ,@PrimaryManagementServer
           ,@Version
           ,@PatchList
           ,@ComputerName
           ,@HealthState
           ,@InstalledBy
           ,@InstallTime
           ,@ManuallyInstalled
           ,@ProxyingEnabled
           ,@IPAddress
           ,@LastModified
		   ,@Active
		   ,@dbLastUpdate
		   ,@dbLastUpdate) AS Source

	(	    [AgentID]
           ,[Name]
           ,[DisplayName]
           ,[Domain]
           ,[ManagementGroup]
           ,[PrimaryManagementServer]
           ,[Version]
           ,[PatchList]
           ,[ComputerName]
           ,[HealthState]
           ,[InstalledBy]
           ,[InstallTime]
           ,[ManuallyInstalled]
           ,[ProxyingEnabled]
           ,[IPAddress]
           ,[LastModified]
           ,[Active]
           ,[dbAddDate]
           ,[dbLastUpdate]) 
	ON (target.[AgentID] = @AgentID)

	WHEN MATCHED THEN
		UPDATE 
		   SET [Name] = @Name
			  ,[DisplayName] = @DisplayName
			  ,[Domain] = @Domain
			  ,[ManagementGroup] = @ManagementGroup
			  ,[PrimaryManagementServer] = @PrimaryManagementServer
			  ,[Version] = @Version
			  ,[PatchList] = @PatchList
			  ,[ComputerName] = @ComputerName
			  ,[HealthState] = @HealthState
			  ,[InstalledBy] = @InstalledBy
			  ,[InstallTime] = @InstallTime
			  ,[ManuallyInstalled] = @ManuallyInstalled
			  ,[ProxyingEnabled] = @ProxyingEnabled
			  ,[IPAddress] = @IPAddress
			  ,[LastModified] = @LastModified
			  ,[Active] = 1
			  ,[dbLastUpdate] = @dbLastUpdate

	WHEN NOT MATCHED THEN
		INSERT 	   ([AgentID]
				   ,[Name]
				   ,[DisplayName]
				   ,[Domain]
				   ,[ManagementGroup]
				   ,[PrimaryManagementServer]
				   ,[Version]
				   ,[PatchList]
				   ,[ComputerName]
				   ,[HealthState]
				   ,[InstalledBy]
				   ,[InstallTime]
				   ,[ManuallyInstalled]
				   ,[ProxyingEnabled]
				   ,[IPAddress]
				   ,[LastModified]
				   ,[Active]
				   ,[dbAddDate]
				   ,[dbLastUpdate])
			 VALUES
				   (@AgentID
				   ,@Name
				   ,@DisplayName
				   ,@Domain
				   ,@ManagementGroup
				   ,@PrimaryManagementServer
				   ,@Version
				   ,@PatchList
				   ,@ComputerName
				   ,@HealthState
				   ,@InstalledBy
				   ,@InstallTime
				   ,@ManuallyInstalled
				   ,@ProxyingEnabled
				   ,@IPAddress
				   ,@LastModified
				   ,1
				   ,@dbLastUpdate
				   ,@dbLastUpdate)
			;
COMMIT
GO
/****** Object:  StoredProcedure [scom].[spAlertDeleteInactive]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertDeleteInactive
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [scom].[spAlertDeleteInactive]

AS

DELETE 
FROM scom.Alert
WHERE Active = 0
GO
/****** Object:  StoredProcedure [scom].[spAlertInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertInactivate]

AS

UPDATE scom.Alert
SET [Active] = 0
GO
/****** Object:  StoredProcedure [scom].[spAlertInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertInactivateByDate]
	@BeforeDate datetime2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) AND Active = 1
GO
/****** Object:  StoredProcedure [scom].[spAlertResolutionStateUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertResolutionStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [scom].[spAlertResolutionStateUpsert] (
	@ResolutionStateID uniqueidentifier,
	@ResolutionState tinyint,
	@Name nvarchar(255),
	@IsSystem bit,
	@ManagementGroup nvarchar(255),
	@Active bit,
	@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON 
SET XACT_ABORT ON  

IF EXISTS (SELECT Name FROM scom.AlertResolutionState WHERE ResolutionState = @ResolutionState AND ResolutionStateID != @ResolutionStateID)
BEGIN
	DELETE 
	FROM scom.AlertResolutionState 
	WHERE ResolutionStateID = @ResolutionStateID
END

BEGIN TRAN

MERGE [scom].[AlertResolutionState] AS [target]
USING 
           (SELECT @ResolutionStateID
           ,@ResolutionState
           ,@Name
           ,@IsSystem
           ,@ManagementGroup
           ,@Active
           ,@dbLastUpdate) AS [source]

           ([ResolutionStateID]
           ,[ResolutionState]
           ,[Name]
           ,[IsSystem]
           ,[ManagementGroup]
           ,[Active]
           ,[dbLastUpdate])

	ON ( [target].[ResolutionStateID] = @ResolutionStateID)

	WHEN MATCHED THEN

		UPDATE 
		   SET [ResolutionStateID] = @ResolutionStateID
			  ,[ResolutionState] = @ResolutionState
			  ,[Name] = @Name
			  ,[IsSystem] = @IsSystem
			  ,[ManagementGroup] = @ManagementGroup
			  ,[Active] = @Active
			  ,[dbLastUpdate] = @dbLastUpdate

	WHEN NOT MATCHED THEN

INSERT 
           ([ResolutionStateID]
           ,[ResolutionState]
           ,[Name]
           ,[IsSystem]
           ,[ManagementGroup]
           ,[Active]
		   ,[dbAddDate]
           ,[dbLastUpdate])
     VALUES
           (@ResolutionStateID
           ,@ResolutionState
           ,@Name
           ,@IsSystem
           ,@ManagementGroup
           ,@Active
		   ,@dbLastUpdate
           ,@dbLastUpdate)

	;
COMMIT
GO
/****** Object:  StoredProcedure [scom].[spAlertUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [scom].[spAlertUpsert] (
	@AlertId uniqueidentifier, 
	@Name nvarchar(255), 
	@Description nvarchar(2000), 
	@MonitoringObjectId uniqueidentifier, 
	@MonitoringClassId uniqueidentifier, 
	@MonitoringObjectDisplayName ntext, 
	@MonitoringObjectName ntext, 
	@MonitoringObjectPath nvarchar(max), 
	@MonitoringObjectFullName ntext, 
	@IsMonitorAlert bit, 
	@ProblemId uniqueidentifier, 
	@MonitoringRuleId uniqueidentifier, 
	@ResolutionState tinyint, 
	@ResolutionStateName nvarchar(50), 
	@Priority tinyint, 
	@Severity tinyint, 
	@Category nvarchar(255), 
	@Owner nvarchar(255), 
	@ResolvedBy nvarchar(255), 
	@TimeRaised datetime2(3), 
	@TimeAdded datetime2(3), 
	@LastModified datetime2(3), 
	@LastModifiedBy nvarchar(255), 
	@TimeResolved datetime2(3), 
	@TimeResolutionStateLastModified datetime2(3), 
	@CustomField1 nvarchar(255), 
	@CustomField2 nvarchar(255), 
	@CustomField3 nvarchar(255), 
	@CustomField4 nvarchar(255), 
	@CustomField5 nvarchar(255), 
	@CustomField6 nvarchar(255), 
	@CustomField7 nvarchar(255), 
	@CustomField8 nvarchar(255), 
	@CustomField9 nvarchar(255), 
	@CustomField10 nvarchar(255), 
	@TicketId nvarchar(150), 
	@Context ntext, 
	@ConnectorID uniqueidentifier, 
	@LastModifiedByNonConnector datetime2(3), 
	@MonitoringObjectInMaintenanceMode bit, 
	@MaintenanceModeLastModified datetime2(3), 
	@MonitoringObjectHealthState tinyint, 
	@StateLastModified datetime2(3), 
	@ConnectorStatus int, 
	@TopLevelHostEntityId uniqueidentifier, 
	@RepeatCount int, 
	@AlertStringId uniqueidentifier, 
	@AlertStringName nvarchar(max), 
	@LanguageCode nvarchar(3), 
	@AlertStringDescription ntext, 
	@AlertParams ntext, 
	@SiteName nvarchar(255), 
	@TfsWorkItemId nvarchar(150), 
	@TfsWorkItemOwner nvarchar(255), 
	@HostID int, 
	@Active bit, 
	@dbLastUpdate datetime2(3)
)

AS 

SET NOCOUNT ON 
SET XACT_ABORT ON  



BEGIN TRAN

	MERGE scom.Alert as [target]
	USING (SELECT @AlertId
           ,@Name
           ,@Description
           ,@MonitoringObjectID
           ,@MonitoringClassID
           ,@MonitoringObjectDisplayName
           ,@MonitoringObjectName
           ,@MonitoringObjectPath
           ,@MonitoringObjectFullName
           ,@IsMonitorAlert
           ,@ProblemID
           ,@MonitoringRuleID
           ,@ResolutionState
           ,@ResolutionStateName
           ,@Priority
           ,@Severity
           ,@Category
           ,@Owner
           ,@ResolvedBy
           ,@TimeRaised
           ,@TimeAdded
           ,@LastModified
           ,@LastModifiedBy
           ,@TimeResolved
           ,@TimeResolutionStateLastModified
           ,@CustomField1
           ,@CustomField2
           ,@CustomField3
           ,@CustomField4
           ,@CustomField5
           ,@CustomField6
           ,@CustomField7
           ,@CustomField8
           ,@CustomField9
           ,@CustomField10
           ,@TicketId
           ,@Context
           ,@ConnectorID
           ,@LastModifiedByNonConnector
           ,@MonitoringObjectInMaintenanceMode
           ,@MaintenanceModeLastModified
           ,@MonitoringObjectHealthState
           ,@StateLastModified
           ,@ConnectorStatus
           ,@TopLevelHostEntityId
           ,@RepeatCount
           ,@AlertStringID
           ,@AlertStringName
           ,@LanguageCode
           ,@AlertStringDescription
           ,@AlertParams
           ,@SiteName
           ,@TfsWorkItemId
           ,@TfsWorkItemOwner
           ,@HostID
           ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate) AS [source]

	([AlertId]
           ,[Name]
           ,[Description]
           ,[MonitoringObjectId]
           ,[MonitoringClassId]
           ,[MonitoringObjectDisplayName]
           ,[MonitoringObjectName]
           ,[MonitoringObjectPath]
           ,[MonitoringObjectFullName]
           ,[IsMonitorAlert]
           ,[ProblemId]
           ,[MonitoringRuleId]
           ,[ResolutionState]
           ,[ResolutionStateName]
           ,[Priority]
           ,[Severity]
           ,[Category]
           ,[Owner]
           ,[ResolvedBy]
           ,[TimeRaised]
           ,[TimeAdded]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[TimeResolved]
           ,[TimeResolutionStateLastModified]
           ,[CustomField1]
           ,[CustomField2]
           ,[CustomField3]
           ,[CustomField4]
           ,[CustomField5]
           ,[CustomField6]
           ,[CustomField7]
           ,[CustomField8]
           ,[CustomField9]
           ,[CustomField10]
           ,[TicketId]
           ,[Context]
           ,[ConnectorID]
           ,[LastModifiedByNonConnector]
           ,[MonitoringObjectInMaintenanceMode]
           ,[MaintenanceModeLastModified]
           ,[MonitoringObjectHealthState]
           ,[StateLastModified]
           ,[ConnectorStatus]
           ,[TopLevelHostEntityId]
           ,[RepeatCount]
           ,[AlertStringId]
           ,[AlertStringName]
           ,[LanguageCode]
           ,[AlertStringDescription]
           ,[AlertParams]
           ,[SiteName]
           ,[TfsWorkItemId]
           ,[TfsWorkItemOwner]
           ,[HostID]
           ,[Active]
           ,[dbAddDate]
           ,[dbLastUpdate])

		   ON ([target].[AlertID] = @AlertId)

		WHEN MATCHED THEN

			UPDATE 
			   SET [AlertId] = @AlertId
				  ,[Name] = @Name
				  ,[Description] = @Description
				  ,[MonitoringObjectId] = @MonitoringObjectID
				  ,[MonitoringClassId] = @MonitoringClassID
				  ,[MonitoringObjectDisplayName] = @MonitoringObjectDisplayName
				  ,[MonitoringObjectName] = @MonitoringObjectName
				  ,[MonitoringObjectPath] = @MonitoringObjectPath
				  ,[MonitoringObjectFullName] = @MonitoringObjectFullName
				  ,[IsMonitorAlert] = @IsMonitorAlert
				  ,[ProblemId] = @ProblemID
				  ,[MonitoringRuleId] = @MonitoringRuleID
				  ,[ResolutionState] = @ResolutionState
				  ,[ResolutionStateName] = @ResolutionStateName
				  ,[Priority] = @Priority
				  ,[Severity] = @Severity
				  ,[Category] = @Category
				  ,[Owner] = @Owner
				  ,[ResolvedBy] = @ResolvedBy
				  ,[TimeRaised] = @TimeRaised
				  ,[TimeAdded] = @TimeAdded
				  ,[LastModified] = @LastModified
				  ,[LastModifiedBy] = @LastModifiedBy
				  ,[TimeResolved] = @TimeResolved
				  ,[TimeResolutionStateLastModified] = @TimeResolutionStateLastModified
				  ,[CustomField1] = @CustomField1
				  ,[CustomField2] = @CustomField2
				  ,[CustomField3] = @CustomField3
				  ,[CustomField4] = @CustomField4
				  ,[CustomField5] = @CustomField5
				  ,[CustomField6] = @CustomField6
				  ,[CustomField7] = @CustomField7
				  ,[CustomField8] = @CustomField8
				  ,[CustomField9] = @CustomField9
				  ,[CustomField10] = @CustomField10
				  ,[TicketId] = @TicketID
				  ,[Context] = @Context
				  ,[ConnectorID] = @ConnectorID
				  ,[LastModifiedByNonConnector] = @LastModifiedByNonConnector
				  ,[MonitoringObjectInMaintenanceMode] = @MonitoringObjectInMaintenanceMode
				  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
				  ,[MonitoringObjectHealthState] = @MonitoringObjectHealthState
				  ,[StateLastModified] = @StateLastModified
				  ,[ConnectorStatus] = @ConnectorStatus
				  ,[TopLevelHostEntityId] = @TopLevelHostEntityId
				  ,[RepeatCount] = @RepeatCount
				  ,[AlertStringId] = @AlertStringID
				  ,[AlertStringName] = @AlertStringName
				  ,[LanguageCode] = @LanguageCode
				  ,[AlertStringDescription] = @AlertStringDescription
				  ,[AlertParams] = @AlertParams
				  ,[SiteName] = @SiteName
				  ,[TfsWorkItemId] = @TfsWorkItemID
				  ,[TfsWorkItemOwner] = @TfsWorkItemOwner
				  ,[HostID] = @HostID
				  ,[Active] = @Active
				  ,[dbLastUpdate] = @dbLastUpdate

		WHEN NOT MATCHED THEN

		INSERT 
				   ([AlertId]
				   ,[Name]
				   ,[Description]
				   ,[MonitoringObjectId]
				   ,[MonitoringClassId]
				   ,[MonitoringObjectDisplayName]
				   ,[MonitoringObjectName]
				   ,[MonitoringObjectPath]
				   ,[MonitoringObjectFullName]
				   ,[IsMonitorAlert]
				   ,[ProblemId]
				   ,[MonitoringRuleId]
				   ,[ResolutionState]
				   ,[ResolutionStateName]
				   ,[Priority]
				   ,[Severity]
				   ,[Category]
				   ,[Owner]
				   ,[ResolvedBy]
				   ,[TimeRaised]
				   ,[TimeAdded]
				   ,[LastModified]
				   ,[LastModifiedBy]
				   ,[TimeResolved]
				   ,[TimeResolutionStateLastModified]
				   ,[CustomField1]
				   ,[CustomField2]
				   ,[CustomField3]
				   ,[CustomField4]
				   ,[CustomField5]
				   ,[CustomField6]
				   ,[CustomField7]
				   ,[CustomField8]
				   ,[CustomField9]
				   ,[CustomField10]
				   ,[TicketId]
				   ,[Context]
				   ,[ConnectorID]
				   ,[LastModifiedByNonConnector]
				   ,[MonitoringObjectInMaintenanceMode]
				   ,[MaintenanceModeLastModified]
				   ,[MonitoringObjectHealthState]
				   ,[StateLastModified]
				   ,[ConnectorStatus]
				   ,[TopLevelHostEntityId]
				   ,[RepeatCount]
				   ,[AlertStringId]
				   ,[AlertStringName]
				   ,[LanguageCode]
				   ,[AlertStringDescription]
				   ,[AlertParams]
				   ,[SiteName]
				   ,[TfsWorkItemId]
				   ,[TfsWorkItemOwner]
				   ,[HostID]
				   ,[Active]
				   ,[dbAddDate]
				   ,[dbLastUpdate])
			 VALUES
				   (@AlertID
				   ,@Name
				   ,@Description
				   ,@MonitoringObjectID
				   ,@MonitoringClassID
				   ,@MonitoringObjectDisplayName
				   ,@MonitoringObjectName
				   ,@MonitoringObjectPath
				   ,@MonitoringObjectFullName
				   ,@IsMonitorAlert
				   ,@ProblemID
				   ,@MonitoringRuleID
				   ,@ResolutionState
				   ,@ResolutionStateName
				   ,@Priority
				   ,@Severity
				   ,@Category
				   ,@Owner
				   ,@ResolvedBy
				   ,@TimeRaised
				   ,@TimeAdded
				   ,@LastModified
				   ,@LastModifiedBy
				   ,@TimeResolved
				   ,@TimeResolutionStateLastModified
				   ,@CustomField1
				   ,@CustomField2
				   ,@CustomField3
				   ,@CustomField4
				   ,@CustomField5
				   ,@CustomField6
				   ,@CustomField7
				   ,@CustomField8
				   ,@CustomField9
				   ,@CustomField10
				   ,@TicketID
				   ,@Context
				   ,@ConnectorID
				   ,@LastModifiedByNonConnector
				   ,@MonitoringObjectInMaintenanceMode
				   ,@MaintenanceModeLastModified
				   ,@MonitoringObjectHealthState
				   ,@StateLastModified
				   ,@ConnectorStatus
				   ,@TopLevelHostEntityId
				   ,@RepeatCount
				   ,@AlertStringID
				   ,@AlertStringName
				   ,@LanguageCode
				   ,@AlertStringDescription
				   ,@AlertParams
				   ,@SiteName
				   ,@TfsWorkItemID
				   ,@TfsWorkItemOwner
				   ,@HostID
				   ,@Active
				   ,@dbLastUpdate
				   ,@dbLastUpdate)

			;

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spGroupHealthStateAlertRelationshipInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spGroupHealthStateAlertRelationshipInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateAlertRelationshipInactivate] 

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

update scom.[GroupHealthStateAlertRelationship]
Set Active = b.Active
FROM scom.[GroupHealthStateAlertRelationship] inner join scom.Alert b
	on scom.[GroupHealthStateAlertRelationship].AlertID = b.AlertId

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spGroupHealthStateAlertRelationshipInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spGroupHealthStateAlertRelationshipInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateAlertRelationshipInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

UPDATE [scom].[GroupHealthStateAlertRelationship]
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate)
	AND Active = 1

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spGroupHealthStateAlertRelationshipUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spGroupHealthStateAlertRelationshipUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateAlertRelationshipUpsert] (
	@GroupID UNIQUEIDENTIFIER,
	@AlertID UNIQUEIDENTIFIER
)
AS
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	IF EXISTS (SELECT 1 FROM scom.[GroupHealthStateAlertRelationship] WHERE GroupID = @GroupID AND AlertID = @AlertID)
	BEGIN

		UPDATE scom.[GroupHealthStateAlertRelationship] 
		SET Active = 1, dbLastUpdate = GetDate()
		WHERE GroupID = @GroupID AND AlertID = @AlertID

	END

	ELSE

	BEGIN

		INSERT INTO scom.[GroupHealthStateAlertRelationship] (GroupID, AlertID, Active, dbAddDate, dbLastUpdate)
		VALUES (@GroupID, @AlertID, 1, GetDate(), GetDate())

	END
GO
/****** Object:  StoredProcedure [scom].[spGroupHealthStateInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spGroupHealthStateInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE [scom].[GroupHealthState]
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE,-15,@BeforeDate)
	AND Active = 1

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spGroupHealthStateUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spGroupHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spGroupHealthStateUpsert]
	@ID uniqueidentifier,
	@Name nvarchar(255),
	@DisplayName nvarchar(255),
	@FullName nvarchar(255),
	@Path nvarchar(1024) = Null,
	@MonitoringClassIds nvarchar(1024),
	@HealthState nvarchar(255) = N'',
	@StateLastModified datetime2(3) = Null,
	@IsAvailable bit = Null,
	@AvailabilityLastModified datetime2(3) = Null,
	@InMaintenanceMode bit = Null,
	@MaintenanceModeLastModified datetime2(3) = Null,
	@ManagementGroup nvarchar(255),
	@Active bit,
	@dbLastUpdate datetime2(3),
	@Availability nvarchar(255),
	@Configuration nvarchar(255),
	@Performance nvarchar(255),
	@Security nvarchar(255),
	@Other nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT FullName FROM scom.[ObjectHealthState] WHERE (FullName = @FullName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[GroupHealthState] as [target]
	USING (SELECT 	
		@ID ,
		@Name,
		@DisplayName,
		@FullName,
		@Path,
		@MonitoringClassIds,
		@HealthState,
		@StateLastModified,
		@IsAvailable ,
		@AvailabilityLastModified,
		@InMaintenanceMode ,
		@MaintenanceModeLastModified,
		@ManagementGroup,
		@Active ,
		@dbLastUpdate ,
		@dbLastUpdate ,
		@Availability ,
		@Configuration ,
		@Performance , 
		@Security ,
		@Other	 ) as [Source]

		(ID,
		Name,
		DisplayName,
		FullName,
		[Path],
		MonitoringClassIds,
		HealthState,
		StateLastModified,
		IsAvailable,
		AvailabilityLastModified,
		InMaintenanceMode,
		MaintenanceModeLastModified,
		ManagementGroup,
		Active,
		dbAddDate,
		dbLastUpdate,
		[Availability],
		[Configuration],
		[Performance],
		[Security] ,
		[Other]) on ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
		  ,[Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[FullName] = @FullName
		  ,[Path] = @Path
		  ,[MonitoringClassIds] = @MonitoringClassIds
		  ,[HealthState] = @HealthState
		  ,[StateLastModified] = @StateLastModified
		  ,[IsAvailable] = @IsAvailable
		  ,[AvailabilityLastModified] = @AvailabilityLastModified
		  ,[InMaintenanceMode] = @InMaintenanceMode
		  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
		  ,[ManagementGroup] = @ManagementGroup
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate
		  ,[Availability] = @Availability
		  ,[Configuration] = @Configuration
		  ,[Performance] = @Performance
		  ,[Security] = @Security
		  ,[Other] = @Other

	WHEN NOT MATCHED
	THEN INSERT (
			ID,
			Name,
			DisplayName,
			FullName,
			[Path],
			MonitoringClassIds,
			HealthState,
			StateLastModified,
			IsAvailable,
			AvailabilityLastModified,
			InMaintenanceMode,
			MaintenanceModeLastModified,
			ManagementGroup,
			Display,
			Active,
			dbAddDate,
			dbLastUpdate,
			[Availability],
			[Configuration],
			[Performance],
			[Security] ,
			[Other])
		VALUES (
			@ID ,
			@Name,
			@DisplayName,
			@FullName,
			@Path,
			@MonitoringClassIds,
			@HealthState,
			@StateLastModified,
			@IsAvailable ,
			@AvailabilityLastModified,
			@InMaintenanceMode ,
			@MaintenanceModeLastModified,
			@ManagementGroup,
			0,
			@Active ,
			@dbLastUpdate,
			@dbLastUpdate,
			@Availability ,
			@Configuration ,
			@Performance , 
			@Security ,
			@Other
		)
	;
COMMIT
GO
/****** Object:  StoredProcedure [scom].[spObjectAvailabilityHistoryInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectAvailabilityHistoryInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectAvailabilityHistoryInsert]
(
   @ManagedEntityID uniqueidentifier
   , @FullName nvarchar(2048)
   , @DateTime datetime2(3)
   , @IntervalDurationMilliseconds INT
   , @InWhiteStateMilliseconds INT
   , @InGreenStateMilliseconds INT
   , @InYellowStateMilliseconds INT
   , @InRedStateMilliseconds INT
   , @InDisabledStateMilliseconds INT
   , @InPlannedMaintenanceMilliseconds INT
   , @InUnplannedMaintenanceMilliseconds INT
   , @HealthServiceUnavailableMilliseconds INT
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF NOT EXISTS(
	SELECT ManagedEntityID 
	FROM [scom].[ObjectAvailabilityHistory]
	WHERE [ManagedEntityID]= @ManagedEntityID AND [DateTime]= @DateTime)

BEGIN
      INSERT INTO [scom].[ObjectAvailabilityHistory]
                       ([ManagedEntityID]
                       ,[FullName]
                       ,[DateTime]
                       ,[IntervalDurationMilliseconds]
                       ,[InWhiteStateMilliseconds]
                       ,[InGreenStateMilliseconds]
                       ,[InYellowStateMilliseconds]
                       ,[InRedStateMilliseconds]
                       ,[InDisabledStateMilliseconds]
                       ,[InPlannedMaintenanceMilliseconds]
                       ,[InUnplannedMaintenanceMilliseconds]
                       ,[HealthServiceUnavailableMilliseconds])
             VALUES
                       (@ManagedEntityID
                       ,@FullName
                       ,@DateTime
                       ,@IntervalDurationMilliseconds
                       ,@InWhiteStateMilliseconds
                       ,@InGreenStateMilliseconds
                       ,@InYellowStateMilliseconds
                       ,@InRedStateMilliseconds
                       ,@InDisabledStateMilliseconds
                       ,@InPlannedMaintenanceMilliseconds
                       ,@InUnplannedMaintenanceMilliseconds
                       ,@HealthServiceUnavailableMilliseconds)
END
GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateAlertRelationshipInactivate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectAlertRelationshipInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateAlertRelationshipInactivate] 

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

update scom.[ObjectHealthStateAlertRelationship]
Set Active = b.Active
FROM scom.[ObjectHealthStateAlertRelationship] inner join scom.Alert b
	on scom.[ObjectHealthStateAlertRelationship].AlertID = b.AlertId

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateAlertRelationshipInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectAlertRelationshipInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateAlertRelationshipInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRAN

UPDATE scom.[ObjectHealthStateAlertRelationship]
SET Active = 0
WHERE dbLastUpdate < DateAdd(Minute, -15, @BeforeDate )
	AND Active = 1

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateAlertRelationshipUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectAlertRelationshipUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateAlertRelationshipUpsert] (
	@ObjectID uniqueidentifier,
	@AlertID uniqueidentifier
)
AS
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	IF EXISTS (SELECT 1 FROM scom.[ObjectHealthStateAlertRelationship] WHERE ObjectID = @ObjectID AND AlertID = @AlertID)
	BEGIN

		UPDATE scom.[ObjectHealthStateAlertRelationship] 
		SET Active = 1, dbLastUpdate = GetDate()
		WHERE ObjectID = @ObjectID AND AlertID = @AlertID

	END

	ELSE

	BEGIN

		INSERT INTO scom.[ObjectHealthStateAlertRelationship] (ObjectID, AlertID, Active, dbAddDate, dbLastUpdate)
		VALUES (@ObjectID, @AlertID, 1, GetDate(), GetDate())

	END
GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
* Inactivate objects that were not updated in the most recent pass.
* Used only during full sync.
* Modified to subtract 15 minutes from last update.
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateInactivateByDate] (
	@BeforeDate datetime2(3),
	@ObjectClass nvarchar(255)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.[ObjectHealthState]
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate)
	AND Active = 1
	AND ObjectClass = @ObjectClass

COMMIT

GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectHealthStateUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectHealthStateUpsert]
	@ID uniqueidentifier,
	@Name nvarchar(255),
	@DisplayName nvarchar(255),
	@FullName nvarchar(255),
	@Path nvarchar(1024) = Null,
	@ObjectClass nvarchar(255),
	@HealthState nvarchar(255) = N'',
	@StateLastModified datetime2(3) = Null,
	@IsAvailable bit = Null,
	@AvailabilityLastModified datetime2(3) = Null,
	@InMaintenanceMode bit = Null,
	@MaintenanceModeLastModified datetime2(3) = Null,
	@ManagementGroup nvarchar(255),
	@Active bit,
	@dbLastUpdate datetime2(3),
	@Availability nvarchar(255),
	@Configuration nvarchar(255),
	@Performance nvarchar(255),
	@Security nvarchar(255),
	@Other nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT FullName FROM scom.[ObjectHealthState] WHERE (FullName = @FullName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[ObjectHealthState] as [target]
	USING (SELECT 	
		@ID ,
		@Name,
		@DisplayName,
		@FullName,
		@Path,
		@ObjectClass,
		@HealthState,
		@StateLastModified,
		@IsAvailable ,
		@AvailabilityLastModified,
		@InMaintenanceMode ,
		@MaintenanceModeLastModified,
		@ManagementGroup,
		@Active ,
		@dbLastUpdate ,
		@dbLastUpdate ,
		@Availability ,
		@Configuration ,
		@Performance , 
		@Security ,
		@Other	 ) as [Source]

		(ID,
		Name,
		DisplayName,
		FullName,
		[Path],
		ObjectClass,
		HealthState,
		StateLastModified,
		IsAvailable,
		AvailabilityLastModified,
		InMaintenanceMode,
		MaintenanceModeLastModified,
		ManagementGroup,
		Active,
		dbAddDate,
		dbLastUpdate,
		[Availability],
		[Configuration],
		[Performance],
		[Security] ,
		[Other]) on ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
		  ,[Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[FullName] = @FullName
		  ,[Path] = @Path
		  ,[ObjectClass] = @ObjectClass
		  ,[HealthState] = @HealthState
		  ,[StateLastModified] = @StateLastModified
		  ,[IsAvailable] = @IsAvailable
		  ,[AvailabilityLastModified] = @AvailabilityLastModified
		  ,[InMaintenanceMode] = @InMaintenanceMode
		  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
		  ,[ManagementGroup] = @ManagementGroup
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate
		  ,[Availability] = @Availability
		  ,[Configuration] = @Configuration
		  ,[Performance] = @Performance
		  ,[Security] = @Security
		  ,[Other] = @Other

	WHEN NOT MATCHED
	THEN INSERT (
			ID,
			Name,
			DisplayName,
			FullName,
			[Path],
			ObjectClass,
			HealthState,
			StateLastModified,
			IsAvailable,
			AvailabilityLastModified,
			InMaintenanceMode,
			MaintenanceModeLastModified,
			ManagementGroup,
			Active,
			dbAddDate,
			dbLastUpdate,
			[Availability],
			[Configuration],
			[Performance],
			[Security] ,
			[Other])
		VALUES (
			@ID ,
			@Name,
			@DisplayName,
			@FullName,
			@Path,
			@ObjectClass,
			@HealthState,
			@StateLastModified,
			@IsAvailable ,
			@AvailabilityLastModified,
			@InMaintenanceMode ,
			@MaintenanceModeLastModified,
			@ManagementGroup,
			@Active ,
			@dbLastUpdate,
			@dbLastUpdate,
			@Availability ,
			@Configuration ,
			@Performance , 
			@Security ,
			@other
		)
	;
COMMIT


GO
/****** Object:  StoredProcedure [scom].[spSyncHistoryDeleteByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spSyncHistoryDeleteByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncHistoryDeleteByDate]
	@DaysRetain int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DELETE FROM [scom].[SyncHistory]
      WHERE [EndDate] < DATEADD(DAY, -@DaysRetain, GetDate())

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spSyncHistoryInsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************
* Name: scom.spSyncHistoryInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncHistoryInsert] 
    @ManagementGroup nvarchar(128),
    @ObjectClass nvarchar(128),
    @SyncType nvarchar(64),
    @StartDate datetime2(3) = NULL,
    @EndDate datetime2(3) = NULL,
    @Count int = NULL,
    @Status nvarchar(255) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN


	INSERT INTO scom.SyncHistory ([ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
	VALUES (@ManagementGroup, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [ad].[SyncHistory]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [scom].[spSyncHistorySelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spSyncHistorySelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncHistorySelect] 
    @ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [scom].[SyncHistory] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [scom].[spSyncStatusSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spSyncStatusSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncStatusSelect] 
    @ManagementGroup nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [scom].[SyncStatus] 
	WHERE  ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass) 

	COMMIT
GO
/****** Object:  StoredProcedure [scom].[spSyncStatusUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spSyncStatusUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncStatusUpsert] 
    @ManagementGroup nvarchar(128),
    @ObjectClass nvarchar(128),
    @SyncType nvarchar(64),
    @StartDate datetime2(3) = NULL,
    @EndDate datetime2(3) = NULL,
    @Count int = NULL,
    @Status nvarchar(128) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [scom].[SyncStatus] AS target
	USING (SELECT @SyncType, @StartDate, @EndDate, @Count, @Status) 
		AS source 
		([SyncType], [StartDate], [EndDate], [Count], [Status])
	-- !!!! Check the criteria for match
	ON ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SyncType] = @SyncType, [StartDate] = @StartDate, [EndDate] = @EndDate, [Count] = @Count, [Status] = @Status
	WHEN NOT MATCHED THEN
		INSERT ([ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
		VALUES (@ManagementGroup, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [scom].[SyncStatus]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
/****** Object:  StoredProcedure [scom].[spSyncStatusViewSelect]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spSyncStatusViewSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncStatusViewSelect] 
    @ManagementGroup nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ManagementGroup], [ObjectClass], [LastStatus], [LastSyncType], [LastStartDate], [LastFullSync], [LastIncrementalSync]
	FROM   [scom].[SyncStatusView] 
	WHERE  ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass) 

	COMMIT
GO
/****** Object:  StoredProcedure [scom].[spWindowsComputerInactivateByDate]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spWindowsComputerInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spWindowsComputerInactivateByDate] (
	@BeforeDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE scom.WindowsComputer
SET Active = 0
WHERE dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) AND Active = 1

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spWindowsComputerSelectByDNSHostName]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************
* Name: scom.spWindowsComputerSelectByDNSHostName
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spWindowsComputerSelectByDNSHostName] (
	@DNSHostName nvarchar(255)
)

AS

SELECT [ID]
      ,[DNSHostName]
      ,[IPAddress]
      ,[ObjectSID]
      ,[NetBIOSDomainName]
      ,[DomainDNSName]
      ,[OrganizationalUnit]
      ,[ForestDNSName]
      ,[ActiveDirectorySite]
      ,[IsVirtualMachine]
      ,[HealthState]
      ,[StateLastModified]
      ,[IsAvailable]
      ,[AvailabilityLastModified]
      ,[InMaintenanceMode]
      ,[MaintenanceModeLastModified]
      ,[ManagementGroup]
      ,[Active]
      ,[dbAddDate]
      ,[dbLastUpdate]
  FROM [scom].[WindowsComputer]
  WHERE [DNSHostName] = @DNSHostName
GO
/****** Object:  StoredProcedure [scom].[spWindowsComputerUpsert]    Script Date: 2/12/2019 10:38:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spWindowsComputerUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spWindowsComputerUpsert]
	@ID UNIQUEIDENTIFIER,
	@DNSHostName NVARCHAR(255),
	@IPAddress NVARCHAR(255) = N'',
	@ObjectSID NVARCHAR(255) = N'',
	@NetBIOSDomainName NVARCHAR(255) = N'',
	@DomainDNSName NVARCHAR(255) = N'',
	@OrganizationalUnit NVARCHAR(2048) = N'',
	@ForestDNSName NVARCHAR(255) = N'',
	@ActiveDirectorySite NVARCHAR(255) = N'',
	@IsVirtualMachine BIT = NULL,
	@HealthState NVARCHAR(255) = N'',
	@StateLastModified DATETIME2(3) = NULL,
	@IsAvailable BIT = NULL,
	@AvailabilityLastModified DATETIME2(3) = NULL,
	@InMaintenanceMode BIT = NULL,
	@MaintenanceModeLastModified DATETIME2(3) = NULL,
	@ManagementGroup NVARCHAR(255) = NULL,
	@Active BIT,
	@dbLastUpdate DATETIME2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT DNSHostName FROM scom.WindowsComputer WHERE (DNSHostName = @DNSHostName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.WindowsComputer
	WHERE DNSHostName = @DNSHostName
END

BEGIN TRAN

	MERGE [scom].[WindowsComputer] AS [target]
	USING (SELECT 	
		@ID ,
		@DNSHostName,
		@IPAddress,
		@ObjectSID,
		@NetBIOSDomainName,
		@DomainDNSName,
		@OrganizationalUnit,
		@ForestDNSName,
		@ActiveDirectorySite,
		@IsVirtualMachine,
		@HealthState,
		@StateLastModified,
		@IsAvailable ,
		@AvailabilityLastModified,
		@InMaintenanceMode ,
		@MaintenanceModeLastModified,
		@ManagementGroup,
		@Active ,
		@dbLastUpdate ,
		@dbLastUpdate ) AS [Source]

		(ID,
		DNSHostName,
		IPAddress,
		ObjectSID,
		NetBIOSDomainName,
		DomainDNSName,
		OrganizationalUnit,
		ForestDNSName,
		ActiveDirectorySite,
		IsVirtualMachine,
		HealthState,
		StateLastModified,
		IsAvailable,
		AvailabilityLastModified,
		InMaintenanceMode,
		MaintenanceModeLastModified,
		ManagementGroup,
		Active,
		dbAddDate,
		dbLastUpdate) ON ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
		  ,[DNSHostName] = @DNSHostName
		  ,[IPAddress] = @IPAddress
		  ,[ObjectSID] = @ObjectSID
		  ,[NetBIOSDomainName] = @NetBIOSDomainName
		  ,[DomainDNSName] = @DomainDNSName
		  ,[OrganizationalUnit] = @OrganizationalUnit
		  ,[ForestDNSName] = @ForestDNSName
		  ,[ActiveDirectorySite] = @ActiveDirectorySite
		  ,[IsVirtualMachine] = @IsVirtualMachine
		  ,[HealthState] = @HealthState
		  ,[StateLastModified] = @StateLastModified
		  ,[IsAvailable] = @IsAvailable
		  ,[AvailabilityLastModified] = @AvailabilityLastModified
		  ,[InMaintenanceMode] = @InMaintenanceMode
		  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
		  ,[ManagementGroup] = @ManagementGroup
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate

	WHEN NOT MATCHED
	THEN INSERT (
			ID,
			DNSHostName,
			IPAddress,
			ObjectSID,
			NetBIOSDomainName,
			DomainDNSName,
			OrganizationalUnit,
			ForestDNSName,
			ActiveDirectorySite,
			IsVirtualMachine,
			HealthState,
			StateLastModified,
			IsAvailable,
			AvailabilityLastModified,
			InMaintenanceMode,
			MaintenanceModeLastModified,
			ManagementGroup,
			Active,
			dbAddDate,
			dbLastUpdate)
		VALUES (
			@ID ,
			@DNSHostName,
			@IPAddress,
			@ObjectSID,
			@NetBIOSDomainName,
			@DomainDNSName,
			@OrganizationalUnit,
			@ForestDNSName,
			@ActiveDirectorySite,
			@IsVirtualMachine,
			@HealthState,
			@StateLastModified,
			@IsAvailable ,
			@AvailabilityLastModified,
			@InMaintenanceMode ,
			@MaintenanceModeLastModified,
			@ManagementGroup,
			@Active ,
			@dbLastUpdate,
			@dbLastUpdate
		)
	;
COMMIT
GO

/****************************************************************
* Name: scom.spObjectClassUpsert
* Author: huscott
* Date: 2019-03-05
*
* Description:
*
****************************************************************/
CREATE PROC scom.spObjectClassUpsert
(
	@ID nvarchar(255)
	,@Name nvarchar(255)
	,@DisplayName nvarchar(255)
	,@GenericName nvarchar(255)
	,@ManagementPackName nvarchar(255)
	,@Description nvarchar(1024)
	,@DistributedApplication bit
	,@Active bit
	,@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT Name FROM scom.[ObjectClass] WHERE (Name = @Name AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectClass]
	WHERE [Name] = @Name
END

IF EXISTS (SELECT ID FROM scom.[ObjectClass] WHERE ([ID] = @ID))
BEGIN

	UPDATE [scom].[ObjectClass]
	   SET [Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[GenericName] = @GenericName
		  ,[ManagementPackName] = @ManagementPackName
		  ,[Description] = @Description
		  ,[DistributedApplication] = @DistributedApplication
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate
	 WHERE 
		[ID] = @ID
END

ELSE

BEGIN

	INSERT INTO [scom].[ObjectClass]
			   ([ID]
			   ,[Name]
			   ,[DisplayName]
			   ,[GenericName]
			   ,[ManagementPackName]
			   ,[Description]
			   ,[DistributedApplication]
			   ,[Active]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@ID
			   ,@Name
			   ,@DisplayName
			   ,@GenericName
			   ,@ManagementPackName
			   ,@Description
			   ,@DistributedApplication
			   ,@Active
			   ,@dbLastUpdate
			   ,@dbLastUpdate)
END
GO

ALTER DATABASE [SCORE] SET  READ_WRITE 
GO
