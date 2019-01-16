/****** Object:  Table [cm].[DrivePartitionMap]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DrivePartitionMap](
	[ObjectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[PartitionName] [nvarchar](128) NOT NULL,
	[DriveName] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DrivePartitionMap] PRIMARY KEY CLUSTERED 
(
	[ObjectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DrivePartitionMap] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DrivePartitionMap] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DrivePartitionMap_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DrivePartitionMap_Unique] ON [cm].[DrivePartitionMap]
(
	[ComputerGUID] ASC,
	[PartitionName] ASC,
	[DriveName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DrivePartitionMap] ADD  CONSTRAINT [DF_cm_DrivePartitionMap_objectGUID]  DEFAULT (newid()) FOR [ObjectGUID]
GO
ALTER TABLE [cm].[DrivePartitionMap]  ADD  CONSTRAINT [FK_DrivePartitionMap_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[DrivePartitionMap] CHECK CONSTRAINT [FK_DrivePartitionMap_Computer]
GO
