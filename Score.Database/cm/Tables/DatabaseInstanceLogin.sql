/****** Object:  Table [cm].[DatabaseInstanceLogin]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[DatabaseInstanceLogin](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Sid] [nvarchar](255) NOT NULL,
	[LoginType] [nvarchar](128) NOT NULL,
	[DefaultDatabase] [nvarchar](255) NOT NULL,
	[HasAccess] [bit] NOT NULL,
	[IsDisabled] [bit] NULL,
	[IsLocked] [bit] NULL,
	[IsPasswordExpired] [bit] NULL,
	[PasswordExpirationEnabled] [bit] NULL,
	[PasswordPolicyEnforced] [bit] NULL,
	[IsSysAdmin] [bit] NOT NULL,
	[IsSecurityAdmin] [bit] NOT NULL,
	[IsSetupAdmin] [bit] NOT NULL,
	[IsProcessAdmin] [bit] NOT NULL,
	[IsDiskAdmin] [bit] NOT NULL,
	[IsDBCreator] [bit] NOT NULL,
	[IsBulkAdmin] [bit] NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[DateLastModified] [datetime2](3) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_DatabaseInstanceLogin] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[DatabaseInstanceLogin] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[DatabaseInstanceLogin] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_DatabaseInstanceLogin_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseInstanceLogin_Unique] ON [cm].[DatabaseInstanceLogin]
(
	[DatabaseInstanceGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[DatabaseInstanceLogin] ADD  CONSTRAINT [DF_cm_DatabaseInstanceLogin_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[DatabaseInstanceLogin]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseInstanceLogin_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[DatabaseInstanceLogin] CHECK CONSTRAINT [FK_DatabaseInstanceLogin_DatabaseInstance]
GO
