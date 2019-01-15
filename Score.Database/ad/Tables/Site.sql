CREATE TABLE [ad].[Site] (
    [objectGUID]        UNIQUEIDENTIFIER NOT NULL,
    [Domain]            NVARCHAR (128)   NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [Description]       NVARCHAR (1024)  NULL,
    [Location]          NVARCHAR (1024)  NULL,
    [DistinguishedName] NVARCHAR (255)   NOT NULL,
    [whenCreated]       DATETIME2 (3)    NOT NULL,
    [whenChanged]       DATETIME2 (3)    NOT NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_Site] PRIMARY KEY CLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Site_Unique]
    ON [ad].[Site]([DistinguishedName] ASC);

