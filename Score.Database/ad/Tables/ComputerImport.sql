USE [SCORE]
GO
/****** Object:  Table [ad].[ComputerImport]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[ComputerImport](
	[Description] [varchar](1024) NULL,
	[DNSHostName] [varchar](255) NULL,
	[DistinguishedName] [varchar](1024) NULL,
	[Enabled] [bit] NULL,
	[IPv4Address] [varchar](128) NULL,
	[LastLogonDate] [datetime2](3) NULL,
	[LastLogonTimeStamp] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[ObjectClass] [varchar](255) NULL,
	[objectGUID] [varchar](128) NULL,
	[OperatingSystem] [varchar](128) NULL,
	[OperatingSystemServicePack] [varchar](128) NULL,
	[OperatingSystemVersion] [varchar](128) NULL,
	[SamAccountName] [varchar](255) NULL,
	[SID] [varchar](255) NULL,
	[Trusted] [bit] NULL,
	[UserPrincipalName] [varchar](255) NULL,
	[whenCreated] [datetime2](3) NULL,
	[whenChanged] [datetime2](3) NULL
) ON [PRIMARY]
GO
