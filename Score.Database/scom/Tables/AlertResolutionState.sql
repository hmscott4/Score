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

