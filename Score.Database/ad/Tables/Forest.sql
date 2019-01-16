USE [SCORE]
GO
/****** Object:  Table [ad].[Forest]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Forest](
	[Name] [nvarchar](128) NOT NULL,
	[DomainNamingMaster] [nvarchar](128) NOT NULL,
	[SchemaMaster] [nvarchar](128) NOT NULL,
	[RootDomain] [nvarchar](128) NOT NULL,
	[ForestMode] [nvarchar](128) NULL,
	[UserName] [nvarchar](128) NULL,
	[Password] [varbinary](256) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_Forest] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [ad].[Forest] TO [adRead] AS [dbo]
GO
GRANT SELECT ON [ad].[Forest] TO [adRead] AS [dbo]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Forest_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Forest_Unique] ON [ad].[Forest]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
