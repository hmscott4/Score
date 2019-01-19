CREATE TABLE [dbo].[Credential](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CredentialType] [nvarchar](128) NOT NULL,
	[AccountName] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](512) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_Credential] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_Credential_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Credential_Unique] ON [dbo].[Credential]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credential] ADD  CONSTRAINT [DF_Credential_ID]  DEFAULT (newid()) FOR [ID]
GO
