CREATE TABLE [dbo].[ProcessLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Severity] [nvarchar](50) NOT NULL,
	[Process] [nvarchar](50) NOT NULL,
	[Object] [nvarchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[MessageDate] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_ProcessLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
