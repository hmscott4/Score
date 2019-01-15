CREATE TABLE [cm].[Database] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_Database_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [DatabaseName]         NVARCHAR (128)   NOT NULL,
    [DatabaseID]           INT              NOT NULL,
    [RecoveryModel]        NVARCHAR (128)   NOT NULL,
    [Status]               NVARCHAR (128)   NOT NULL,
    [ReadOnly]             BIT              NOT NULL,
    [UserAccess]           NVARCHAR (128)   NOT NULL,
    [CreateDate]           DATETIME2 (3)    NOT NULL,
    [Owner]                NVARCHAR (128)   NOT NULL,
    [LastFullBackup]       DATETIME2 (3)    NULL,
    [LastDiffBackup]       DATETIME2 (3)    NULL,
    [LastLogBackup]        DATETIME2 (3)    NULL,
    [CompatibilityLevel]   NVARCHAR (128)   NOT NULL,
    [DataFileSize]         BIGINT           CONSTRAINT [DF_cm_Database_DataFileSize] DEFAULT ((0)) NOT NULL,
    [DataFileSpaceUsed]    BIGINT           CONSTRAINT [DF_cm_Database_DataFileSpaceUsed] DEFAULT ((0)) NOT NULL,
    [LogFileSize]          BIGINT           CONSTRAINT [DF_cm_Database_LogFileSize] DEFAULT ((0)) NOT NULL,
    [LogFileSpaceUsed]     BIGINT           CONSTRAINT [DF_cm_Database_LogFileSpaceUsed] DEFAULT ((0)) NOT NULL,
    [VirtualLogFileCount]  INT              CONSTRAINT [DF_cm_Database_VirtualLogFileCount] DEFAULT ((0)) NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Database] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_Database_Unique]
    ON [cm].[Database]([DatabaseInstanceGUID] ASC, [DatabaseName] ASC);

