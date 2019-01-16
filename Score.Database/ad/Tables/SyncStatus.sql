/****** Object:  Table [ad].[SyncStatus]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [ad].[SyncStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[ObjectClass] [nvarchar](128) NOT NULL,
	[SyncType] [nvarchar](64) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](128) NULL,
 CONSTRAINT [PK_ad_SyncStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_ad_SyncStatus_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_SyncStatus_Unique] ON [ad].[SyncStatus]
(
	[Domain] ASC,
	[ObjectClass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
