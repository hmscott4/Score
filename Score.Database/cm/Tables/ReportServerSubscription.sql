/****** Object:  Table [cm].[ReportServerSubscription]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ReportServerSubscription](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ReportingInstanceGUID] [uniqueidentifier] NOT NULL,
	[Owner] [nvarchar](255) NOT NULL,
	[Path] [nvarchar](1024) NOT NULL,
	[VirtualPath] [nvarchar](1024) NOT NULL,
	[Report] [nvarchar](1024) NOT NULL,
	[Description] [nvarchar](1204) NULL,
	[Status] [nvarchar](128) NOT NULL,
	[SubscriptionActive] [bit] NOT NULL,
	[LastExecuted] [datetime2](3) NULL,
	[ModifiedBy] [nvarchar](255) NOT NULL,
	[ModifiedDate] [datetime2](3) NOT NULL,
	[EventType] [nvarchar](128) NOT NULL,
	[IsDataDriven] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportServerSubscription] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ReportServerSubscription] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ReportServerSubscription] TO [cmRead] AS [dbo]
GO
ALTER TABLE [cm].[ReportServerSubscription] ADD  CONSTRAINT [DF_cm_ReportServerSubscription_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ReportServerSubscription]  ADD  CONSTRAINT [FK_ReportServerSubscription_ReportingInstance] FOREIGN KEY([ReportingInstanceGUID])
REFERENCES [cm].[ReportingInstance] ([objectGUID])
GO
ALTER TABLE [cm].[ReportServerSubscription] CHECK CONSTRAINT [FK_ReportServerSubscription_ReportingInstance]
GO
