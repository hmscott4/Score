CREATE TABLE [cm].[DrivePartitionMap] (
    [ObjectGUID]    UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DrivePartitionMap_objectGUID] DEFAULT (newid()) NOT NULL,
    [ComputerGUID]  UNIQUEIDENTIFIER NOT NULL,
    [PartitionName] NVARCHAR (128)   NOT NULL,
    [DriveName]     NVARCHAR (128)   NOT NULL,
    [Active]        BIT              NOT NULL,
    [dbAddDate]     DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]  DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DrivePartitionMap] PRIMARY KEY CLUSTERED ([ObjectGUID] ASC),
    CONSTRAINT [FK_DrivePartitionMap_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DrivePartitionMap_Unique]
    ON [cm].[DrivePartitionMap]([ComputerGUID] ASC, [PartitionName] ASC, [DriveName] ASC);

