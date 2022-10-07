CREATE TABLE [cm].[DiskPartition] (
    [objectGUID]       UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DiskPartition_objectGUID] DEFAULT (newid()) NOT NULL,
    [ComputerGUID]     UNIQUEIDENTIFIER NOT NULL,
    [Name]             NVARCHAR (255)   NOT NULL,
    [DiskIndex]        INT              NOT NULL,
    [Index]            INT              NOT NULL,
    [DeviceID]         NVARCHAR (255)   NOT NULL,
    [Bootable]         BIT              NOT NULL,
    [BootPartition]    BIT              NOT NULL,
    [PrimaryPartition] BIT              NOT NULL,
    [StartingOffset]   BIGINT           NULL,
    [Size]             BIGINT           NOT NULL,
    [Active]           BIT              NOT NULL,
    [dbAddDate]        DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]     DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DiskPartition] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DiskPartition_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

