CREATE TABLE [dbo].[ReportHeader] (
    [Id]                    UNIQUEIDENTIFIER CONSTRAINT [DF_scom_ReportHeader_Id] DEFAULT (newid()) NOT NULL,
    [ReportName]            NVARCHAR (255)   NOT NULL,
    [ReportDisplayName]     NVARCHAR (255)   NOT NULL,
    [ReportBackground]      NVARCHAR (7)     NOT NULL,
    [TitleBackground]       NVARCHAR (7)     NOT NULL,
    [TitleFont]             NVARCHAR (255)   NOT NULL,
    [TitleFontColor]        NVARCHAR (7)     NOT NULL,
    [TitleFontSize]         NVARCHAR (5)     NOT NULL,
    [SubTitleBackground]    NVARCHAR (7)     NOT NULL,
    [SubTitleFont]          NVARCHAR (255)   NOT NULL,
    [SubTitleFontColor]     NVARCHAR (7)     NOT NULL,
    [SubTitleFontSize]      NVARCHAR (5)     NOT NULL,
    [TableHeaderBackground] NVARCHAR (7)     NOT NULL,
    [TableHeaderFont]       NVARCHAR (255)   NOT NULL,
    [TableHeaderFontColor]  NVARCHAR (7)     NOT NULL,
    [TableHeaderFontSize]   NVARCHAR (5)     NOT NULL,
    [TableFooterBackground] NVARCHAR (7)     NOT NULL,
    [TableFooterFont]       NVARCHAR (255)   NOT NULL,
    [TableFooterFontColor]  NVARCHAR (7)     NOT NULL,
    [TableFooterFontSize]   NVARCHAR (5)     NOT NULL,
    [RowEvenBackground]     NVARCHAR (7)     NOT NULL,
    [RowEvenFont]           NVARCHAR (255)   NOT NULL,
    [RowEvenFontColor]      NVARCHAR (7)     NOT NULL,
    [RowEvenFontSize]       NVARCHAR (5)     NOT NULL,
    [RowOddBackground]      NVARCHAR (7)     NOT NULL,
    [RowOddFont]            NVARCHAR (255)   NOT NULL,
    [RowOddFontColor]       NVARCHAR (7)     NOT NULL,
    [RowOddFontSize]        NVARCHAR (5)     NOT NULL,
    [FooterBackground]      NVARCHAR (7)     NOT NULL,
    [FooterFont]            NVARCHAR (255)   NOT NULL,
    [FooterFontColor]       NVARCHAR (7)     NOT NULL,
    [FooterFontSize]        NVARCHAR (5)     NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    [dbModDate]             DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ReportHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IXu_ReportHeader]
    ON [dbo].[ReportHeader]([ReportName] ASC);

