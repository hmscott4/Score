USE [SCORE]
GO
/****** Object:  Table [scom].[Alert]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[Alert](
	[AlertId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](2000) NOT NULL,
	[MonitoringObjectId] [uniqueidentifier] NOT NULL,
	[MonitoringClassId] [uniqueidentifier] NOT NULL,
	[MonitoringObjectDisplayName] [ntext] NOT NULL,
	[MonitoringObjectName] [ntext] NULL,
	[MonitoringObjectPath] [nvarchar](max) NULL,
	[MonitoringObjectFullName] [ntext] NOT NULL,
	[IsMonitorAlert] [bit] NOT NULL,
	[ProblemId] [uniqueidentifier] NOT NULL,
	[MonitoringRuleId] [uniqueidentifier] NOT NULL,
	[ResolutionState] [tinyint] NOT NULL,
	[ResolutionStateName] [nvarchar](50) NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[Severity] [tinyint] NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[Owner] [nvarchar](255) NULL,
	[ResolvedBy] [nvarchar](255) NULL,
	[TimeRaised] [datetime2](3) NOT NULL,
	[TimeAdded] [datetime2](3) NOT NULL,
	[LastModified] [datetime2](3) NOT NULL,
	[LastModifiedBy] [nvarchar](255) NOT NULL,
	[TimeResolved] [datetime2](3) NULL,
	[TimeResolutionStateLastModified] [datetime2](3) NOT NULL,
	[CustomField1] [nvarchar](255) NULL,
	[CustomField2] [nvarchar](255) NULL,
	[CustomField3] [nvarchar](255) NULL,
	[CustomField4] [nvarchar](255) NULL,
	[CustomField5] [nvarchar](255) NULL,
	[CustomField6] [nvarchar](255) NULL,
	[CustomField7] [nvarchar](255) NULL,
	[CustomField8] [nvarchar](255) NULL,
	[CustomField9] [nvarchar](255) NULL,
	[CustomField10] [nvarchar](255) NULL,
	[TicketId] [nvarchar](150) NULL,
	[Context] [ntext] NULL,
	[ConnectorId] [uniqueidentifier] NULL,
	[LastModifiedByNonConnector] [datetime2](3) NOT NULL,
	[MonitoringObjectInMaintenanceMode] [bit] NOT NULL,
	[MaintenanceModeLastModified] [datetime2](3) NOT NULL,
	[MonitoringObjectHealthState] [tinyint] NOT NULL,
	[StateLastModified] [datetime2](3) NOT NULL,
	[ConnectorStatus] [int] NOT NULL,
	[TopLevelHostEntityId] [uniqueidentifier] NULL,
	[RepeatCount] [int] NOT NULL,
	[AlertStringId] [uniqueidentifier] NULL,
	[AlertStringName] [nvarchar](max) NULL,
	[LanguageCode] [nvarchar](3) NULL,
	[AlertStringDescription] [ntext] NULL,
	[AlertParams] [ntext] NULL,
	[SiteName] [nvarchar](255) NULL,
	[TfsWorkItemId] [nvarchar](150) NULL,
	[TfsWorkItemOwner] [nvarchar](255) NULL,
	[HostID] [int] NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_scom_Alert] PRIMARY KEY CLUSTERED 
(
	[AlertId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GRANT SELECT ON [scom].[Alert] TO [scomRead] AS [dbo]
GO
GRANT SELECT ON [scom].[Alert] TO [scomUpdate] AS [dbo]
GO
