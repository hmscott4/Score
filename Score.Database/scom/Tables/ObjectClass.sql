﻿CREATE TABLE [scom].[ObjectClass] (
    [ID]                     UNIQUEIDENTIFIER NOT NULL,
    [Name]                   NVARCHAR (255)   NOT NULL,
    [DisplayName]            NVARCHAR (255)   NOT NULL,
    [GenericName]            NVARCHAR (255)   NOT NULL,
    [ManagementPackName]     NVARCHAR (255)   NOT NULL,
    [Description]            NVARCHAR (1024)  NULL,
    [DistributedApplication] BIT              NULL,
    [Active]                 BIT              NOT NULL,
    [dbAddDate]              DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]           DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_scom_ObjectClass] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE CLUSTERED INDEX [UX_scom_ObjectClass_Name]
    ON [scom].[ObjectClass]([Name] ASC) WITH (FILLFACTOR = 80);

