CREATE TABLE [pm].[LogicalVolumeSizeDaily] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [Date]              DATE             NOT NULL,
    [ComputerGUID]      UNIQUEIDENTIFIER NOT NULL,
    [LogicalVolumeGUID] UNIQUEIDENTIFIER NOT NULL,
    [SpaceUsed]         BIGINT           NOT NULL,
    [MaxSpaceUsed]      BIGINT           NOT NULL,
    [MinSpaceUsed]      BIGINT           NOT NULL,
    [StDevSpaceUsed]    DECIMAL (18, 3)  NOT NULL,
    [Count]             INT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_LogicalVolumeSizeDaily] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LogicalVolumeSizeDaily_LogicalVolume] FOREIGN KEY ([ComputerGUID], [LogicalVolumeGUID]) REFERENCES [cm].[LogicalVolume] ([ComputerGUID], [objectGUID])
);

