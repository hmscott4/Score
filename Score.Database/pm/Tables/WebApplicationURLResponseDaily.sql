CREATE TABLE [pm].[WebApplicationURLResponseDaily](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[WebApplicationURLGUID] [uniqueidentifier] NOT NULL,
	[FailedCheckCount] [int] NOT NULL,
	[SuccessCheckCount] [int] NOT NULL,
	[AvgResponseTime] [decimal](18, 3) NOT NULL,
	[MinResponseTime] [int] NOT NULL,
	[MaxResponseTime] [int] NOT NULL,
	[StDevResponseTime] [decimal](18, 3) NOT NULL,
	[Count] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplicationResponseDaily] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
