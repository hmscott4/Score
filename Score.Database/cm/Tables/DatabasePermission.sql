/****** Object:  Table [cm].[DatabasePermission]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DatabasePermission](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[PermissionSource] [nvarchar](32) NOT NULL,
	[PermissionState] [nvarchar](128) NOT NULL,
	[PermissionType] [nvarchar](128) NOT NULL,
	[Grantor] [nvarchar](128) NOT NULL,
	[ObjectName] [nvarchar](128) NOT NULL,
	[Grantee] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabasePermission] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabasePermission] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabasePermission] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabasePermission_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabasePermission_Unique] ON [cm].[DatabasePermission]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC,
	[PermissionSource] ASC,
	[PermissionState] ASC,
	[PermissionType] ASC,
	[Grantor] ASC,
	[ObjectName] ASC,
	[Grantee] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabasePermission] ADD  CONSTRAINT [DF_cm_DatabasePermission_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabasePermission]  WITH CHECK ADD  CONSTRAINT [FK_DatabasePermission_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabasePermission] CHECK CONSTRAINT [FK_DatabasePermission_DatabaseInstance]
GO
