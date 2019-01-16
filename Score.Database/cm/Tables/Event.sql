/****** Object:  Table [cm].[Event]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[Event](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[LogName] [nvarchar](255) NOT NULL,
	[MachineName] [nvarchar](255) NOT NULL,
	[EventId] [int] NOT NULL,
	[Source] [nvarchar](255) NOT NULL,
	[TimeGenerated] [datetime2](3) NOT NULL,
	[EntryType] [nvarchar](128) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[UserName] [nvarchar](255) NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_Event] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[Event] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[Event] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_Event_ComputerGUID_LogName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE NONCLUSTERED INDEX [IX_Event_ComputerGUID_LogName] ON [cm].[Event]
(
	[ComputerGUID] ASC,
	[LogName] ASC
)
INCLUDE ( 	[TimeGenerated]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
