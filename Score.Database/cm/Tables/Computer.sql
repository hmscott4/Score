/****** Object:  Table [cm].[Computer]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GRANT REFERENCES ON [cm].[Computer] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Computer] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_Computer_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE CLUSTERED INDEX [IX_cm_Computer_Unique] ON [cm].[Computer]
(
	[dnsHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_cm_Computer_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_cm_Computer_Virtual]  DEFAULT ((0)) FOR [IsVirtual]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_dm_Computer_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [cm].[Computer] ADD  CONSTRAINT [DF_cm_Computer_IsClusterResource]  DEFAULT ((0)) FOR [IsClusterResource]
GO
