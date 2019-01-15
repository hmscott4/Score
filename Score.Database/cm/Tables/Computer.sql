﻿CREATE TABLE [cm].[Computer] (
    [objectGUID]                UNIQUEIDENTIFIER CONSTRAINT [DF_cm_Computer_objectGUID] DEFAULT (newid()) NOT NULL,
    [Domain]                    NVARCHAR (128)   NOT NULL,
    [dnsHostName]               NVARCHAR (255)   NOT NULL,
    [netBIOSName]               NVARCHAR (255)   NOT NULL,
    [IPv4Address]               NVARCHAR (128)   NULL,
    [DomainRole]                NVARCHAR (128)   NULL,
    [CurrentTimeZone]           INT              NULL,
    [DaylightInEffect]          BIT              NULL,
    [Status]                    NVARCHAR (50)    NULL,
    [Manufacturer]              NVARCHAR (128)   NULL,
    [Model]                     NVARCHAR (128)   NULL,
    [PCSystemType]              NVARCHAR (128)   NULL,
    [SystemType]                NVARCHAR (128)   NULL,
    [AssetTag]                  NVARCHAR (128)   NULL,
    [SerialNumber]              NVARCHAR (128)   NULL,
    [TotalPhysicalMemory]       BIGINT           NULL,
    [NumberOfLogicalProcessors] INT              NULL,
    [NumberOfProcessors]        INT              NULL,
    [IsVirtual]                 BIT              CONSTRAINT [DF_cm_Computer_Virtual] DEFAULT ((0)) NOT NULL,
    [PendingReboot]             BIT              NOT NULL,
    [Active]                    BIT              CONSTRAINT [DF_dm_Computer_Active] DEFAULT ((1)) NOT NULL,
    [IsClusterResource]         BIT              CONSTRAINT [DF_cm_Computer_IsClusterResource] DEFAULT ((0)) NULL,
    [dbAddDate]                 DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]              DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Computer] PRIMARY KEY NONCLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_cm_Computer_Unique]
    ON [cm].[Computer]([dnsHostName] ASC);

