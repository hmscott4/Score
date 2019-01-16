/****** Object:  Table [cm].[ComputerGroupMember]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [cm].[ComputerGroupMember](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[ComputerGUID] [uniqueidentifier] NOT NULL,
	[GroupName] [nvarchar](128) NOT NULL,
	[MemberName] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_cm_ComputerGroupMember] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [cm].[ComputerGroupMember] TO [cmRead] AS [dbo]
GO
GRANT SELECT ON [cm].[ComputerGroupMember] TO [cmRead] AS [dbo]
GO
/****** Object:  Index [IX_cm_ComputerGroupMember_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_ComputerGroupMember_Unique] ON [cm].[ComputerGroupMember]
(
	[ComputerGUID] ASC,
	[GroupName] ASC,
	[MemberName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [cm].[ComputerGroupMember] ADD  CONSTRAINT [DF_cm_ComputerGroupMember_objectGUID]  DEFAULT (newid()) FOR [objectGUID]
GO
ALTER TABLE [cm].[ComputerGroupMember]  ADD  CONSTRAINT [FK_ComputerGroupMember_Computer] FOREIGN KEY([ComputerGUID])
REFERENCES [cm].[Computer] ([objectGUID])
GO
ALTER TABLE [cm].[ComputerGroupMember] CHECK CONSTRAINT [FK_ComputerGroupMember_Computer]
GO
