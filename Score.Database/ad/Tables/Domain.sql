/****** Object:  Table [ad].[Domain]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [ad].[Domain](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](128) NOT NULL,
	[Forest] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DNSRoot] [nvarchar](128) NOT NULL,
	[NetBIOSName] [nvarchar](128) NOT NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[InfrastructureMaster] [nvarchar](128) NOT NULL,
	[PDCEmulator] [nvarchar](128) NOT NULL,
	[RIDMaster] [nvarchar](128) NOT NULL,
	[DomainFunctionality] [nvarchar](128) NULL,
	[ForestFunctionality] [nvarchar](128) NULL,
	[UserName] [nvarchar](128) NULL,
	[Password] [varbinary](256) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Domain] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_ad_Domain_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Domain_Unique] ON [ad].[Domain]
(
	[DistinguishedName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
