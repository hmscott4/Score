﻿CREATE TABLE [dbo].[Credential] (
    [ID]             UNIQUEIDENTIFIER CONSTRAINT [DF_Credential_ID] DEFAULT (newid()) NOT NULL,
    [Name]           NVARCHAR (255)   NOT NULL,
    [CredentialType] NVARCHAR (128)   NOT NULL,
    [AccountName]    NVARCHAR (255)   NOT NULL,
    [Password]       NVARCHAR (512)   NULL,
    [Active]         BIT              NOT NULL,
    [dbAddDate]      DATETIME2 (3)    NULL,
    [dbLastUpdate]   DATETIME2 (3)    NULL,
    CONSTRAINT [PK_Credential] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Credential_Unique]
    ON [dbo].[Credential]([Name] ASC);

