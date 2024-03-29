﻿CREATE TABLE [scom].[Agent] (
    [AgentID]                  UNIQUEIDENTIFIER   NOT NULL,
    [Name]                     NVARCHAR (255)     NOT NULL,
    [DisplayName]              NVARCHAR (1024)    NOT NULL,
    [Domain]                   NVARCHAR (255)     NOT NULL,
    [ManagementGroup]          NVARCHAR (255)     NOT NULL,
    [PrimaryManagementServer]  NVARCHAR (255)     NOT NULL,
    [Version]                  NVARCHAR (255)     NOT NULL,
    [PatchList]                NVARCHAR (255)     NOT NULL,
    [ComputerName]             NVARCHAR (255)     NOT NULL,
    [HealthState]              NVARCHAR (255)     NOT NULL,
    [InstalledBy]              NVARCHAR (255)     NOT NULL,
    [InstallTime]              DATETIMEOFFSET (3) NOT NULL,
    [ManuallyInstalled]        BIT                NOT NULL,
    [ProxyingEnabled]          BIT                NOT NULL,
    [IPAddress]                NVARCHAR (1024)    NULL,
    [LastModified]             DATETIMEOFFSET (3) NOT NULL,
    [IsAvailable]              BIT                NULL,
    [AvailabilityLastModified] DATETIMEOFFSET (3) NULL,
    [Active]                   BIT                NOT NULL,
    [dbAddDate]                DATETIME2 (3)      NOT NULL,
    [dbLastUpdate]             DATETIME2 (3)      NOT NULL,
    CONSTRAINT [PK_scom_Agent] PRIMARY KEY NONCLUSTERED ([AgentID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IX_scom_Agent_Domain]
    ON [scom].[Agent]([Domain] ASC) WITH (FILLFACTOR = 80);


GO
CREATE CLUSTERED INDEX [IX_scom_Agent_Name]
    ON [scom].[Agent]([Name] ASC) WITH (FILLFACTOR = 80);

