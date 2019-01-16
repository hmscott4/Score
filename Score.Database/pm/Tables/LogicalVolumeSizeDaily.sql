/****** Object:  Table [pm].[LogicalVolumeSizeDaily]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [pm].[LogicalVolumeSizeDaily](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[LogicalVolumeGUID] [uniqueidentifier] NOT NULL,
	[SpaceUsed] [bigint] NOT NULL,
	[MaxSpaceUsed] [bigint] NOT NULL,
	[MinSpaceUsed] [bigint] NOT NULL,
	[StDevSpaceUsed] [decimal](18, 3) NOT NULL,
	[Count] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_LogicalVolumeSizeDaily] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [pm].[LogicalVolumeSizeDaily]  ADD  CONSTRAINT [FK_LogicalVolumeSizeDaily_LogicalVolume] FOREIGN KEY([ComputerGUID], [LogicalVolumeGUID])
REFERENCES [cm].[LogicalVolume] ([ComputerGUID], [objectGUID])
GO
ALTER TABLE [pm].[LogicalVolumeSizeDaily] CHECK CONSTRAINT [FK_LogicalVolumeSizeDaily_LogicalVolume]
GO
