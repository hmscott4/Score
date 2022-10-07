CREATE TABLE [scom].[AlertResolutionState] (
    [ResolutionStateID] UNIQUEIDENTIFIER NOT NULL,
    [ResolutionState]   TINYINT          NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [IsSystem]          BIT              NOT NULL,
    [ManagementGroup]   NVARCHAR (255)   NOT NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    [IsOpen]            BIT              DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_scom_AlertResolutionState] PRIMARY KEY NONCLUSTERED ([ResolutionStateID] ASC) WITH (FILLFACTOR = 80)
);

