CREATE TABLE [ad].[Group] (
    [objectGUID]        UNIQUEIDENTIFIER NOT NULL,
    [SID]               NVARCHAR (255)   NOT NULL,
    [Domain]            NVARCHAR (128)   NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [Scope]             NVARCHAR (255)   NOT NULL,
    [Category]          NVARCHAR (255)   NOT NULL,
    [Description]       NVARCHAR (2048)  NULL,
    [Email]             NVARCHAR (255)   NULL,
    [DistinguishedName] NVARCHAR (255)   NOT NULL,
    [whenCreated]       DATETIME2 (3)    NOT NULL,
    [whenChanged]       DATETIME2 (3)    NOT NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_Group] PRIMARY KEY CLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Group_Unique]
    ON [ad].[Group]([DistinguishedName] ASC);

