USE [SCORE]
GO
/****** Object:  Table [scom].[AlertAgingBuckets]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[AlertAgingBuckets](
	[AgeID] [int] IDENTITY(1,1) NOT NULL,
	[LowValue] [int] NOT NULL,
	[HighValue] [int] NOT NULL,
	[Label] [nvarchar](128) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL
) ON [PRIMARY]
GO
GRANT SELECT ON [scom].[AlertAgingBuckets] TO [scomRead] AS [dbo]
GO
GRANT SELECT ON [scom].[AlertAgingBuckets] TO [scomUpdate] AS [dbo]
GO
