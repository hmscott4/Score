/****** Object:  Table [cm].[DatabaseUser]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DatabaseUser](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](128) NOT NULL,
	[Login] [nvarchar](128) NOT NULL,
	[UserType] [nvarchar](128) NOT NULL,
	[LoginType] [nvarchar](128) NOT NULL,
	[HasDBAccess] [bit] NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[DateLastModified] [datetime2](3) NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseUser] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseUser] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseUser] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseUser_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseUser_Unique] ON [cm].[DatabaseUser]
(
	[DatabaseInstanceGUID] ASC,
	[DatabaseName] ASC,
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseUser] ADD  CONSTRAINT [DF_cm_DatabaseUser_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseUser]  ADD  CONSTRAINT [FK_DatabaseUser_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseUser] CHECK CONSTRAINT [FK_DatabaseUser_DatabaseInstance]
GO
