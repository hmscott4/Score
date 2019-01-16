/****** Object:  Table [cm].[ComputerShare]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ComputerShare](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](128) NOT NULL,
	[Path] [nvarchar](2048) NOT NULL,
	[Status] [nvarchar](128) NULL,
	[Type] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ComputerShare] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ComputerShare] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ComputerShare] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_ComputerShare_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ComputerShare_Unique] ON [cm].[ComputerShare]
(
	[ComputerGUID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[ComputerShare] ADD  CONSTRAINT [DF_cm_ComputerShare_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ComputerShare]  WITH CHECK ADD  CONSTRAINT [FK_ComputerShare_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[ComputerShare] CHECK CONSTRAINT [FK_ComputerShare_Computer]
GO
