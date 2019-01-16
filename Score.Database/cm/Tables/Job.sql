/****** Object:  Table [cm].[Job]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[Job](
	[JobID] [uniqueidentifier] NOT NULL,
	[DatabaseInstanceGUID] [uniqueidentifier] NOT NULL,
	[OriginatingServer] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[Description] [nvarchar](2048) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[Owner] [nvarchar](255) NOT NULL,
	[DateCreated] [datetime2](3) NULL,
	[DateModified] [datetime2](3) NULL,
	[VersionNumber] [int] NOT NULL,
	[LastRunDate] [datetime2](3) NULL,
	[NextRunDate] [datetime2](3) NULL,
	[CurrentRunStatus] [nvarchar](128) NOT NULL,
	[LastRunOutcome] [nvarchar](128) NOT NULL,
	[HasSchedule] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Job] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[Job] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Job] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_Job_DatabaseInstanceGUID]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE NONCLUSTERED INDEX [IX_Job_DatabaseInstanceGUID] ON [cm].[Job]
(
	[DatabaseInstanceGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[Job]  ADD  CONSTRAINT [FK_Job_DatabaseInstance] FOREIGN KEY([DatabaseInstanceGUID])
REFERENCES [cm].[DatabaseInstance] ([objectGUID])
GO
ALTER TABLE [cm].[Job] CHECK CONSTRAINT [FK_Job_DatabaseInstance]
GO
