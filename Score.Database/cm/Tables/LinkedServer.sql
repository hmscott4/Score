CREATE TABLE [cm].[LinkedServer] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_LinkedServer_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [ID]                   INT              NOT NULL,
    [Name]                 NVARCHAR (255)   NOT NULL,
    [DataSource]           NVARCHAR (255)   NOT NULL,
    [Catalog]              NVARCHAR (255)   NULL,
    [ProductName]          NVARCHAR (255)   NULL,
    [Provider]             NVARCHAR (255)   NULL,
    [ProviderString]       NVARCHAR (1024)  NULL,
    [DistPublisher]        BIT              NOT NULL,
    [Distributor]          BIT              NOT NULL,
    [Publisher]            BIT              NOT NULL,
    [Subscriber]           BIT              NOT NULL,
    [Rpc]                  BIT              NOT NULL,
    [RpcOut]               BIT              NOT NULL,
    [DataAccess]           BIT              NOT NULL,
    [DateLastModified]     DATETIME2 (3)    NOT NULL,
    [State]                NVARCHAR (128)   NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_LinkedServer] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_LinkedServer_DatabaseInstance] FOREIGN KEY ([DatabaseInstanceGUID]) REFERENCES [cm].[DatabaseInstance] ([objectGUID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LinkedServer_Unique]
    ON [cm].[LinkedServer]([DatabaseInstanceGUID] ASC, [ID] ASC);

