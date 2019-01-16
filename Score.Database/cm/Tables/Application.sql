/****** Object:  Table [cm].[Application]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[Application](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Version] [nvarchar](128) NULL,
	[Vendor] [nvarchar](128) NULL,
	[Licensed] [bit] NULL,
	[LicenseMetric] [nvarchar](64) NULL,
	[AvailableLicenses] [int] NULL,
	[AllocatedLicenses] [int] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Application] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[Application] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Application] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_Application_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Application_Unique] ON [cm].[Application]
(
	[Name] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_Licensed]  DEFAULT ((0)) FOR [Licensed]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_LicenseMetric]  DEFAULT (N'') FOR [LicenseMetric]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_AvailableLicenses]  DEFAULT ((0)) FOR [AvailableLicenses]
GO
ALTER TABLE [cm].[Application] ADD  CONSTRAINT [DF_cm_Application_AllocatedLicenses]  DEFAULT ((0)) FOR [AllocatedLicenses]
GO
