CREATE TABLE [scom].[AgentExclusions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[DNSHostName] [nvarchar](255) NOT NULL,
	[Reason] [nvarchar](1024) NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_AgentExclusions_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_scom_AgentExclusion_DNSHostName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE NONCLUSTERED INDEX [IX_scom_AgentExclusion_DNSHostName] ON [scom].[AgentExclusions]
(
	[DNSHostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
