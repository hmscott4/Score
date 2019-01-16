/****** Object:  Table [cm].[DatabaseInstanceProperty]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DatabaseInstanceProperty](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseInstanceProperty] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseInstanceProperty] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseInstanceProperty] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseInstanceProperty_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseInstanceProperty_Unique] ON [cm].[DatabaseInstanceProperty]
(
	[DatabaseInstanceGUID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseInstanceProperty] ADD  CONSTRAINT [DF_cm_DatabaseInstanceProperty_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseInstanceProperty]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseInstanceProperty_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseInstanceProperty] CHECK CONSTRAINT [FK_DatabaseInstanceProperty_DatabaseInstance]
GO
