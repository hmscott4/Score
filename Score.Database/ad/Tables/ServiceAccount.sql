CREATE TABLE [ad].[ServiceAccount] (
    [objectGUID]                          UNIQUEIDENTIFIER NOT NULL,
    [SID]                                 NVARCHAR (255)   NOT NULL,
    [Domain]                              NVARCHAR (128)   NOT NULL,
    [Name]                                NVARCHAR (255)   NOT NULL,
    [DNSHostName]                         NVARCHAR (255)   NOT NULL,
    [Trusted]                             BIT              NOT NULL,
    [Description]                         NVARCHAR (1024)  NULL,
    [DistinguishedName]                   NVARCHAR (255)   NOT NULL,
    [PrincipalsAllowedToRetrievePassword] NVARCHAR (2048)  NULL,
    [UserAccountControl]                  INT              NULL,
    [ServicePrincipalNames]               NVARCHAR (2048)  NOT NULL,
    [SupportedEncryptionTypes]            INT              NULL,
    [Enabled]                             BIT              NOT NULL,
    [Active]                              BIT              NOT NULL,
    [LastLogon]                           DATETIME2 (3)    NULL,
    [whenCreated]                         DATETIME2 (3)    NOT NULL,
    [whenChanged]                         DATETIME2 (3)    NOT NULL,
    [dbAddDate]                           DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]                        DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_ServiceAccount] PRIMARY KEY CLUSTERED ([DistinguishedName] ASC)
);


GO

