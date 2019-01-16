/****** Object:  Table [cm].[ClusterResource]    Script Date: 1/16/2019 8:32:48 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ClusterResource] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ClusterResource] TO [cmRead] AS [dbo]
GO
ALTER TABLE [cm].[ClusterResource] ADD  CONSTRAINT [DF_cm_ClusterResource_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
