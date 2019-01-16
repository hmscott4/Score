/****** Object:  Table [cm].[DatabaseProperty]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DatabaseProperty](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseGUID] [uniqueidentifier] NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseProperty] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseProperty] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseProperty] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseProperty_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseProperty_Unique] ON [cm].[DatabaseProperty]
(
	[DatabaseGUID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseProperty] ADD  CONSTRAINT [DF_cm_DatabaseProperty_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseProperty]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseProperty_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseProperty] CHECK CONSTRAINT [FK_DatabaseProperty_Database]
GO
