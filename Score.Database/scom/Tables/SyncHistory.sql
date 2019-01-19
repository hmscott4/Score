CREATE TABLE [scom].[SyncHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[ObjectClass] [nvarchar](255) NOT NULL,
	[SyncType] [nvarchar](255) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](255) NULL,
 CONSTRAINT [PK_scom_SyncHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO