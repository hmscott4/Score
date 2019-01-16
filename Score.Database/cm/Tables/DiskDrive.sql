/****** Object:  Table [cm].[DiskDrive]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DiskDrive](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DeviceID] [nvarchar](128) NOT NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL,
	[SerialNumber] [nvarchar](128) NULL,
	[FirmwareRevision] [nvarchar](128) NULL,
	[Partitions] [int] NULL,
	[InterfaceType] [nvarchar](128) NOT NULL,
	[SCSIBus] [int] NULL,
	[SCSIPort] [int] NULL,
	[SCSILogicalUnit] [int] NULL,
	[SCSITargetID] [int] NULL,
	[Size] [bigint] NOT NULL,
	[Status] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DiskDrive] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DiskDrive] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DiskDrive] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DiskDrive_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DiskDrive_Unique] ON [cm].[DiskDrive]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DiskDrive] ADD  CONSTRAINT [DF_cm_DiskDrive_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DiskDrive]  WITH CHECK ADD  CONSTRAINT [FK_DiskDrive_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[DiskDrive] CHECK CONSTRAINT [FK_DiskDrive_Computer]
GO
