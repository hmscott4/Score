/****** Object:  Table [pm].[WebApplicationURLResponseRaw]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [pm].[WebApplicationURLResponseRaw](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[WebApplicationURLGUID] [uniqueidentifier] NOT NULL,
	[StatusCode] [int] NOT NULL,
	[StatusDescription] [nvarchar](128) NOT NULL,
	[LastResponseTime] [int] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplicationResponseRaw] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
