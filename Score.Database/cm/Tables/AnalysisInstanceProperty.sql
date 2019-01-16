/****** Object:  Table [cm].[AnalysisInstanceProperty]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[AnalysisInstanceProperty](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[AnalysisInstanceGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[Category] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NOT NULL,
	[Type] [nvarchar](32) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_AnalysisInstanceProperty] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_cm_AnalysisInstanceProperty_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_AnalysisInstanceProperty_Unique] ON [cm].[AnalysisInstanceProperty]
(
	[AnalysisInstanceGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[AnalysisInstanceProperty] ADD  CONSTRAINT [DF_cm_AnalysisInstanceProperty_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[AnalysisInstanceProperty]  ADD  CONSTRAINT [FK_AnalysisInstanceProperty_AnalysisInstance] FOREIGN KEY([AnalysisInstanceGUID])
REFERENCES [cm].[AnalysisInstance] ([objectGUID])
GO
ALTER TABLE [cm].[AnalysisInstanceProperty] CHECK CONSTRAINT [FK_AnalysisInstanceProperty_AnalysisInstance]
GO
