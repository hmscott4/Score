/****** Object:  Table [dbo].[Computer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [dbo].[Computer](
	[ID] [uniqueidentifier] NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[dnsHostName] [nvarchar](255) NOT NULL,
	[CredentialName] [nvarchar](255) NULL,
	[AgentName] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_Computer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_Computer_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Computer_Unique] ON [dbo].[Computer]
(
	[Domain] ASC,
	[dnsHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Computer] ADD  CONSTRAINT [DF_Computer_ID]  DEFAULT (newid()) FOR [ID]
GO
