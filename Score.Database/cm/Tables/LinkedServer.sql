/****** Object:  Table [cm].[LinkedServer]    Script Date: 1/16/2019 8:32:48 AM ******/
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
/****** Object:  Index [IX_cm_LinkedServer_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LinkedServer_Unique] ON [cm].[LinkedServer]
(
	[DatabaseInstanceGUID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[LinkedServer] ADD  CONSTRAINT [DF_cm_LinkedServer_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[LinkedServer]  WITH CHECK ADD  CONSTRAINT [FK_LinkedServer_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[LinkedServer] CHECK CONSTRAINT [FK_LinkedServer_DatabaseInstance]
GO
