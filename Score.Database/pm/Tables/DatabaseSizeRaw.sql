CREATE TABLE [pm].[DatabaseSizeRaw] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [DateTime]          DATETIME2 (3)    NOT NULL,
    [DatabaseGUID]      UNIQUEIDENTIFIER NOT NULL,
    [DataFileSize]      BIGINT           NOT NULL,
    [DataFileSpaceUsed] BIGINT           NOT NULL,
    [LogFileSize]       BIGINT           NOT NULL,
    [LogFileSpaceUsed]  BIGINT           NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_DatabaseSizeRaw] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_DatabaseSizeRaw_Database] FOREIGN KEY ([DatabaseGUID]) REFERENCES [cm].[Database] ([objectGUID])
);

