/****** Object:  Table [pm].[LogicalVolumeSizeRaw]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [pm].[LogicalVolumeSizeRaw](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[LogicalVolumeGUID] [uniqueidentifier] NOT NULL,
	[SpaceUsed] [bigint] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_LogicalVolumeSizeRaw] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [pm].[LogicalVolumeSizeRaw]  ADD  CONSTRAINT [FK_LogicalVolumeSizeRaw_LogicalVolume] FOREIGN KEY([ComputerGUID], [LogicalVolumeGUID])
REFERENCES [cm].[LogicalVolume] ([ComputerGUID], [objectGUID])
GO
ALTER TABLE [pm].[LogicalVolumeSizeRaw] CHECK CONSTRAINT [FK_LogicalVolumeSizeRaw_LogicalVolume]
GO
