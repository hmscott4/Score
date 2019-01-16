/****** Object:  Table [cm].[WindowsUpdate]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[WindowsUpdate](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[HotfixID] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](128) NOT NULL,
	[Caption] [nvarchar](128) NULL,
	[FixComments] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WindowsUpdate] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[WindowsUpdate] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[WindowsUpdate] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_WindowsUpdate]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WindowsUpdate] ON [cm].[WindowsUpdate]
(
	[HotfixID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[WindowsUpdate] ADD  CONSTRAINT [DF_cm_WindowsUpdate]  DEFAULT (newid()) FOR [objectGUID]
GO
