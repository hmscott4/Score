/****** Object:  Table [cm].[ReportServerSubscriptionParameter]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ReportServerSubscriptionParameter](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ReportServerSubscriptionGUID] [uniqueidentifier] NOT NULL,
	[ParameterName] [nvarchar](255) NOT NULL,
	[ParameterValue] [nvarchar](255) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ReportServerSubscriptionParameter] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ReportServerSubscriptionParameter] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ReportServerSubscriptionParameter] TO [cmRead] AS [dbo]
GO
ALTER TABLE [cm].[ReportServerSubscriptionParameter] ADD  CONSTRAINT [DF_cm_ReportServerSubscriptionParameter_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ReportServerSubscriptionParameter]  ADD  CONSTRAINT [FK_ReportServerSubscriptionParameter_ReportServerSubscription] FOREIGN KEY([ReportServerSubscriptionGUID])
REFERENCES [cm].[ReportServerSubscription] ([objectGUID])
GO
ALTER TABLE [cm].[ReportServerSubscriptionParameter] CHECK CONSTRAINT [FK_ReportServerSubscriptionParameter_ReportServerSubscription]
GO
