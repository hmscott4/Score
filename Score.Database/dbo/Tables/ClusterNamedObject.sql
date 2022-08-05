CREATE TABLE [dbo].[ClusterNamedObject] (
    [objectGUID]   UNIQUEIDENTIFIER NOT NULL,
    [Domain]       NVARCHAR (255)   NOT NULL,
    [DNSHostName]  NVARCHAR (255)   NOT NULL,
    [Comment]      NVARCHAR (2048)  NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ClusterNamedObject] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

