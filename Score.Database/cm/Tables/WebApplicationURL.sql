CREATE TABLE [cm].[WebApplicationURL] (
    [objectGUID]            UNIQUEIDENTIFIER CONSTRAINT [DF_WebApplicationURL_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [WebApplicationGUID]    UNIQUEIDENTIFIER NOT NULL,
    [ComputerGUID]          UNIQUEIDENTIFIER NOT NULL,
    [Name]                  NVARCHAR (255)   NOT NULL,
    [URL]                   NVARCHAR (2048)  NOT NULL,
    [UseDefaultCredential]  BIT              NOT NULL,
    [FormData]              NVARCHAR (2048)  NULL,
    [LastStatusCode]        NVARCHAR (128)   CONSTRAINT [DF_WebApplicationURL_LastStatusCode] DEFAULT (N'') NOT NULL,
    [LastStatusDescription] NVARCHAR (128)   CONSTRAINT [DF_WebApplicationURL_LastStatusDescription] DEFAULT (N'') NOT NULL,
    [LastResponseTime]      INT              CONSTRAINT [DF_WebApplicationURL_LastResponseTime] DEFAULT ((0)) NOT NULL,
    [LastUpdate]            DATETIME2 (3)    CONSTRAINT [DF_WebApplicationURL_LastUpdate] DEFAULT (getdate()) NOT NULL,
    [Active]                BIT              NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]          DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_WebApplicationURL] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

