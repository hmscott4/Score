CREATE TABLE [cm].[ClusterResource] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ClusterResource_objectGUID] DEFAULT (newid()) NOT NULL,
    [ClusterGUID]  UNIQUEIDENTIFIER NOT NULL,
    [ResourceName] NVARCHAR (255)   NOT NULL,
    [ResourceType] NVARCHAR (255)   NOT NULL,
    [OwnerGroup]   NVARCHAR (255)   NOT NULL,
    [OwnerNode]    NVARCHAR (255)   NOT NULL,
    [State]        NVARCHAR (128)   NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ClusterResource] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

