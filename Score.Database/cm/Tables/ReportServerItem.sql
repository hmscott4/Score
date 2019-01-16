/****** Object:  Table [cm].[ReportServerItem]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ReportServerItem](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ReportingInstanceGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](425) NOT NULL,
	[Path] [nvarchar](425) NOT NULL,
	[VirtualPath] [nvarchar](1024) NOT NULL,
	[TypeName] [nvarchar](128) NOT NULL,
	[Size] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[Hidden] [bit] NOT NULL,
	[CreationDate] [datetime2](3) NOT NULL,
	[ModifiedDate] [datetime2](3) NOT NULL,
	[ModifiedBy] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportServerItem] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ReportServerItem] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ReportServerItem] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_ReportServerItem_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ReportServerItem_Unique] ON [cm].[ReportServerItem]
(
	[ReportingInstanceGUID] ASC,
	[Path] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[ReportServerItem] ADD  CONSTRAINT [DF_cm_ReportServerItem_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ReportServerItem]  ADD  CONSTRAINT [FK_ReportServerItem_ReportingInstance] FOREIGN KEY([ReportingInstanceGUID])
REFERENCES [cm].[ReportingInstance] ([objectGUID])
GO
ALTER TABLE [cm].[ReportServerItem] CHECK CONSTRAINT [FK_ReportServerItem_ReportingInstance]
GO
