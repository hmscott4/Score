CREATE TABLE [ad].[Subnet] (
    [objectGUID]        UNIQUEIDENTIFIER NOT NULL,
    [Domain]            NVARCHAR (128)   NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [Description]       NVARCHAR (1024)  NULL,
    [Location]          NVARCHAR (1024)  NULL,
    [Site]              NVARCHAR (255)   NULL,
    [DistinguishedName] NVARCHAR (255)   NOT NULL,
    [whenCreated]       DATETIME2 (3)    NOT NULL,
    [whenChanged]       DATETIME2 (3)    NOT NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_Subnet] PRIMARY KEY CLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Subnet_Unique]
    ON [ad].[Subnet]([DistinguishedName] ASC);

