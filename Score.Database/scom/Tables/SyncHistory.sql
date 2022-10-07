CREATE TABLE [scom].[SyncHistory] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [ManagementGroup] NVARCHAR (255) NOT NULL,
    [ObjectClass]     NVARCHAR (255) NOT NULL,
    [SyncType]        NVARCHAR (255) NOT NULL,
    [StartDate]       DATETIME2 (3)  NULL,
    [EndDate]         DATETIME2 (3)  NULL,
    [Count]           INT            NULL,
    [Status]          NVARCHAR (255) NULL,
    CONSTRAINT [PK_scom_SyncHistory] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);

