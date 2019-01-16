/****** Object:  Table [cm].[AnalysisDatabaseCube]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[AnalysisDatabaseCube](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[AnalysisInstanceGUID] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[CubeName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[CreateDate] [datetime2](3) NOT NULL,
	[LastProcessedDate] [datetime2](3) NULL,
	[LastSchemaUpdate] [datetime2](3) NULL,
	[Collation] [nvarchar](128) NOT NULL,
	[StorageLocation] [nvarchar](255) NULL,
	[StorageMode] [nvarchar](128) NULL,
	[State] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisDatabaseCube] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_cm_AnalysisDatabaseCube_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisDatabaseCube_Unique] ON [cm].[AnalysisDatabaseCube]
(
	[AnalysisInstanceGUID] ASC,
	[DatabaseName] ASC,
	[CubeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[AnalysisDatabaseCube] ADD  CONSTRAINT [DF_cm_AnalysisDatabaseCube_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[AnalysisDatabaseCube]  ADD  CONSTRAINT [FK_AnalysisDatabaseCube_AnalysisInstance] FOREIGN KEY([AnalysisInstanceGUID])
REFERENCES [cm].[AnalysisInstance] ([objectGUID])
GO
ALTER TABLE [cm].[AnalysisDatabaseCube] CHECK CONSTRAINT [FK_AnalysisDatabaseCube_AnalysisInstance]
GO
