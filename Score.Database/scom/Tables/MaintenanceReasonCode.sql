CREATE TABLE [scom].[MaintenanceReasonCode](
	[Id] [uniqueidentifier] NOT NULL DEFAULT NewId(),
	[ReasonCode] [smallint] NOT NULL,
	[Reason] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbModDate] [datetime2](3) NOT NULL
) ON [PRIMARY]
GO

