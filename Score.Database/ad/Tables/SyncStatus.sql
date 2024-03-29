﻿CREATE TABLE [ad].[SyncStatus] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Domain]      NVARCHAR (128) NOT NULL,
    [ObjectClass] NVARCHAR (128) NOT NULL,
    [SyncType]    NVARCHAR (64)  NOT NULL,
    [StartDate]   DATETIME2 (3)  NULL,
    [EndDate]     DATETIME2 (3)  NULL,
    [Count]       INT            NULL,
    [Status]      NVARCHAR (128) NULL,
    CONSTRAINT [PK_ad_SyncStatus] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_SyncStatus_Unique]
    ON [ad].[SyncStatus]([Domain] ASC, [ObjectClass] ASC);

