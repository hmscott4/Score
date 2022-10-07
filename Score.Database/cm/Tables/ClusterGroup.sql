CREATE TABLE [cm].[ClusterGroup] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ClusterGroup_objectGUID] DEFAULT (newid()) NOT NULL,
    [ClusterGUID]  UNIQUEIDENTIFIER NOT NULL,
    [GroupName]    NVARCHAR (255)   NOT NULL,
    [Description]  NVARCHAR (1024)  NULL,
    [OwnerNode]    NVARCHAR (255)   NOT NULL,
    [State]        NVARCHAR (128)   NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ClusterGroup] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ClusterGroup_Cluster] FOREIGN KEY ([ClusterGUID]) REFERENCES [cm].[Cluster] ([objectGUID])
);

