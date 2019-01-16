/****** Object:  Table [cm].[Service]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[Service](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Description] [nvarchar](2048) NULL,
	[Status] [nvarchar](128) NULL,
	[State] [nvarchar](128) NULL,
	[StartMode] [nvarchar](128) NULL,
	[StartName] [nvarchar](255) NULL,
	[PathName] [nvarchar](255) NULL,
	[AcceptStop] [bit] NOT NULL,
	[AcceptPause] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Service] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[Service] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Service] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_Service_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Service_Unique] ON [cm].[Service]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[Service] ADD  CONSTRAINT [DF_cm_Service_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[Service]  ADD  CONSTRAINT [FK_Service_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[Service] CHECK CONSTRAINT [FK_Service_Computer]
GO
