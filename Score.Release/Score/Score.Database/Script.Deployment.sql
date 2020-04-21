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
/****** Object:  Database [SCORE]    Script Date: 3/14/2019 12:05:58 PM ******/
CREATE DATABASE [SCORE]
 CONTAINMENT = NONE
GO

/****** Object:  Database [SCORE]    Script Date: 4/21/2020 4:47:20 PM ******/

USE [SCORE]
GO
/****** Object:  DatabaseRole [scomUpdate]    Script Date: 4/21/2020 4:47:20 PM ******/
CREATE ROLE [scomUpdate]
GO
/****** Object:  DatabaseRole [scomRead]    Script Date: 4/21/2020 4:47:20 PM ******/
CREATE ROLE [scomRead]
GO
/****** Object:  DatabaseRole [adUpdate]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE ROLE [adUpdate]
GO
/****** Object:  DatabaseRole [adRead]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE ROLE [adRead]
GO
/****** Object:  Schema [ad]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE SCHEMA [ad]
GO
/****** Object:  Schema [scom]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE SCHEMA [scom]
GO
/****** Object:  Table [scom].[SyncHistory]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [scom].[SyncStatus]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  View [scom].[SyncStatusView]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





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
/****** Object:  Table [ad].[SyncStatus]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [ad].[SyncHistory]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  View [ad].[SyncStatusView]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



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
/****** Object:  Table [ad].[Computer]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [ad].[User]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [ad].[GroupMember]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_GroupMember] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Group]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  View [ad].[GroupMemberView]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
/****** Object:  Table [ad].[ComputerImport]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
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
/****** Object:  Table [ad].[DeletedObject]    Script Date: 4/21/2020 4:47:21 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Domain]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [ad].[Forest]    Script Date: 4/21/2020 4:47:21 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ad].[Site]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [ad].[Subnet]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [dbo].[Computer]    Script Date: 4/21/2020 4:47:21 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Config]    Script Date: 4/21/2020 4:47:21 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credential]    Script Date: 4/21/2020 4:47:21 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcessLog]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Severity] [nvarchar](50) NOT NULL,
	[Process] [nvarchar](50) NOT NULL,
	[Object] [nvarchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[MessageDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ProcessLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportContent]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [dbo].[ReportHeader]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [dbo].[SystemTimeZone]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	[Display] [bit] NOT NULL,
	[DefaultTimeZone] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_SystemTimeZone] PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[Agent]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	[InstallTime] [datetimeoffset](3) NOT NULL,
	[ManuallyInstalled] [bit] NOT NULL,
	[ProxyingEnabled] [bit] NOT NULL,
	[IPAddress] [nvarchar](1024) NULL,
	[LastModified] [datetimeoffset](3) NOT NULL,
	[IsAvailable] [bit] NULL,
	[AvailabilityLastModified] [datetimeoffset](3) NULL,
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
/****** Object:  Index [IX_scom_Agent_Name]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE CLUSTERED INDEX [IX_scom_Agent_Name] ON [scom].[Agent]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[AgentExclusions]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
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
/****** Object:  Table [scom].[Alert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
	[ManagementGroup] [nvarchar](255) NULL,
 CONSTRAINT [PK_scom_Alert] PRIMARY KEY CLUSTERED 
(
	[AlertId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [scom].[AlertAgingBuckets]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [scom].[AlertArchive]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[AlertArchive](
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
	[dbLastUpdate] [datetime2](3) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [scom].[AlertResolutionState]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	[IsOpen] [bit] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ResolutionStateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scom].[GroupHealthState]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	[Display] [bit] NOT NULL,
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
/****** Object:  Index [UX_scom_GroupHealthState_FullName]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_GroupHealthState_FullName] ON [scom].[GroupHealthState]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[GroupHealthStateAlertRelationship]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [scom].[MaintenanceReasonCode]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
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
/****** Object:  Table [scom].[ObjectAvailabilityHistory]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  Table [scom].[ObjectClass]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
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
/****** Object:  Index [UX_scom_ObjectClass_Name]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_ObjectClass_Name] ON [scom].[ObjectClass]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[ObjectHealthState]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
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
	[AssetStatus] [nvarchar](255) NULL,
	[Notes] [nvarchar](4000) NULL,
 CONSTRAINT [PK_scom_Object] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_scom_Object_FullName]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_Object_FullName] ON [scom].[ObjectHealthState]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Table [scom].[ObjectHealthStateAlertRelationShip]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectHealthStateAlertRelationShip](
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
/****** Object:  Table [scom].[WindowsComputer]    Script Date: 4/21/2020 4:47:21 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Computer_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Computer_Unique] ON [ad].[Computer]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Domain_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Domain_Unique] ON [ad].[Domain]
(
	[DistinguishedName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Forest_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Forest_Unique] ON [ad].[Forest]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Group_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Group_Unique] ON [ad].[Group]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_GroupMember_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_GroupMember_Unique] ON [ad].[GroupMember]
(
	[Domain] ASC,
	[GroupGUID] ASC,
	[MemberGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Site_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Site_Unique] ON [ad].[Site]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Subnet_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Subnet_Unique] ON [ad].[Subnet]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_SyncStatus_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_SyncStatus_Unique] ON [ad].[SyncStatus]
(
	[Domain] ASC,
	[ObjectClass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_User_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_User_Unique] ON [ad].[User]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Computer_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Computer_Unique] ON [dbo].[Computer]
(
	[Domain] ASC,
	[dnsHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Config_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Config_Unique] ON [dbo].[Config]
(
	[ConfigName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Credential_Unique]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Credential_Unique] ON [dbo].[Credential]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [IXu_ReportContent]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE NONCLUSTERED INDEX [IXu_ReportContent] ON [dbo].[ReportContent]
(
	[ReportId] ASC,
	[SortSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IXu_ReportHeader]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IXu_ReportHeader] ON [dbo].[ReportHeader]
(
	[ReportName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_SystemTimeZone_ID]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_SystemTimeZone_ID] ON [dbo].[SystemTimeZone]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_Agent_Domain]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_scom_Agent_Domain] ON [scom].[Agent]
(
	[Domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_AgentExclusion_DNSHostName]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_scom_AgentExclusion_DNSHostName] ON [scom].[AgentExclusions]
(
	[DNSHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [IX_ObjectAvailabilityHistory]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ObjectAvailabilityHistory] ON [scom].[ObjectAvailabilityHistory]
(
	[ManagedEntityID] ASC,
	[DateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_WindowsComputer]    Script Date: 4/21/2020 4:47:21 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_scom_WindowsComputer] ON [scom].[WindowsComputer]
(
	[DNSHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Computer] ADD  CONSTRAINT [DF_Computer_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[Credential] ADD  CONSTRAINT [DF_Credential_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[ReportContent] ADD  CONSTRAINT [DF_ReportContent_dbAddDate]  DEFAULT (getdate()) FOR [dbAddDate]
GO
ALTER TABLE [dbo].[ReportContent] ADD  CONSTRAINT [DF_ReportCon_dbModDate]  DEFAULT (getdate()) FOR [dbModDate]
GO
ALTER TABLE [dbo].[ReportHeader] ADD  CONSTRAINT [DF_scom_ReportHeader_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[SystemTimeZone] ADD  CONSTRAINT [DF_SystemTimeZone_ZoneID]  DEFAULT (newid()) FOR [ZoneID]
GO
ALTER TABLE [scom].[AlertResolutionState] ADD  DEFAULT ((1)) FOR [IsOpen]
GO
ALTER TABLE [scom].[GroupHealthState] ADD  CONSTRAINT [DF_scom_GroupHealthState_Display]  DEFAULT ((0)) FOR [Display]
GO
ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD  CONSTRAINT [FK_ReportContent_ReportHeader] FOREIGN KEY([ReportId])
REFERENCES [dbo].[ReportHeader] ([Id])
GO
ALTER TABLE [dbo].[ReportContent] CHECK CONSTRAINT [FK_ReportContent_ReportHeader]
GO
ALTER TABLE [scom].[GroupHealthStateAlertRelationship]  WITH CHECK ADD  CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_Alert] FOREIGN KEY([AlertID])
REFERENCES [scom].[Alert] ([AlertId])
GO
ALTER TABLE [scom].[GroupHealthStateAlertRelationship] CHECK CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_Alert]
GO
ALTER TABLE [scom].[GroupHealthStateAlertRelationship]  WITH CHECK ADD  CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_GroupHealthState] FOREIGN KEY([GroupID])
REFERENCES [scom].[GroupHealthState] ([Id])
GO
ALTER TABLE [scom].[GroupHealthStateAlertRelationship] CHECK CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_GroupHealthState]
GO
ALTER TABLE [scom].[ObjectHealthStateAlertRelationShip]  WITH CHECK ADD  CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_Alert] FOREIGN KEY([AlertID])
REFERENCES [scom].[Alert] ([AlertId])
GO
ALTER TABLE [scom].[ObjectHealthStateAlertRelationShip] CHECK CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_Alert]
GO
ALTER TABLE [scom].[ObjectHealthStateAlertRelationShip]  WITH CHECK ADD  CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_ObjectHealthState] FOREIGN KEY([ObjectID])
REFERENCES [scom].[ObjectHealthState] ([ID])
GO
ALTER TABLE [scom].[ObjectHealthStateAlertRelationShip] CHECK CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_ObjectHealthState]
GO
/****** Object:  StoredProcedure [ad].[spComputerDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerDelete
* Author: huscott
* Date: 2015-02-24
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
/****** Object:  StoredProcedure [ad].[spComputerInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spComputerInactivate
* Author: huscott
* Date: 2015-02-24
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
/****** Object:  StoredProcedure [ad].[spComputerInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spComputerSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spComputerUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spComputerUpsert_Import]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	USING (SELECT [objectGUID], [SID], right(dnshostname, len(dnshostname) - (len(name)+1)) as [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [LastLogonDate] as LastLogon, [whenCreated], [whenChanged] 
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
/****** Object:  StoredProcedure [ad].[spDomainDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spDomainInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spDomainSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spDomainUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spForestDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spForestDelete
* Author: huscott
* Date: 2015-02-24
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
/****** Object:  StoredProcedure [ad].[spForestInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: ad.spForestInactivate
* Author: huscott
* Date: 2015-02-24
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
/****** Object:  StoredProcedure [ad].[spForestSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spForestUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupMemberDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByGroup]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByMember]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupMemberSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spGroupMemberUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spGroupSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spGroupUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSiteDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSiteInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSiteInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSiteSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spSiteUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSubnetDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSubnetInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSubnetInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSubnetSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spSubnetSelectBySubnet]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spSubnetUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSyncHistoryDeleteByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spSyncHistoryInsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSyncHistorySelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spSyncStatusSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spSyncStatusUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spSyncStatusViewSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spUserDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spUserInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spUserInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [ad].[spUserSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [ad].[spUserUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spComputerDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spComputerDelete
* Author: huscott
* Date: 2015-03-09
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
/****** Object:  StoredProcedure [dbo].[spComputerInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spComputerInactivate
* Author: huscott
* Date: 2015-03-09
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
/****** Object:  StoredProcedure [dbo].[spComputerReactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************
* Name: dbo.spComputerReactivate
* Author: huscott
* Date: 2015-03-09
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
/****** Object:  StoredProcedure [dbo].[spComputerSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[spComputerSelectByAgentName]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spComputerSelectByAgentName]
	@AgentName nvarchar(128) = NULL,
	@Active bit = 1

AS

SELECT [dnsHostName]
  FROM [dbo].[Computer]
 WHERE ([AgentName] = @AgentName OR @AgentName is NULL)
       AND [Active] >= @Active
GO
/****** Object:  StoredProcedure [dbo].[spComputerUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spComputerUpsert
* Author: huscott
* Date: 2015-03-09
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
/****** Object:  StoredProcedure [dbo].[spConfigDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spConfigDelete
* Author: huscott
* Date: 2015-03-11
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
/****** Object:  StoredProcedure [dbo].[spConfigSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[spConfigUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spConfigUpsert
* Author: huscott
* Date: 2015-03-11
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
/****** Object:  StoredProcedure [dbo].[spCredentialDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialDelete
* Author: huscott
* Date: 2015-03-30
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
/****** Object:  StoredProcedure [dbo].[spCredentialInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialInactivate
* Author: huscott
* Date: 2015-03-30
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
/****** Object:  StoredProcedure [dbo].[spCredentialSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[spCredentialUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCredentialUpsert
* Author: huscott
* Date: 2015-03-30
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
/****** Object:  StoredProcedure [dbo].[spCurrentTimeZoneOffsetUpdate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spCurrentTimeZoneOffsetUpdate
* Author: huscott
* Date: 2019-07-02
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [dbo].[spCurrentTimeZoneOffsetUpdate]

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
/****** Object:  StoredProcedure [dbo].[spProcessLogDelete]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[spProcessLogInsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: dbo.spProcessLogInsert
* Author: huscott
* Date: 2015-02-24
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
/****** Object:  StoredProcedure [dbo].[spProcessLogSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spReportContentSelectByReportID]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	  ,[ItemDisplay]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportID
  ORDER BY [SortSequence]
GO
/****** Object:  StoredProcedure [dbo].[spReportContentSelectByReportName]    Script Date: 4/21/2020 4:47:21 PM ******/
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

