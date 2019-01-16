/****** Object:  Table [cm].[NetworkAdapterConfiguration]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[NetworkAdapterConfiguration](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[MACAddress] [nvarchar](128) NULL,
	[IPV4Address] [nvarchar](255) NULL,
	[SubnetMask] [nvarchar](128) NULL,
	[DefaultIPGateway] [nvarchar](128) NULL,
	[DNSDomainSuffixSearchOrder] [nvarchar](255) NULL,
	[DNSServerSearchOrder] [nvarchar](255) NULL,
	[DNSEnabledForWINSResolution] [bit] NOT NULL,
	[FullDNSRegistrationEnabled] [bit] NOT NULL,
	[DHCPEnabled] [bit] NOT NULL,
	[DHCPLeaseObtained] [datetime2](3) NULL,
	[DHCPLeaseExpires] [datetime2](3) NULL,
	[DHCPServer] [nvarchar](128) NULL,
	[WINSPrimaryServer] [nvarchar](128) NULL,
	[WINSSecondaryServer] [nvarchar](128) NULL,
	[IPEnabled] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_NetworkAdapterConfiguration] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[NetworkAdapterConfiguration] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[NetworkAdapterConfiguration] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_NetworkAdapterConfiguration_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_NetworkAdapterConfiguration_Unique] ON [cm].[NetworkAdapterConfiguration]
(
	[ComputerGUID] ASC,
	[Index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[NetworkAdapterConfiguration] ADD  CONSTRAINT [DF_cm_NetworkAdapterConfiguration_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[NetworkAdapterConfiguration]  ADD  CONSTRAINT [FK_NetworkAdapterConfiguration_NetworkAdapter] FOREIGN KEY([ComputerGUID], [Index])
REFERENCES [cm].[NetworkAdapter] ([ComputerGUID], [Index])
GO
ALTER TABLE [cm].[NetworkAdapterConfiguration] CHECK CONSTRAINT [FK_NetworkAdapterConfiguration_NetworkAdapter]
GO
