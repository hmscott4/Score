USE [SCORE]
GO
/****** Object:  Table [scom].[AlertResolutionState]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[AlertResolutionState](
	[ResolutionStateID] [uniqueidentifier] NOT NULL,
	[ResolutionState] [tinyint] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ResolutionStateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT SELECT ON [scom].[AlertResolutionState] TO [scomRead] AS [dbo]
GO
GRANT SELECT ON [scom].[AlertResolutionState] TO [scomUpdate] AS [dbo]
GO
