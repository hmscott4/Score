CREATE TABLE [dbo].[SystemTimeZone](
	[ZoneID] [uniqueidentifier] NOT NULL,
	[ID] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[StandardName] [nvarchar](255) NOT NULL,
	[DaylightName] [nvarchar](255) NOT NULL,
	[BaseUTCOffset] [int] NOT NULL,
	[CurrentUTCOffset] [int] NOT NULL,
	[SupportsDaylightSavingTime] [bit] NOT NULL,
	[Display] [bit] NULL,
	[DefaultTimeZone] [bit] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_SystemTimeZone] PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [UX_SystemTimeZone_ID]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_SystemTimeZone_ID] ON [dbo].[SystemTimeZone]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemTimeZone] ADD  CONSTRAINT [DF_SystemTimeZone_ZoneID]  DEFAULT (newid()) FOR [ZoneID]
GO
