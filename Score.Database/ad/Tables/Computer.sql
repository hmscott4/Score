/****** Object:  Table [ad].[Computer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [ad].[Computer](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DNSHostName] [nvarchar](255) NOT NULL,
	[IPv4Address] [nvarchar](128) NULL,
	[Trusted] [bit] NOT NULL,
	[OperatingSystem] [nvarchar](128) NULL,
	[OperatingSystemVersion] [nvarchar](128) NULL,
	[OperatingSystemServicePack] [nvarchar](128) NULL,
	[Description] [nvarchar](1024) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastLogon] [datetime2](3) NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Computer] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_ad_Computer_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Computer_Unique] ON [ad].[Computer]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
