/****** Object:  Table [dbo].[Config]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [dbo].[Config](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ConfigName] [nvarchar](255) NOT NULL,
	[ConfigValue] [nvarchar](255) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbAddBy] [nvarchar](255) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL,
	[dbModBy] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_Config_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Config_Unique] ON [dbo].[Config]
(
	[ConfigName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
