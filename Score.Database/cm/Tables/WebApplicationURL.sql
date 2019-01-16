/****** Object:  Table [cm].[WebApplicationURL]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[WebApplicationURL](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[WebApplicationGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[URL] [nvarchar](2048) NOT NULL,
	[UseDefaultCredential] [bit] NOT NULL,
	[FormData] [nvarchar](2048) NULL,
	[LastStatusCode] [nvarchar](128) NOT NULL,
	[LastStatusDescription] [nvarchar](128) NOT NULL,
	[LastResponseTime] [int] NOT NULL,
	[LastUpdate] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplicationURL] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[WebApplicationURL] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[WebApplicationURL] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_WebApplicationURL_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WebApplicationURL_Unique] ON [cm].[WebApplicationURL]
(
	[WebApplicationGUID] ASC,
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastStatusCode]  DEFAULT (N'') FOR [LastStatusCode]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastStatusDescription]  DEFAULT (N'') FOR [LastStatusDescription]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastResponseTime]  DEFAULT ((0)) FOR [LastResponseTime]
GO
ALTER TABLE [cm].[WebApplicationURL] ADD  CONSTRAINT [DF_WebApplicationURL_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
