CREATE TABLE [scom].[WindowsComputer](
	[ID] [uniqueidentifier] NOT NULL,
	[DNSHostName] [nvarchar](255) NOT NULL,
	[IPAddress] [nvarchar](255) NULL,
	[ObjectSID] [nvarchar](255) NULL,
	[NetBIOSDomainName] [nvarchar](255) NULL,
	[DomainDNSName] [nvarchar](255) NULL,
	[OrganizationalUnit] [nvarchar](2048) NULL,
	[ForestDNSName] [nvarchar](255) NULL,
	[ActiveDirectorySite] [nvarchar](255) NULL,
	[IsVirtualMachine] [bit] NULL,
	[HealthState] [nvarchar](255) NULL,
	[StateLastModified] [datetime2](3) NULL,
	[IsAvailable] [bit] NULL,
	[AvailabilityLastModified] [datetime2](3) NULL,
	[InMaintenanceMode] [bit] NULL,
	[MaintenanceModeLastModified] [datetime2](3) NULL,
	[ManagementGroup] [nvarchar](255) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_WindowsComputer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_scom_WindowsComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_scom_WindowsComputer] ON [scom].[WindowsComputer]
(
	[DNSHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
