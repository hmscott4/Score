CREATE TABLE [ad].[Domain] (
    [objectGUID]           UNIQUEIDENTIFIER NOT NULL,
    [SID]                  NVARCHAR (128)   NOT NULL,
    [Forest]               NVARCHAR (128)   NOT NULL,
    [Name]                 NVARCHAR (128)   NOT NULL,
    [DNSRoot]              NVARCHAR (128)   NOT NULL,
    [NetBIOSName]          NVARCHAR (128)   NOT NULL,
    [DistinguishedName]    NVARCHAR (255)   NOT NULL,
    [InfrastructureMaster] NVARCHAR (128)   NOT NULL,
    [PDCEmulator]          NVARCHAR (128)   NOT NULL,
    [RIDMaster]            NVARCHAR (128)   NOT NULL,
    [DomainFunctionality]  NVARCHAR (128)   NULL,
    [ForestFunctionality]  NVARCHAR (128)   NULL,
    [UserName]             NVARCHAR (128)   NULL,
    [Password]             VARBINARY (256)  NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_Domain] PRIMARY KEY CLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_Domain_Unique]
    ON [ad].[Domain]([DistinguishedName] ASC);

