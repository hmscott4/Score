/****** Object:  Table [pm].[DatabaseSizeDaily]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [pm].[DatabaseSizeDaily](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[DatabaseGUID] [uniqueidentifier] NOT NULL,
	[DataFileSize] [bigint] NOT NULL,
	[DataFileSpaceUsed] [bigint] NOT NULL,
	[LogFileSize] [bigint] NOT NULL,
	[LogFileSpaceUsed] [bigint] NOT NULL,
	[Count] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_DatabaseSizeDaily] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [pm].[DatabaseSizeDaily]  ADD  CONSTRAINT [FK_DatabaseSizeDaily_Database] FOREIGN KEY([DatabaseGUID])
REFERENCES [cm].[Database] ([objectGUID])
GO
ALTER TABLE [pm].[DatabaseSizeDaily] CHECK CONSTRAINT [FK_DatabaseSizeDaily_Database]
GO
