CREATE TABLE [cm].[AnalysisDatabaseCube] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_AnalysisDatabaseCube_objectGUID] DEFAULT (newid()) NOT NULL,
    [AnalysisInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [DatabaseName]         NVARCHAR (128)   NOT NULL,
    [CubeName]             NVARCHAR (128)   NOT NULL,
    [Description]          NVARCHAR (1024)  NULL,
    [CreateDate]           DATETIME2 (3)    NOT NULL,
    [LastProcessedDate]    DATETIME2 (3)    NULL,
    [LastSchemaUpdate]     DATETIME2 (3)    NULL,
    [Collation]            NVARCHAR (128)   NOT NULL,
    [StorageLocation]      NVARCHAR (255)   NULL,
    [StorageMode]          NVARCHAR (128)   NULL,
    [State]                NVARCHAR (128)   NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_AnalysisDatabaseCube] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_AnalysisDatabaseCube_AnalysisInstance] FOREIGN KEY ([AnalysisInstanceGUID]) REFERENCES [cm].[AnalysisInstance] ([objectGUID])
);

