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

