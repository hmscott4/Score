﻿CREATE TABLE [ad].[ComputerImport] (
    [Description]                VARCHAR (1024) NULL,
    [DNSHostName]                VARCHAR (255)  NULL,
    [DistinguishedName]          VARCHAR (1024) NULL,
    [Enabled]                    BIT            NULL,
    [IPv4Address]                VARCHAR (128)  NULL,
    [LastLogonDate]              DATETIME2 (3)  NULL,
    [LastLogonTimeStamp]         VARCHAR (255)  NULL,
    [Name]                       VARCHAR (255)  NULL,
    [ObjectClass]                VARCHAR (255)  NULL,
    [objectGUID]                 VARCHAR (128)  NULL,
    [OperatingSystem]            VARCHAR (128)  NULL,
    [OperatingSystemServicePack] VARCHAR (128)  NULL,
    [OperatingSystemVersion]     VARCHAR (128)  NULL,
    [SamAccountName]             VARCHAR (255)  NULL,
    [SID]                        VARCHAR (255)  NULL,
    [Trusted]                    BIT            NULL,
    [UserPrincipalName]          VARCHAR (255)  NULL,
    [whenCreated]                DATETIME2 (3)  NULL,
    [whenChanged]                DATETIME2 (3)  NULL
);

