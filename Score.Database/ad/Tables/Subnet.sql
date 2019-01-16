USE [SCORE]
GO
/****** Object:  Table [ad].[Subnet]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[Subnet](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[Location] [nvarchar](1024) NULL,
	[Site] [nvarchar](255) NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_Subnet] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [ad].[Subnet] TO [adRead] AS [dbo]
GO
GRANT SELECT ON [ad].[Subnet] TO [adRead] AS [dbo]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_Subnet_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Subnet_Unique] ON [ad].[Subnet]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
