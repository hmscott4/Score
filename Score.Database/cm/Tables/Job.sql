CREATE TABLE [cm].[Job] (
    [JobID]                UNIQUEIDENTIFIER NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [OriginatingServer]    NVARCHAR (255)   NOT NULL,
    [Name]                 NVARCHAR (255)   NOT NULL,
    [IsEnabled]            BIT              NOT NULL,
    [Description]          NVARCHAR (2048)  NOT NULL,
    [Category]             NVARCHAR (255)   NOT NULL,
    [Owner]                NVARCHAR (255)   NOT NULL,
    [DateCreated]          DATETIME2 (3)    NULL,
    [DateModified]         DATETIME2 (3)    NULL,
    [VersionNumber]        INT              NOT NULL,
    [LastRunDate]          DATETIME2 (3)    NULL,
    [NextRunDate]          DATETIME2 (3)    NULL,
    [CurrentRunStatus]     NVARCHAR (128)   NOT NULL,
    [LastRunOutcome]       NVARCHAR (128)   NOT NULL,
    [HasSchedule]          BIT              NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Job] PRIMARY KEY CLUSTERED ([JobID] ASC),
    CONSTRAINT [FK_Job_DatabaseInstance] FOREIGN KEY ([DatabaseInstanceGUID]) REFERENCES [cm].[DatabaseInstance] ([objectGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Job_DatabaseInstanceGUID]
    ON [cm].[Job]([DatabaseInstanceGUID] ASC);

