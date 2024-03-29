﻿CREATE TABLE [cm].[OperatingSystem] (
    [objectGUID]              UNIQUEIDENTIFIER CONSTRAINT [DF_cm_OperatingSystem_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [computerGUID]            UNIQUEIDENTIFIER NOT NULL,
    [IPV4Address]             NVARCHAR (128)   NULL,
    [Manufacturer]            NVARCHAR (255)   NULL,
    [OSArchitecture]          NVARCHAR (128)   NULL,
    [OSType]                  NVARCHAR (128)   NULL,
    [OperatingSystem]         NVARCHAR (128)   NULL,
    [Description]             NVARCHAR (1024)  NULL,
    [Version]                 NVARCHAR (128)   NULL,
    [ServicePack]             NVARCHAR (128)   NULL,
    [ServicePackMajorVersion] INT              NULL,
    [ServicePackMinorVersion] INT              NULL,
    [BootDevice]              NVARCHAR (255)   NULL,
    [SystemDevice]            NVARCHAR (255)   NULL,
    [WindowsDirectory]        NVARCHAR (255)   NULL,
    [SystemDirectory]         NVARCHAR (255)   NULL,
    [TotalVisibleMemorySize]  BIGINT           NULL,
    [InstallDate]             DATETIME2 (3)    NULL,
    [LastBootUpTime]          DATETIME2 (3)    NULL,
    [Status]                  NVARCHAR (50)    NULL,
    [Active]                  BIT              CONSTRAINT [DF_cm_OperatingSystem_Active] DEFAULT ((1)) NOT NULL,
    [dbAddDate]               DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]            DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_OperatingSystem] PRIMARY KEY CLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OperatingSystem_Computer] FOREIGN KEY ([computerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

GO
CREATE INDEX [IX_OperatingSystem_ComputerGUID] ON [cm].[OperatingSystem](ComputerGUID)
