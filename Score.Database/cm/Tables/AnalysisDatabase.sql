CREATE TABLE [cm].[AnalysisDatabase] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_AnalysisDatabase_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [AnalysisInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [DatabaseName]         NVARCHAR (128)   NOT NULL,
    [Description]          NVARCHAR (1024)  NULL,
    [UpdateAbility]        NVARCHAR (128)   NOT NULL,
    [EstimatedSize]        BIGINT           NOT NULL,
    [CreateDate]           DATETIME2 (3)    NOT NULL,
    [LastProcessedDate]    DATETIME2 (3)    NULL,
    [LastSchemaUpdate]     DATETIME2 (3)    NULL,
    [Collation]            NVARCHAR (128)   NOT NULL,
    [State]                NVARCHAR (128)   NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_AnalysisDatabase] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_AnalysisDatabase_AnalysisInstance] FOREIGN KEY ([AnalysisInstanceGUID]) REFERENCES [cm].[AnalysisInstance] ([objectGUID])
);

