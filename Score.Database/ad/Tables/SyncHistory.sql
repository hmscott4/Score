USE [SCORE]
GO
/****** Object:  Table [ad].[SyncHistory]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[SyncHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](255) NOT NULL,
	[ObjectClass] [nvarchar](255) NOT NULL,
	[SyncType] [nvarchar](255) NOT NULL,
	[StartDate] [datetime2](3) NULL,
	[EndDate] [datetime2](3) NULL,
	[Count] [int] NULL,
	[Status] [nvarchar](255) NULL,
 CONSTRAINT [PK_ad_SyncHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [ad].[SyncHistory] TO [adRead] AS [dbo]
GO
GRANT SELECT ON [ad].[SyncHistory] TO [adRead] AS [dbo]
GO
