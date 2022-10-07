CREATE TABLE [pm].[WebApplicationURLResponseRaw] (
    [ID]                    INT              IDENTITY (1, 1) NOT NULL,
    [DateTime]              DATETIME2 (3)    NOT NULL,
    [WebApplicationURLGUID] UNIQUEIDENTIFIER NOT NULL,
    [StatusCode]            INT              NOT NULL,
    [StatusDescription]     NVARCHAR (128)   NOT NULL,
    [LastResponseTime]      INT              NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_WebApplicationResponseRaw] PRIMARY KEY CLUSTERED ([ID] ASC)
);

