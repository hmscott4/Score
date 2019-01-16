/****** Object:  Table [cm].[Cluster]    Script Date: 1/16/2019 8:32:48 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[Cluster] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Cluster] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_Cluster_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Cluster_Unique] ON [cm].[Cluster]
(
	[ClusterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[Cluster] ADD  CONSTRAINT [DF_cm_Cluster_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
