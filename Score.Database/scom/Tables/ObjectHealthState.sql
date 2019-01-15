CREATE TABLE [scom].[ObjectHealthState] (
    [ID]                       UNIQUEIDENTIFIER NOT NULL,
    [Name]                     NVARCHAR (255)   NOT NULL,
    [DisplayName]              NVARCHAR (1024)  NULL,
    [FullName]                 NVARCHAR (1024)  NULL,
    [Path]                     NVARCHAR (1024)  NULL,
    [HealthState]              NVARCHAR (128)   NOT NULL,
    [ManagementGroup]          NVARCHAR (128)   NOT NULL,
    [IsAvailable]              BIT              NOT NULL,
    [InMaintenanceMode]        BIT              NOT NULL,
    [AvailabilityLastModified] DATETIME2 (3)    NULL,
    [LastModified]             DATETIME2 (3)    NULL,
    [LastModifiedBy]           NVARCHAR (255)   NULL,
    [StateLastModified]        DATETIME2 (3)    NULL,
    [ObjectClass]              NVARCHAR (255)   NOT NULL,
    [Active]                   BIT              NOT NULL,
    [dbAddDate]                DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]             DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_scom_ObjectHealthState] PRIMARY KEY CLUSTERED ([ID] ASC)
);

