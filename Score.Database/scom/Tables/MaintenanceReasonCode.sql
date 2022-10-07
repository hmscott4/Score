﻿CREATE TABLE [scom].[MaintenanceReasonCode] (
    [Id]         UNIQUEIDENTIFIER NOT NULL,
    [ReasonCode] SMALLINT         NOT NULL,
    [Reason]     NVARCHAR (255)   NOT NULL,
    [Active]     BIT              NOT NULL,
    [dbAddDate]  DATETIME2 (3)    NOT NULL,
    [dbModDate]  DATETIME2 (3)    NOT NULL
);

