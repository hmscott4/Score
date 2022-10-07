CREATE TABLE [scom].[ObjectHealthState] (
    [ID]                          UNIQUEIDENTIFIER NOT NULL,
    [Name]                        NVARCHAR (255)   NOT NULL,
    [DisplayName]                 NVARCHAR (255)   NOT NULL,
    [FullName]                    NVARCHAR (255)   NOT NULL,
    [Path]                        NVARCHAR (1024)  NULL,
    [ObjectClass]                 NVARCHAR (255)   NOT NULL,
    [HealthState]                 NVARCHAR (255)   NOT NULL,
    [StateLastModified]           DATETIME2 (3)    NULL,
    [IsAvailable]                 BIT              NOT NULL,
    [AvailabilityLastModified]    DATETIME2 (3)    NULL,
    [InMaintenanceMode]           BIT              NOT NULL,
    [MaintenanceModeLastModified] DATETIME2 (3)    NULL,
    [Active]                      BIT              NOT NULL,
    [dbAddDate]                   DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]                DATETIME2 (3)    NOT NULL,
    [ManagementGroup]             NVARCHAR (255)   NOT NULL,
    [Availability]                NVARCHAR (255)   NULL,
    [Configuration]               NVARCHAR (255)   NULL,
    [Performance]                 NVARCHAR (255)   NULL,
    [Security]                    NVARCHAR (255)   NULL,
    [Other]                       NVARCHAR (255)   NULL,
    [AssetStatus]                 NVARCHAR (255)   NULL,
    [Notes]                       NVARCHAR (4000)  NULL,
    CONSTRAINT [PK_scom_Object] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE CLUSTERED INDEX [UX_scom_Object_FullName]
    ON [scom].[ObjectHealthState]([FullName] ASC) WITH (FILLFACTOR = 80);

