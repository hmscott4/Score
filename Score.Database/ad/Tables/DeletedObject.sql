USE [SCORE]
GO
/****** Object:  Table [ad].[DeletedObject]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ad].[DeletedObject](
	[objectGUID] [uniqueidentifier] NOT NULL,
	[SID] [nvarchar](255) NOT NULL,
	[Domain] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DistinguishedName] [nvarchar](255) NOT NULL,
	[objectType] [nvarchar](128) NOT NULL,
	[dbAddDate] [datetime2](3) NULL,
	[dbDelDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ad_DeletedObject] PRIMARY KEY CLUSTERED 
(
	[objectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [ad].[DeletedObject] TO [adRead] AS [dbo]
GO
GRANT SELECT ON [ad].[DeletedObject] TO [adRead] AS [dbo]
GO
