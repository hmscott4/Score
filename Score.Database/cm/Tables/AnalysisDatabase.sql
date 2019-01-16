/****** Object:  Table [cm].[AnalysisDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[AnalysisDatabase](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[AnalysisInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[UpdateAbility] [nvarchar](128) NOT NULL,
	[EstimatedSize] [bigint] NOT NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[LastProcessedDate] [datetime2](3) NULL,
	[LastSchemaUpdate] [datetime2](3) NULL,
	[Collation] [nvarchar](128) NOT NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisDatabase] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_cm_AnalysisDatabase_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisDatabase_Unique] ON [cm].[AnalysisDatabase]
(
	[AnalysisInstanceGUID] ASC,
	[DatabaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[AnalysisDatabase] ADD  CONSTRAINT [DF_cm_AnalysisDatabase_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[AnalysisDatabase]  ADD  CONSTRAINT [FK_AnalysisDatabase_AnalysisInstance] FOREIGN KEY([AnalysisInstanceGUID])
REFERENCES [cm].[AnalysisInstance] ([objectGUID])
GO
ALTER TABLE [cm].[AnalysisDatabase] CHECK CONSTRAINT [FK_AnalysisDatabase_AnalysisInstance]
GO
