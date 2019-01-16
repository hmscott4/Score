/****** Object:  Table [cm].[DatabaseInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseInstance] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseInstance] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseInstance_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseInstance_Unique] ON [cm].[DatabaseInstance]
(
	[ComputerGUID] ASC,
	[InstanceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseInstance] ADD  CONSTRAINT [DF_cm_DatabaseInstance_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
