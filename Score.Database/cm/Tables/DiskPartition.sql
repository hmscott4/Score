/****** Object:  Table [cm].[DiskPartition]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DiskPartition](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DiskIndex] [int] NOT NULL,
	[Index] [int] NOT NULL,
	[DeviceID] [nvarchar](255) NOT NULL,
	[Bootable] [bit] NOT NULL,
	[BootPartition] [bit] NOT NULL,
	[PrimaryPartition] [bit] NOT NULL,
	[StartingOffset] [bigint] NULL,
	[Size] [bigint] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DiskPartition] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DiskPartition] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DiskPartition] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DiskPartition_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DiskPartition_Unique] ON [cm].[DiskPartition]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DiskPartition] ADD  CONSTRAINT [DF_cm_DiskPartition_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DiskPartition]  WITH CHECK ADD  CONSTRAINT [FK_DiskPartition_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[DiskPartition] CHECK CONSTRAINT [FK_DiskPartition_Computer]
GO
