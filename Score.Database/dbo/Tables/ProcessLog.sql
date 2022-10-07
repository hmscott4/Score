CREATE TABLE [dbo].[ProcessLog] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Severity]    NVARCHAR (50)  NOT NULL,
    [Process]     NVARCHAR (50)  NOT NULL,
    [Object]      NVARCHAR (255) NOT NULL,
    [Message]     NVARCHAR (MAX) NOT NULL,
    [MessageDate] DATETIME2 (3)  NOT NULL,
    CONSTRAINT [PK_ProcessLog] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100)
);

