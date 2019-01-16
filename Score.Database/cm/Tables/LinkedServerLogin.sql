/****** Object:  Table [cm].[LinkedServerLogin]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[LinkedServerLogin](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[LinkedServerID] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Impersonate] [bit] NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[DateLastModified] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_LinkedServerLogin] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[LinkedServerLogin] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[LinkedServerLogin] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_LinkedServerLogin_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LinkedServerLogin_Unique] ON [cm].[LinkedServerLogin]
(
	[DatabaseInstanceGUID] ASC,
	[LinkedServerID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[LinkedServerLogin] ADD  CONSTRAINT [DF_cm_LinkedServerLogin_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[LinkedServerLogin]  WITH CHECK ADD  CONSTRAINT [FK_LinkedServerLogin_LinkedServer] FOREIGN KEY([DatabaseInstanceGUID], [LinkedServerID])
REFERENCES [cm].[LinkedServer] ([DatabaseInstanceGUID], [ID])
GO
ALTER TABLE [cm].[LinkedServerLogin] CHECK CONSTRAINT [FK_LinkedServerLogin_LinkedServer]
GO
