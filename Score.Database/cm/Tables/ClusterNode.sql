CREATE TABLE [cm].[ClusterNode] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ClusterNode_objectGUID] DEFAULT (newid()) NOT NULL,
    [ClusterGUID]  UNIQUEIDENTIFIER NOT NULL,
    [ComputerGUID] UNIQUEIDENTIFIER NOT NULL,
    [State]        NVARCHAR (128)   NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ClusterNode] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

