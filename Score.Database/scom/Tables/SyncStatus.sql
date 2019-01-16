/****** Object:  Table [scom].[SyncStatus]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [scom].[SyncStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementGroup] [nvarchar](128) NOT NULL,
	[ObjectClass] [nvarchar](128) NOT NULL,
	[SyncType] [nvarchar](64) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](128) NULL,
 CONSTRAINT [PK_scom_SyncStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO