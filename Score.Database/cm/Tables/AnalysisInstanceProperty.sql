CREATE TABLE [cm].[AnalysisInstanceProperty] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_AnalysisInstanceProperty_objectGUID] DEFAULT (newid()) NOT NULL,
    [AnalysisInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [Name]                 NVARCHAR (128)   NOT NULL,
    [PropertyName]         NVARCHAR (128)   NOT NULL,
    [Category]             NVARCHAR (128)   NOT NULL,
    [PropertyValue]        NVARCHAR (128)   NOT NULL,
    [Type]                 NVARCHAR (32)    NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_AnalysisInstanceProperty] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_AnalysisInstanceProperty_AnalysisInstance] FOREIGN KEY ([AnalysisInstanceGUID]) REFERENCES [cm].[AnalysisInstance] ([objectGUID])
);

