CREATE TABLE [cm].[DatabaseFile] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabaseFile_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseGUID] UNIQUEIDENTIFIER NOT NULL,
    [FileID]       INT              NOT NULL,
    [FileGroup]    NVARCHAR (255)   NOT NULL,
    [LogicalName]  NVARCHAR (255)   NOT NULL,
    [PhysicalName] NVARCHAR (2048)  NOT NULL,
    [FileSize]     BIGINT           NOT NULL,
    [MaxSize]      BIGINT           NOT NULL,
    [SpaceUsed]    BIGINT           NOT NULL,
    [Growth]       BIGINT           NOT NULL,
    [GrowthType]   NVARCHAR (128)   NOT NULL,
    [IsReadOnly]   BIT              NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabaseFile] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DatabaseFile_Database] FOREIGN KEY ([DatabaseGUID]) REFERENCES [cm].[Database] ([objectGUID])
);

