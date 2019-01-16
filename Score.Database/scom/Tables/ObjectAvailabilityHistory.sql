USE [SCORE]
GO
/****** Object:  Table [scom].[ObjectAvailabilityHistory]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectAvailabilityHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ManagedEntityID] [uniqueidentifier] NOT NULL,
	[FullName] [nvarchar](2048) NOT NULL,
	[DateTime] [datetime2](3) NOT NULL,
	[IntervalDurationMilliseconds] [int] NOT NULL,
	[InWhiteStateMilliseconds] [int] NOT NULL,
	[InGreenStateMilliseconds] [int] NOT NULL,
	[InYellowStateMilliseconds] [int] NOT NULL,
	[InRedStateMilliseconds] [int] NOT NULL,
	[InDisabledStateMilliseconds] [int] NOT NULL,
	[InPlannedMaintenanceMilliseconds] [int] NOT NULL,
	[InUnplannedMaintenanceMilliseconds] [int] NOT NULL,
	[HealthServiceUnavailableMilliseconds] [int] NOT NULL,
 CONSTRAINT [PK_ObjectAvailabilityHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT SELECT ON [scom].[ObjectAvailabilityHistory] TO [scomRead] AS [dbo]
GO
/****** Object:  Index [IX_ObjectAvailabilityHistory]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ObjectAvailabilityHistory] ON [scom].[ObjectAvailabilityHistory]
(
	[ManagedEntityID] ASC,
	[DateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
