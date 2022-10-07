CREATE TABLE [ad].[ClusterNamedObject] (
    [objectGUID]   UNIQUEIDENTIFIER NOT NULL,
    [Domain]       NVARCHAR (128)   NOT NULL,
    [DNSHostName]  NVARCHAR (255)   NOT NULL,
    [Comment]      NVARCHAR (2048)  NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_ClusterNamedObject] PRIMARY KEY CLUSTERED ([DNSHostName] ASC)
);


GO

