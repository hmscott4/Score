/****** Object:  Table [cm].[DatabaseRoleMember]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DatabaseRoleMember](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[RoleName] [nvarchar](128) NOT NULL,
	[RoleMember] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseRoleMember] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseRoleMember] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseRoleMember] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseRoleMember_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseRoleMember_Unique] ON [cm].[DatabaseRoleMember]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC,
	[RoleName] ASC,
	[RoleMember] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseRoleMember] ADD  CONSTRAINT [DF_cm_DatabaseRoleMember_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
