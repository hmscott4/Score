USE [SCORE]
GO
/****** Object:  Table [scom].[SyncStatus]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GRANT SELECT ON [scom].[SyncStatus] TO [scomRead] AS [dbo]
GO
GRANT DELETE ON [scom].[SyncStatus] TO [scomUpdate] AS [dbo]
GO
GRANT INSERT ON [scom].[SyncStatus] TO [scomUpdate] AS [dbo]
GO
GRANT SELECT ON [scom].[SyncStatus] TO [scomUpdate] AS [dbo]
GO
GRANT UPDATE ON [scom].[SyncStatus] TO [scomUpdate] AS [dbo]
GO
