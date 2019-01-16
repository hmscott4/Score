/****** Object:  Table [cm].[LogicalVolume]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[LogicalVolume](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DriveLetter] [nvarchar](128) NULL,
	[Label] [nvarchar](128) NULL,
	[FileSystem] [nvarchar](128) NOT NULL,
	[BlockSize] [int] NOT NULL,
	[SerialNumber] [nvarchar](128) NOT NULL,
	[Capacity] [bigint] NOT NULL,
	[SpaceUsed] [bigint] NULL,
	[SystemVolume] [bit] NOT NULL,
	[IsClustered] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_LogicalVolume] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[LogicalVolume] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[LogicalVolume] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_LogicalVolume_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LogicalVolume_Unique] ON [cm].[LogicalVolume]
(
	[ComputerGUID] ASC,
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[LogicalVolume] ADD  CONSTRAINT [DF_cm_LogicalVolume_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[LogicalVolume] ADD  CONSTRAINT [DF_cm_LogicalVolume_SpaceUsed]  DEFAULT ((0)) FOR [SpaceUsed]
GO
ALTER TABLE [cm].[LogicalVolume]  ADD  CONSTRAINT [FK_LogicalVolume_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[LogicalVolume] CHECK CONSTRAINT [FK_LogicalVolume_Computer]
GO
