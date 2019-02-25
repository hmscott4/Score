CREATE TABLE [scom].[ObjectHealthState](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](255) NOT NULL,
	[Path] [nvarchar](1024) NULL,
	[ObjectClass] [nvarchar](255) NOT NULL,
	[HealthState] [nvarchar](255) NOT NULL,
	[StateLastModified] DATETIMEOFFSET(3) NULL,
	[IsAvailable] [bit] NOT NULL,
	[AvailabilityLastModified] DATETIMEOFFSET(3) NULL,
	[InMaintenanceMode] [bit] NOT NULL,
	[MaintenanceModeLastModified] DATETIMEOFFSET(3) NULL,
	[Active] [bit] NOT NULL,
	[dbAddDate] [datetime2](3) NOT NULL,
	[dbLastUpdate] [datetime2](3) NOT NULL,
	[ManagementGroup] [nvarchar](255) NOT NULL,
	[Availability] [nvarchar](255) NULL,
	[Configuration] [nvarchar](255) NULL,
	[Performance] [nvarchar](255) NULL,
	[Security] [nvarchar](255) NULL,
	[Other] [nvarchar](255) NULL,
 CONSTRAINT [PK_scom_Object] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [UX_scom_Object_FullName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE CLUSTERED INDEX [UX_scom_Object_FullName] ON [scom].[ObjectHealthState]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
