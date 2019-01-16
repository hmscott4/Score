/****** Object:  Table [cm].[ApplicationInstallation]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ApplicationInstallation](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[ApplicationGUID] [uniqueidentifier] NOT NULL,
	[InstallDate] [datetime2](7) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ApplicationInstallation] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ApplicationInstallation] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_Application_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Application_Unique] ON [cm].[ApplicationInstallation]
(
	[ComputerGUID] ASC,
	[ApplicationGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[ApplicationInstallation] ADD  CONSTRAINT [DF_cm_ApplicationInstallation_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ApplicationInstallation]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationInstallation_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[ApplicationInstallation] CHECK CONSTRAINT [FK_ApplicationInstallation_Computer]
GO
