﻿CREATE TABLE [cm].[NetworkAdapterConfiguration] (
    [objectGUID]                  UNIQUEIDENTIFIER CONSTRAINT [DF_cm_NetworkAdapterConfiguration_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID]                UNIQUEIDENTIFIER NOT NULL,
    [Index]                       INT              NOT NULL,
    [MACAddress]                  NVARCHAR (128)   NULL,
    [IPV4Address]                 NVARCHAR (255)   NULL,
    [SubnetMask]                  NVARCHAR (128)   NULL,
    [DefaultIPGateway]            NVARCHAR (128)   NULL,
    [DNSDomainSuffixSearchOrder]  NVARCHAR (255)   NULL,
    [DNSServerSearchOrder]        NVARCHAR (255)   NULL,
    [DNSEnabledForWINSResolution] BIT              NOT NULL,
    [FullDNSRegistrationEnabled]  BIT              NOT NULL,
    [DHCPEnabled]                 BIT              NOT NULL,
    [DHCPLeaseObtained]           DATETIME2 (3)    NULL,
    [DHCPLeaseExpires]            DATETIME2 (3)    NULL,
    [DHCPServer]                  NVARCHAR (128)   NULL,
    [WINSPrimaryServer]           NVARCHAR (128)   NULL,
    [WINSSecondaryServer]         NVARCHAR (128)   NULL,
    [IPEnabled]                   BIT              NOT NULL,
    [Active]                      BIT              NOT NULL,
    [dbAddDate]                   DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]                DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_NetworkAdapterConfiguration] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_NetworkAdapterConfiguration_ComputerGUID] FOREIGN KEY ([ComputerGUID],[Index]) REFERENCES [cm].[NetworkAdapter] ([ComputerGUID],[Index])
);

GO
CREATE NONCLUSTERED INDEX [IX_NetworkAdapterConfiguration_ComputerGUID]
    ON [cm].[NetworkAdapterConfiguration](ComputerGUID, [Index])

