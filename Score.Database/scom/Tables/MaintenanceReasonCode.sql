USE [SCORE]
GO
/****** Object:  Table [scom].[MaintenanceReasonCode]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[MaintenanceReasonCode](
	[Id] [uniqueidentifier] NOT NULL,
	[ReasonCode] [smallint] NOT NULL,
	[Reason] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL
) ON [PRIMARY]
GO
GRANT REFERENCES ON [scom].[MaintenanceReasonCode] TO [scomRead] AS [dbo]
GO
GRANT SELECT ON [scom].[MaintenanceReasonCode] TO [scomRead] AS [dbo]
GO
