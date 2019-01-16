USE [SCORE]
GO
/****** Object:  Table [scom].[ObjectAlertRelationship]    Script Date: 1/16/2019 8:32:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scom].[ObjectAlertRelationship](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[AlertID] [uniqueidentifier] NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_scom_ObjectAlertRelationship] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[AlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT REFERENCES ON [scom].[ObjectAlertRelationship] TO [scomRead] AS [dbo]
GO
GRANT SELECT ON [scom].[ObjectAlertRelationship] TO [scomRead] AS [dbo]
GO
GRANT REFERENCES ON [scom].[ObjectAlertRelationship] TO [scomUpdate] AS [dbo]
GO
GRANT SELECT ON [scom].[ObjectAlertRelationship] TO [scomUpdate] AS [dbo]
GO
