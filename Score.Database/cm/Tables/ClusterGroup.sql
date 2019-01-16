/****** Object:  Table [cm].[ClusterGroup]    Script Date: 1/16/2019 8:32:48 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ClusterGroup] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ClusterGroup] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_ClusterGroup_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ClusterGroup_Unique] ON [cm].[ClusterGroup]
(
	[ClusterGUID] ASC,
	[GroupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[ClusterGroup] ADD  CONSTRAINT [DF_cm_ClusterGroup_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ClusterGroup]  WITH CHECK ADD  CONSTRAINT [FK_ClusterGroup_Cluster] FOREIGN KEY([ClusterGUID])
REFERENCES [cm].[Cluster] ([objectGUID])
GO
ALTER TABLE [cm].[ClusterGroup] CHECK CONSTRAINT [FK_ClusterGroup_Cluster]
GO
