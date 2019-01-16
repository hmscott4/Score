USE [SCORE]
GO
/****** Object:  Table [ad].[User]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[User](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](100) NULL,
	[Description] [nvarchar](255) NULL,
	[JobTitle] [nvarchar](255) NULL,
	[EmployeeNumber] [nvarchar](255) NULL,
	[ProfilePath] [nvarchar](1024) NULL,
	[HomeDirectory] [nvarchar](1024) NULL,
	[Company] [nvarchar](255) NULL,
	[Office] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[Division] [nvarchar](255) NULL,
	[StreetAddress] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](255) NULL,
	[Manager] [nvarchar](255) NULL,
	[MobilePhone] [nvarchar](20) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Pager] [nvarchar](20) NULL,
	[EMail] [nvarchar](255) NULL,
	[LockedOut] [bit] NULL,
	[PasswordExpired] [bit] NULL,
	[PasswordLastSet] [datetime2](3) NULL,
	[PasswordNeverExpires] [bit] NULL,
	[PasswordNotRequired] [bit] NULL,
	[TrustedForDelegation] [bit] NULL,
	[TrustedToAuthForDelegation] [bit] NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastLogon] [datetime2](3) NULL,
	[whenCreated] [datetime2](3) NOT NULL,
	[whenChanged] [datetime2](3) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_User] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [ad].[User] TO [adRead] AS [dbo]
GO
GRANT SELECT ON [ad].[User] TO [adRead] AS [dbo]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ad_User_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_User_Unique] ON [ad].[User]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
