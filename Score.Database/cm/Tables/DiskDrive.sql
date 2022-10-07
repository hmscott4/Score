CREATE TABLE [cm].[DiskDrive] (
    [objectGUID]       UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DiskDrive_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID]     UNIQUEIDENTIFIER NOT NULL,
    [Name]             NVARCHAR (128)   NOT NULL,
    [DeviceID]         NVARCHAR (128)   NOT NULL,
    [Manufacturer]     NVARCHAR (255)   NULL,
    [Model]            NVARCHAR (255)   NULL,
    [SerialNumber]     NVARCHAR (128)   NULL,
    [FirmwareRevision] NVARCHAR (128)   NULL,
    [Partitions]       INT              NULL,
    [InterfaceType]    NVARCHAR (128)   NOT NULL,
    [SCSIBus]          INT              NULL,
    [SCSIPort]         INT              NULL,
    [SCSILogicalUnit]  INT              NULL,
    [SCSITargetID]     INT              NULL,
    [Size]             BIGINT           NOT NULL,
    [Status]           NVARCHAR (128)   NULL,
    [Active]           BIT              NOT NULL,
    [dbAddDate]        DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]     DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DiskDrive] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DiskDrive_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

