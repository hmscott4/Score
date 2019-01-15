CREATE TABLE [cm].[LinkedServerLogin] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_LinkedServerLogin_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [LinkedServerID]       INT              NOT NULL,
    [Name]                 NVARCHAR (255)   NOT NULL,
    [Impersonate]          BIT              NOT NULL,
    [State]                NVARCHAR (128)   NOT NULL,
    [DateLastModified]     DATETIME2 (3)    NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_LinkedServerLogin] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_LinkedServerLogin_LinkedServer] FOREIGN KEY ([DatabaseInstanceGUID], [LinkedServerID]) REFERENCES [cm].[LinkedServer] ([DatabaseInstanceGUID], [ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_LinkedServerLogin_Unique]
    ON [cm].[LinkedServerLogin]([DatabaseInstanceGUID] ASC, [LinkedServerID] ASC, [Name] ASC);

