CREATE TABLE [dbo].[ReportContent] (
    [Id]             INT              IDENTITY (1, 1) NOT NULL,
    [ReportId]       UNIQUEIDENTIFIER NOT NULL,
    [SortSequence]   INT              NOT NULL,
    [ItemBackground] INT              NOT NULL,
    [ItemFont]       NVARCHAR (255)   NOT NULL,
    [ItemFontSize]   INT              NOT NULL,
    [ItemFontColor]  INT              NOT NULL,
    [ItemParameters] NVARCHAR (MAX)   NULL,
    [dbAddDate]      DATETIME2 (3)    DEFAULT (getdate()) NOT NULL,
    [dbModDate]      DATETIME2 (3)    DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


