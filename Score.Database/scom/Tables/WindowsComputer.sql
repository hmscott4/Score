CREATE TABLE [scom].[WindowsComputer] (
    [ID]                          UNIQUEIDENTIFIER NOT NULL,
    [DNSHostName]                 NVARCHAR (255)   NOT NULL,
    [IPAddress]                   NVARCHAR (255)   NULL,
    [ObjectSID]                   NVARCHAR (255)   NULL,
    [NetBIOSDomainName]           NVARCHAR (255)   NULL,
    [DomainDNSName]               NVARCHAR (255)   NULL,
    [OrganizationalUnit]          NVARCHAR (2048)  NULL,
    [ForestDNSName]               NVARCHAR (255)   NULL,
    [ActiveDirectorySite]         NVARCHAR (255)   NULL,
    [IsVirtualMachine]            BIT              NULL,
    [HealthState]                 NVARCHAR (255)   NULL,
    [StateLastModified]           DATETIME2 (3)    NULL,
    [IsAvailable]                 BIT              NULL,
    [AvailabilityLastModified]    DATETIME2 (3)    NULL,
    [InMaintenanceMode]           BIT              NULL,
    [MaintenanceModeLastModified] DATETIME2 (3)    NULL,
    [ManagementGroup]             NVARCHAR (255)   NULL,
    [Active]                      BIT              NOT NULL,
    [dbAddDate]                   DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]                DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_scom_WindowsComputer] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_scom_WindowsComputer]
    ON [scom].[WindowsComputer]([DNSHostName] ASC);

