USE [SCORE]
GO
/****** Object:  Table [scom].[Agent]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GRANT SELECT ON [scom].[Agent] TO [scomRead] AS [dbo]
GO
GRANT SELECT ON [scom].[Agent] TO [scomUpdate] AS [dbo]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_Agent_Name]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE CLUSTERED INDEX [IX_scom_Agent_Name] ON [scom].[Agent]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_scom_Agent_Domain]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE NONCLUSTERED INDEX [IX_scom_Agent_Domain] ON [scom].[Agent]
(
	[Domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
