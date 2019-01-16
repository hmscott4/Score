/****** Object:  Table [cm].[DatabaseFile]    Script Date: 1/16/2019 8:32:48 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseFile] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseFile] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseFile_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseFile_Unique] ON [cm].[DatabaseFile]
(
	[DatabaseGUID] ASC,
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseFile] ADD  CONSTRAINT [DF_cm_DatabaseFile_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseFile]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseFile_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseFile] CHECK CONSTRAINT [FK_DatabaseFile_Database]
GO
