CREATE TABLE [dbo].[ReportContent] (
    [Id]             INT              IDENTITY (1, 1) NOT NULL,
    [ReportId]       UNIQUEIDENTIFIER NOT NULL,
    [SortSequence]   INT              NOT NULL,
    [ItemBackground] NVARCHAR (7)     NOT NULL,
    [ItemFont]       NVARCHAR (255)   NOT NULL,
    [ItemFontSize]   NVARCHAR (7)     NOT NULL,
    [ItemFontColor]  NVARCHAR (7)     NOT NULL,
	[ItemDisplay]    NVARCHAR(1024)   NOT NULL,
    [ItemParameters] NVARCHAR (MAX)   NULL,
    [dbAddDate]      DATETIME2 (3)    CONSTRAINT [DF_ReportContent_dbAddDate] DEFAULT (getdate()) NOT NULL,
    [dbModDate]      DATETIME2 (3)    CONSTRAINT [DF_ReportCon_dbModDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ReportContent] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ReportContent_ReportHeader] FOREIGN KEY ([ReportId]) REFERENCES [dbo].[ReportHeader] ([Id])
);







GO
CREATE NONCLUSTERED INDEX [IXu_ReportContent]
    ON [dbo].[ReportContent]([ReportId] ASC, [SortSequence] ASC);

