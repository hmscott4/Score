/****** Object:  Table [cm].[Database]    Script Date: 1/16/2019 8:32:48 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[Database] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Database] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_Database_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Database_Unique] ON [cm].[Database]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
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
