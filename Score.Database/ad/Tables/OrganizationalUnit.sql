CREATE TABLE [ad].[OrganizationalUnit] (
    [objectGUID]        UNIQUEIDENTIFIER NOT NULL,
    [Domain]            NVARCHAR (128)   NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [Description]       NVARCHAR (1024)  NOT NULL,
    [DistinguishedName] NVARCHAR (1024)  NOT NULL,
    [StreetAddress]     NVARCHAR (255)   NULL,
    [City]              NVARCHAR (255)   NULL,
    [State]             NVARCHAR (255)   NULL,
    [Country]           NVARCHAR (255)   NULL,
    [PostalCode]        NVARCHAR (255)   NULL,
    [Protected]         BIT              NOT NULL,
    [Active]            BIT              NOT NULL,
    [whenCreated]       DATETIME2 (3)    NOT NULL,
    [whenChanged]       DATETIME2 (3)    NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_OrganizationalUnit] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_ad_OrganizationalUnit]
    ON [ad].[OrganizationalUnit]([DistinguishedName] ASC);


GO
GRANT SELECT
    ON OBJECT::[ad].[OrganizationalUnit] TO [adRead]
    AS [dbo];

