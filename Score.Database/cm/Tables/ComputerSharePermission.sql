/****** Object:  Table [cm].[ComputerSharePermission]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ComputerSharePermission](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerShareGUID] [uniqueidentifier] NOT NULL,
	[SecurityPrincipal] [nvarchar](128) NOT NULL,
	[FileSystemRights] [nvarchar](128) NOT NULL,
	[AccessControlType] [nvarchar](128) NOT NULL,
	[IsInherited] [bit] NOT NULL,
	[InheritanceFlags] [nvarchar](128) NOT NULL,
	[PropagationFlags] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ComputerSharePermission] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ComputerSharePermission] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ComputerSharePermission] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_ComputerSharePermission_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ComputerSharePermission_Unique] ON [cm].[ComputerSharePermission]
(
	[ComputerShareGUID] ASC,
	[SecurityPrincipal] ASC,
	[AccessControlType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[ComputerSharePermission] ADD  CONSTRAINT [DF_cm_ComputerSharePermission_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
