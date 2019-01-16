
/****** Object:  Table [ad].[GroupMember]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [ad].[GroupMember](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[GroupGUID] [uniqueidentifier] NOT NULL,
	[MemberGUID] [uniqueidentifier] NOT NULL,
	[MemberType] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbLastUpdate] [datetime2](3) NULL,
 CONSTRAINT [PK_ad_GroupMember] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_ad_GroupMember_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_GroupMember_Unique] ON [ad].[GroupMember]
(
	[Domain] ASC,
	[GroupGUID] ASC,
	[MemberGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
