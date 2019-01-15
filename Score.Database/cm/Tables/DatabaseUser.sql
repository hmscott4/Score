CREATE TABLE [cm].[DatabaseUser] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabaseUser_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [DatabaseName]         NVARCHAR (128)   NOT NULL,
    [UserName]             NVARCHAR (128)   NOT NULL,
    [Login]                NVARCHAR (128)   NOT NULL,
    [UserType]             NVARCHAR (128)   NOT NULL,
    [LoginType]            NVARCHAR (128)   NOT NULL,
    [HasDBAccess]          BIT              NOT NULL,
    [CreateDate]           DATETIME2 (3)    NOT NULL,
    [DateLastModified]     DATETIME2 (3)    NULL,
    [State]                NVARCHAR (128)   NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabaseUser] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DatabaseUser_DatabaseInstance] FOREIGN KEY ([DatabaseInstanceGUID]) REFERENCES [cm].[DatabaseInstance] ([objectGUID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_DatabaseUser_Unique]
    ON [cm].[DatabaseUser]([DatabaseInstanceGUID] ASC, [DatabaseName] ASC, [UserName] ASC);

