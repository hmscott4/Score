CREATE TABLE [cm].[Event] (
    [ID]            INT              IDENTITY (1, 1) NOT NULL,
    [ComputerGUID]  UNIQUEIDENTIFIER NOT NULL,
    [LogName]       NVARCHAR (255)   NOT NULL,
    [MachineName]   NVARCHAR (255)   NOT NULL,
    [EventId]       INT              NOT NULL,
    [Source]        NVARCHAR (255)   NOT NULL,
    [TimeGenerated] DATETIME2 (3)    NOT NULL,
    [EntryType]     NVARCHAR (128)   NOT NULL,
    [Message]       NVARCHAR (MAX)   NOT NULL,
    [UserName]      NVARCHAR (255)   NULL,
    [dbAddDate]     DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Event] PRIMARY KEY CLUSTERED ([ID] ASC)
);

