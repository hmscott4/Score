CREATE TABLE [pm].[DatabaseSizeDaily] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [Date]              DATE             NOT NULL,
    [DatabaseGUID]      UNIQUEIDENTIFIER NOT NULL,
    [DataFileSize]      BIGINT           NOT NULL,
    [DataFileSpaceUsed] BIGINT           NOT NULL,
    [LogFileSize]       BIGINT           NOT NULL,
    [LogFileSpaceUsed]  BIGINT           NOT NULL,
    [Count]             INT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_DatabaseSizeDaily] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_DatabaseSizeDaily_Database] FOREIGN KEY ([DatabaseGUID]) REFERENCES [cm].[Database] ([objectGUID])
);

