CREATE TABLE [cm].[LogicalVolume] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_LogicalVolume_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID] UNIQUEIDENTIFIER NOT NULL,
    [Name]         NVARCHAR (128)   NOT NULL,
    [DriveLetter]  NVARCHAR (128)   NULL,
    [Label]        NVARCHAR (128)   NULL,
    [FileSystem]   NVARCHAR (128)   NOT NULL,
    [BlockSize]    INT              NOT NULL,
    [SerialNumber] NVARCHAR (128)   NOT NULL,
    [Capacity]     BIGINT           NOT NULL,
    [SpaceUsed]    BIGINT           CONSTRAINT [DF_cm_LogicalVolume_SpaceUsed] DEFAULT ((0)) NULL,
    [SystemVolume] BIT              NOT NULL,
    [IsClustered]  BIT              NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_LogicalVolume] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_LogicalVolume_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

