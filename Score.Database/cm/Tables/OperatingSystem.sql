/****** Object:  Table [cm].[OperatingSystem]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[OperatingSystem](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[computerGUID] [uniqueidentifier] NOT NULL,
	[IPV4Address] [nvarchar](128) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[OSArchitecture] [nvarchar](128) NULL,
	[OSType] [nvarchar](128) NULL,
	[OperatingSystem] [nvarchar](128) NULL,
	[Description] [nvarchar](1024) NULL,
	[Version] [nvarchar](128) NULL,
	[ServicePack] [nvarchar](128) NULL,
	[ServicePackMajorVersion] [int] NULL,
	[ServicePackMinorVersion] [int] NULL,
	[BootDevice] [nvarchar](255) NULL,
	[SystemDevice] [nvarchar](255) NULL,
	[WindowsDirectory] [nvarchar](255) NULL,
	[SystemDirectory] [nvarchar](255) NULL,
	[TotalVisibleMemorySize] [bigint] NULL,
	[InstallDate] [datetime2](3) NULL,
	[LastBootUpTime] [datetime2](3) NULL,
	[Status] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_OperatingSystem] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[OperatingSystem] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[OperatingSystem] TO [cmRead] AS [dbo]
GO
ALTER TABLE [cm].[OperatingSystem] ADD  CONSTRAINT [DF_cm_OperatingSystem_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[OperatingSystem] ADD  CONSTRAINT [DF_cm_OperatingSystem_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [cm].[OperatingSystem]  ADD  CONSTRAINT [FK_OperatingSystem_Computer] FOREIGN KEY([computerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[OperatingSystem] CHECK CONSTRAINT [FK_OperatingSystem_Computer]
GO
