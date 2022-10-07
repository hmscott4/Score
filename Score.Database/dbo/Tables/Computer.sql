CREATE TABLE [dbo].[Computer] (
    [ID]             UNIQUEIDENTIFIER CONSTRAINT [DF_Computer_ID] DEFAULT (newid()) NOT NULL,
    [Domain]         NVARCHAR (128)   NOT NULL,
    [dnsHostName]    NVARCHAR (255)   NOT NULL,
    [CredentialName] NVARCHAR (255)   NULL,
    [AgentName]      NVARCHAR (128)   NOT NULL,
    [Active]         BIT              NOT NULL,
    [dbAddDate]      DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]   DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_Computer] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Computer_Unique]
    ON [dbo].[Computer]([Domain] ASC, [dnsHostName] ASC);

