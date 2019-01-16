/****** Object:  Table [ad].[Group]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [ad].[Group](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Scope] [nvarchar](255) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[Email] [nvarchar](255) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Group] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_ad_Group_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Group_Unique] ON [ad].[Group]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
