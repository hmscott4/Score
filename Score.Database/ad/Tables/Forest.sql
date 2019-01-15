CREATE TABLE [ad].[Forest] (
    [Name]               NVARCHAR (128)  NOT NULL,
    [DomainNamingMaster] NVARCHAR (128)  NOT NULL,
    [SchemaMaster]       NVARCHAR (128)  NOT NULL,
    [RootDomain]         NVARCHAR (128)  NOT NULL,
    [ForestMode]         NVARCHAR (128)  NULL,
    [UserName]           NVARCHAR (128)  NULL,
    [Password]           VARBINARY (256) NULL,
    [Active]             BIT             NOT NULL,
    [dbAddDate]          DATETIME2 (3)   NULL,
    [dbLastUpdate]       DATETIME2 (3)   NULL,
    CONSTRAINT [PK_Forest] PRIMARY KEY CLUSTERED ([Name] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Forest_Unique]
    ON [ad].[Forest]([Name] ASC);

