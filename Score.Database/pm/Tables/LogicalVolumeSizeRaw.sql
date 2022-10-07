CREATE TABLE [pm].[LogicalVolumeSizeRaw] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [DateTime]          DATETIME2 (3)    NOT NULL,
    [ComputerGUID]      UNIQUEIDENTIFIER NOT NULL,
    [LogicalVolumeGUID] UNIQUEIDENTIFIER NOT NULL,
    [SpaceUsed]         BIGINT           NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_LogicalVolumeSizeRaw] PRIMARY KEY CLUSTERED ([ID] ASC)
);

