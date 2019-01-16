/****** Object:  Table [cm].[NetworkAdapter]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[NetworkAdapter](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[NetConnectionID] [nvarchar](255) NULL,
	[AdapterType] [nvarchar](255) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[MACAddress] [nvarchar](128) NULL,
	[PhysicalAdapter] [bit] NULL,
	[Speed] [bigint] NULL,
	[NetEnabled] [int] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_NetworkAdapter] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[NetworkAdapter] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[NetworkAdapter] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_NetworkAdapter_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_NetworkAdapter_Unique] ON [cm].[NetworkAdapter]
(
	[ComputerGUID] ASC,
	[Index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[NetworkAdapter] ADD  CONSTRAINT [DF_cm_NetworkAdapter_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[NetworkAdapter]  ADD  CONSTRAINT [FK_NetworkAdapter_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[NetworkAdapter] CHECK CONSTRAINT [FK_NetworkAdapter_Computer]
GO