SELECT @ReportId = Id
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
	  ,[ItemDisplay]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportId
  ORDER BY [SortSequence]
GO
/****** Object:  StoredProcedure [dbo].[spReportContentSelectByReportNameAndSortSequence]    Script Date: 4/21/2020 4:47:21 PM ******/
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

DECLARE @ReportId uniqueidentifier

SELECT @ReportId = Id
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
	  ,[ItemDisplay]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportId
  AND [SortSequence] = @SortSequence
GO
/****** Object:  StoredProcedure [dbo].[spReportHeaderSelectByReportName]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spSystemTimeZoneSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[spSystemTimeZoneUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
* Modification History:
* 2019/02/25 - HMS - Set defaults for Display, DefaultTimeZone to 0 (false)
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
		   ,[Display]
		   ,[DefaultTimeZone]
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
		   ,0
		   ,0
		   ,@Active
           ,@dbLastUpdate
           ,@dbLastUpdate)

END
GO
/****** Object:  StoredProcedure [scom].[spAgentAvailabilityUpdate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@AvailabilityLastModified datetimeoffset(3)
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
/****** Object:  StoredProcedure [scom].[spAgentExclusionsInsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spAgentExclusionsUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
/****** Object:  StoredProcedure [scom].[spAgentInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spAgentUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@InstallTime DATETIMEOFFSET(3), 
	@ManuallyInstalled bit, 
	@ProxyingEnabled bit, 
	@IPAddress nvarchar(1024), 
	@LastModified datetimeoffset(3),
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
/****** Object:  StoredProcedure [scom].[spAlertDeleteInactive]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [scom].[spAlertDeleteInactive]

AS

DELETE 
FROM scom.Alert
WHERE Active = 0
GO
/****** Object:  StoredProcedure [scom].[spAlertInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@ManagementGroup nvarchar(255) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE
	[Active] = 1
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)
GO
/****** Object:  StoredProcedure [scom].[spAlertInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@BeforeDate datetime2(3),
	@ManagementGroup nvarchar(255) = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE scom.Alert
SET [Active] = 0
WHERE 
	dbLastUpdate < DATEADD(MINUTE, -15, @BeforeDate) 
	AND Active = 1
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)
GO
/****** Object:  StoredProcedure [scom].[spAlertResolutionStateGet]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spAlertResolutionStateGet
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spAlertResolutionStateGet]
	@ResolutionState INT = NULL,
	@IsOpen BIT = NULL

AS

SET NOCOUNT ON
SET XACT_ABORT OFF

SELECT 
	ResolutionState, [Name]
FROM 
	scom.AlertResolutionState
WHERE
	Active = 1
	AND (@ResolutionState IS NULL OR ResolutionState = @ResolutionState)
	AND (@IsOpen IS NULL OR IsOpen = @IsOpen)
ORDER BY
	ResolutionState
GO
/****** Object:  StoredProcedure [scom].[spAlertResolutionStateUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
/****** Object:  StoredProcedure [scom].[spAlertUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@CustomField4 NVARCHAR(255), 
	@CustomField5 NVARCHAR(255), 
	@CustomField6 NVARCHAR(255), 
	@CustomField7 NVARCHAR(255), 
	@CustomField8 NVARCHAR(255), 
	@CustomField9 NVARCHAR(255), 
	@CustomField10 NVARCHAR(255), 
	@TicketId NVARCHAR(150), 
	@Context NTEXT, 
	@ConnectorId UNIQUEIDENTIFIER, 
	@LastModifiedByNonConnector DATETIME2(3), 
	@MonitoringObjectInMaintenanceMode BIT, 
	@MaintenanceModeLastModified DATETIME2(3), 
	@MonitoringObjectHealthState TINYINT, 
	@StateLastModified DATETIME2(3), 
	@ConnectorStatus INT, 
	@TopLevelHostEntityId UNIQUEIDENTIFIER, 
	@RepeatCount INT, 
	@AlertStringId UNIQUEIDENTIFIER, 
	@AlertStringName NVARCHAR(MAX), 
	@LanguageCode NVARCHAR(3), 
	@AlertStringDescription NTEXT, 
	@AlertParams NTEXT, 
	@SiteName NVARCHAR(255), 
	@TfsWorkItemId NVARCHAR(150), 
	@TfsWorkItemOwner NVARCHAR(255), 
	@HostID INT, 
	@Active BIT, 
	@dbLastUpdate DATETIME2(3),
	@ManagementGroup nvarchar(255)
)

AS 

SET NOCOUNT ON 
SET XACT_ABORT ON  



BEGIN TRAN

	MERGE scom.Alert AS [target]
	USING (SELECT @AlertId
           ,@Name
           ,@Description
           ,@MonitoringObjectId
           ,@MonitoringClassId
           ,@MonitoringObjectDisplayName
           ,@MonitoringObjectName
           ,@MonitoringObjectPath
           ,@MonitoringObjectFullName
           ,@IsMonitorAlert
           ,@ProblemId
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
           ,@ConnectorId
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
           ,@dbLastUpdate
		   ,@ManagementGroup) AS [source]

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
           ,[ConnectorId]
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
           ,[dbLastUpdate]
		   ,[ManagementGroup])

		   ON ([target].[AlertId] = @AlertId)

		WHEN MATCHED THEN

			UPDATE 
			   SET [AlertId] = @AlertId
				  ,[Name] = @Name
				  ,[Description] = @Description
				  ,[MonitoringObjectId] = @MonitoringObjectId
				  ,[MonitoringClassId] = @MonitoringClassId
				  ,[MonitoringObjectDisplayName] = @MonitoringObjectDisplayName
				  ,[MonitoringObjectName] = @MonitoringObjectName
				  ,[MonitoringObjectPath] = @MonitoringObjectPath
				  ,[MonitoringObjectFullName] = @MonitoringObjectFullName
				  ,[IsMonitorAlert] = @IsMonitorAlert
				  ,[ProblemId] = @ProblemId
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
				  ,[ConnectorId] = @ConnectorId
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
				  ,[ManagementGroup] = @ManagementGroup

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
				   ,[ConnectorId]
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
				   ,[dbLastUpdate]
				   ,[ManagementGroup])
			 VALUES
				   (@AlertId
				   ,@Name
				   ,@Description
				   ,@MonitoringObjectId
				   ,@MonitoringClassID
				   ,@MonitoringObjectDisplayName
				   ,@MonitoringObjectName
				   ,@MonitoringObjectPath
				   ,@MonitoringObjectFullName
				   ,@IsMonitorAlert
				   ,@ProblemId
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
				   ,@ConnectorId
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
				   ,@dbLastUpdate
				   ,@ManagementGroup)

			;

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spGroupHealthStateAlertRelationshipInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spGroupHealthStateAlertRelationshipInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spGroupHealthStateAlertRelationshipUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spGroupHealthStateInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spGroupHealthStateUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@Id UNIQUEIDENTIFIER,
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

IF EXISTS (SELECT FullName FROM scom.[GroupHealthState] WHERE (FullName = @FullName AND [Id] != @Id))
BEGIN
	DELETE 
	FROM scom.[GroupHealthState]
	WHERE FullName = @FullName
END

BEGIN TRAN

	MERGE [scom].[GroupHealthState] AS [target]
	USING (SELECT 	
		@Id ,
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
		@Other	 ) AS [Source]

		(Id,
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
		[Other]) ON ([target].Id = @Id)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [Id] = @Id
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
			Id,
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
			@Id ,
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
			1,
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
/****** Object:  StoredProcedure [scom].[spObjectAvailabilityHistoryInsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
/****** Object:  StoredProcedure [scom].[spObjectClassUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************
* Name: scom.spObjectClassUpsert
* Author: huscott
* Date: 2019-03-05
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spObjectClassUpsert]
(
	@ID uniqueidentifier
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
/****** Object:  StoredProcedure [scom].[spObjectHealthStateAlertRelationshipInactivate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
SET Active = b.Active
FROM scom.[ObjectHealthStateAlertRelationship] inner join scom.Alert b
	ON scom.[ObjectHealthStateAlertRelationship].AlertID = b.AlertId

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateAlertRelationshipInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spObjectHealthStateAlertRelationshipUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spObjectHealthStateInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
	@ObjectClass nvarchar(255),
	@ManagementGroup nvarchar(255) = NULL
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
	AND (@ManagementGroup IS NULL OR ManagementGroup = @ManagementGroup)

COMMIT
GO
/****** Object:  StoredProcedure [scom].[spObjectHealthStateUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
	@ID UNIQUEIDENTIFIER,
	@Name NVARCHAR(255),
	@DisplayName NVARCHAR(255),
	@FullName NVARCHAR(255),
	@Path NVARCHAR(1024) = NULL,
	@ObjectClass NVARCHAR(255),
	@HealthState NVARCHAR(255) = N'',
	@StateLastModified DATETIME2(3) = NULL,
	@IsAvailable BIT = NULL,
	@AvailabilityLastModified DATETIME2(3) = NULL,
	@InMaintenanceMode BIT = NULL,
	@MaintenanceModeLastModified DATETIME2(3) = NULL,
	@ManagementGroup NVARCHAR(255),
	@Active BIT,
	@dbLastUpdate DATETIME2(3),
	@Availability NVARCHAR(255),
	@Configuration NVARCHAR(255),
	@Performance NVARCHAR(255),
	@Security NVARCHAR(255),
	@Other NVARCHAR(255),
	@AssetStatus nvarchar(255) = NULL,
	@Notes nvarchar(4000) = NULL

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

	MERGE [scom].[ObjectHealthState] AS [target]
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
		@Other ,
		@AssetStatus ,
		@Notes ) AS [Source]

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
		[Other] ,
		[AssetStatus] , 
		[Notes] ) ON ([target].ID = @ID)


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
		  ,[AssetStatus] = @AssetStatus
		  ,[Notes] = @Notes

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
			[Other] ,
			[AssetStatus],
			[Notes])
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
			@Other ,
			@AssetStatus ,
			@Notes
		)
	;
COMMIT
GO
/****** Object:  StoredProcedure [scom].[spSyncHistoryDeleteByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
/****** Object:  StoredProcedure [scom].[spSyncHistoryInsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [scom].[spSyncHistorySelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
/****** Object:  StoredProcedure [scom].[spSyncStatusSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
/****** Object:  StoredProcedure [scom].[spSyncStatusUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spSyncStatusViewSelect]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
/****** Object:  StoredProcedure [scom].[spWindowsComputerInactivateByDate]    Script Date: 4/21/2020 4:47:21 PM ******/
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
/****** Object:  StoredProcedure [scom].[spWindowsComputerSelectByDNSHostName]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [scom].[spWindowsComputerUpsert]    Script Date: 4/21/2020 4:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [scom].[spWindowsComputerUpsert]
	@ID uniqueidentifier,
	@DNSHostName nvarchar(255),
	@IPAddress nvarchar(255) = N'',
	@ObjectSID nvarchar(255) = N'',
	@NetBIOSDomainName nvarchar(255) = N'',
	@DomainDNSName nvarchar(255) = N'',
	@OrganizationalUnit nvarchar(2048) = N'',
	@ForestDNSName nvarchar(255) = N'',
	@ActiveDirectorySite nvarchar(255) = N'',
	@IsVirtualMachine bit = Null,
	@HealthState nvarchar(255) = N'',
	@StateLastModified datetime2(3) = Null,
	@IsAvailable bit = Null,
	@AvailabilityLastModified datetime2(3) = Null,
	@InMaintenanceMode bit = Null,
	@MaintenanceModeLastModified datetime2(3) = Null,
	@ManagementGroup nvarchar(255) = Null,
	@Active bit,
	@dbLastUpdate datetime2(3)

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

	MERGE [scom].[WindowsComputer] as [target]
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
		@dbLastUpdate ) as [Source]

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
		dbLastUpdate) on ([target].ID = @ID)


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
USE [master]
GO
ALTER DATABASE [SCORE] SET  READ_WRITE 
GO
