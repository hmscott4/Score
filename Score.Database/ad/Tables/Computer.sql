CREATE TABLE [ad].[Computer] (
    [objectGUID]                 UNIQUEIDENTIFIER NOT NULL,
    [SID]                        NVARCHAR (255)   NOT NULL,
    [Domain]                     NVARCHAR (128)   NOT NULL,
    [Name]                       NVARCHAR (255)   NOT NULL,
    [DNSHostName]                NVARCHAR (255)   NOT NULL,
    [IPv4Address]                NVARCHAR (128)   NULL,
    [Trusted]                    BIT              NOT NULL,
    [OperatingSystem]            NVARCHAR (128)   NULL,
    [OperatingSystemVersion]     NVARCHAR (128)   NULL,
    [OperatingSystemServicePack] NVARCHAR (128)   NULL,
    [Description]                NVARCHAR (1024)  NULL,
    [DistinguishedName]          NVARCHAR (255)   NOT NULL,
    [UserAccountControl]         INT              NULL,
    [SupportedEncryptionTypes]   INT              NULL,
    [Enabled]                    BIT              NOT NULL,
    [Active]                     BIT              NOT NULL,
    [LastLogon]                  DATETIME2 (3)    NULL,
    [whenCreated]                DATETIME2 (3)    NOT NULL,
    [whenChanged]                DATETIME2 (3)    NOT NULL,
    [dbAddDate]                  DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]               DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_Computer] PRIMARY KEY CLUSTERED ([DNSHostName] ASC) WITH (FILLFACTOR = 90)
);


GO

