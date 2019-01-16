/****** Object:  Table [cm].[WebApplication]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[WebApplication](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_WebApplication] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[WebApplication] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[WebApplication] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_WebApplication_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WebApplication_Unique] ON [cm].[WebApplication]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[WebApplication] ADD  CONSTRAINT [DF_WebApplication_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
