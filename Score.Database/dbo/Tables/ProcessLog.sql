CREATE TABLE [dbo].[ProcessLog] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Severity]    NVARCHAR (50)  NULL,
    [Process]     NVARCHAR (50)  NULL,
    [Object]      NVARCHAR (255) NULL,
    [Message]     NVARCHAR (MAX) NULL,
    [MessageDate] DATETIME2 (3)  NULL,
    CONSTRAINT [PK_ProcessLog] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100)
);

