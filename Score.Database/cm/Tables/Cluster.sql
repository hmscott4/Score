CREATE TABLE [cm].[Cluster] (
    [objectGUID]             UNIQUEIDENTIFIER CONSTRAINT [DF_cm_Cluster_objectGUID] DEFAULT (newid()) NOT NULL,
    [ClusterName]            NVARCHAR (255)   NOT NULL,
    [OperatingSystem]        NVARCHAR (255)   NULL,
    [OperatingSystemVersion] NVARCHAR (128)   NULL,
    [Active]                 BIT              NOT NULL,
    [dbAddDate]              DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]           DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Cluster] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

