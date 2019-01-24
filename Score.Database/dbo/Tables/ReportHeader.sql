﻿CREATE TABLE [dbo].[ReportHeader] (
    [Id]                    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ReportName]            NVARCHAR (255)   NOT NULL,
    [ReportDisplayName]     NVARCHAR (255)   NOT NULL,
    [ReportBackground]      INT              NOT NULL,
    [TitleBackground]       INT              NOT NULL,
    [TitleFont]             NVARCHAR (255)   NOT NULL,
    [TitleFontColor]        INT              NOT NULL,
    [TitleFontSize]         INT              NOT NULL,
    [TableHeaderBackground] INT              NOT NULL,
    [TableHeaderFont]       NVARCHAR (255)   NOT NULL,
    [TableHeaderFontColor]  INT              NOT NULL,
    [TableHeaderFontSize]   INT              NOT NULL,
    [TableFooterBackground] INT              NOT NULL,
    [TableFooterFont]       NVARCHAR (255)   NOT NULL,
    [TableFooterFontColor]  INT              NOT NULL,
    [TableFooterFontSize]   INT              NOT NULL,
    [RowEvenBackground]     INT              NOT NULL,
    [RowEvenFont]           NVARCHAR (255)   NOT NULL,
    [RowEvenFontColor]      INT              NOT NULL,
    [RowEvenFontSize]       INT              NOT NULL,
    [RowOddBackground]      INT              NOT NULL,
    [RowOddFont]            NVARCHAR (255)   NOT NULL,
    [RowOddFontColor]       INT              NOT NULL,
    [RowOddFontSize]        INT              NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    [dbModDate]             DATETIME2 (3)    NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


